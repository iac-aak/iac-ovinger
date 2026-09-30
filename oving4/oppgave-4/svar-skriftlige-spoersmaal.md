# Oppgave 4 – Skriftlige svar

Kortnavn: `aak`. Backend: `rg-tfstate-aak` / `satfstateaak` / container `tfstate`.

---

## Del A – K1: Hvorfor har bootstrap-stacken lokal state?

Bootstrap-stacken er den som oppretter storage account-et og containeren som all annen state skal ligge i. Hadde den selv hatt en `backend "azurerm"`-blokk, måtte Terraform lagre state i en container som ikke finnes ennå. `init` ville feilet før noe var opprettet (høna-og-egget-problemet). Backend-blokka leses ved `init`, før noen ressurser er laget, og den kan heller ikke bruke variabler eller referanser til ressurser.

Lokal state er akseptabelt her av tre grunner:

- Stacken er liten og består av bare fire ressurser: ressursgruppe, storage account, container og rolletildeling.
- Den kjøres én gang og endres nesten aldri, så faren for at to personer kjører samtidig er liten. Da trenger vi ikke lås eller deling.
- Skulle den lokale state-fila gå tapt, er ikke infrastrukturen borte. Ressursene finnes fortsatt i Azure og kan importeres på nytt. Ingen andre stacks er avhengige av at fila finnes, fordi de bare trenger *adressen* til backend-en (`backend.hcl`).

Ressursgruppa har `keep = "true"`, så den nattlige oppryddingsjobben sletter den ikke.

---

## Del D – Beviset

### D.2 – Låsen

Feilmeldingen (skjermbilde `image1.png`) kom da jeg kjørte `terraform plan` i `environments/dev/app` mens en `apply` gikk i samme stack:

```
Error: Error acquiring the state lock
Error message: state blob is already locked
Lock Info:
  ID:        5bcb890a-239d-b5a0-7d5a-4d3b97431695
  Path:      tfstate/dev/app.tfstate
  Operation: OperationTypeApply
  Who:       andreaskyte@Andreas-sin-MacBook-Pro.local
  Version:   1.16.4
  Created:   2026-09-30 15:57:02.666946 +0000 UTC
```

**Hvem holder låsen?** Det er `apply`-kommandoen i den første terminalen. Feilmeldingen viser `Who: andreaskyte@Andreas-sin-MacBook-Pro.local` og `Operation: OperationTypeApply`. Det er altså min egen bruker og maskin, men det er en annen prosess. Låsen ligger som en *lease* på state-blobben `dev/app.tfstate` i Azure Storage. Den ble tatt idet `apply` startet og frigis når `apply` er ferdig.

**Hvorfor finnes den?** State er den eneste kilden til hva Terraform tror finnes. Hvis to kjøringer leser og skriver samme state-fil samtidig, kan de overskrive hverandres endringer (lost update). Resultatet kan bli en state som ikke stemmer med virkeligheten: ressurser Terraform ikke vet om, eller duplikater. Låsen tvinger kjøringene til å gå etter hverandre. Fordi låsen ligger i Azure og ikke på maskinen min, virker den også mellom flere personer som deler backend, noe lokal state aldri kunne gjort. Meldingen advarer mot `-lock=false`, og det er riktig å la den stå. Det passer bare i nødsituasjoner, for eksempel når en krasjet kjøring har latt en gammel lås stå.

### D.3 – Feil rekkefølge

Feilmeldingen (skjermbilde `image2.png`) kom fra `prod/app` da `prod/nettverk` ikke var rullet ut:

```
Error: Unsupported attribute

  on main.tf line 66, in module "compute":
  66:   subnet_id = data.terraform_remote_state.nettverk.outputs.subnet_ids[var.vm_subnet_key]

  data.terraform_remote_state.nettverk.outputs is object with no attributes
  This object does not have an attribute named "subnet_ids".
```

**Hvorfor sier den ikke at den andre stacken mangler?** Fordi `terraform_remote_state` ikke sjekker at den andre stacken finnes. Den leser bare en state-blob med en gitt `key` (`prod/nettverk.tfstate`) og pakker ut `outputs` derfra. Når keyen ikke finnes, får den en tom state tilbake, uten ressurser og uten outputs. Det er samme oppførsel som for en helt ny, tom stack, og det regnes ikke som en feil. Data source-en lykkes derfor, med `outputs = {}`. Feilen kommer først når koden prøver å bruke `outputs.subnet_ids`, som ikke finnes. Terraform vet bare at attributtet mangler i et objekt. Den vet ikke *hvorfor*, og den kan ikke skille «stacken er ikke utrullet ennå» fra «stacken har ikke denne outputen» eller «keyen er skrevet feil».

Feilmeldingen forteller altså om symptomet i app-stacken og ikke om årsaken i nettverks-stacken. Derfor er rekkefølgen mellom stacks mitt ansvar som bruker. Terraform kjenner bare avhengighetsgrafen *innenfor* én stack, og ingenting i koden uttrykker at `app` må rulles ut etter `nettverk`.

Bildet viser også at `plan` foreslo å opprette ressursgruppa (`Plan: 1 to add`) før den feilet på subnett-ID-en. Ressursene som ikke avhenger av den andre stacken, planlegges altså som vanlig.

---

## Vurderingen

**Hvor mange verdier krysser grensa?** Det er *én* verdi som brukes: subnett-ID-en for subnettet `web`. Den slås opp i `subnet_ids`-outputen med `var.vm_subnet_key`. Nettverks-stacken publiserer i tillegg `vnet_name`, men den leser app-stacken ikke. Selve outputen `subnet_ids` er et map med tre subnett (`web`, `app`, `data`), så grensesnittet er litt bredere enn det app-stacken trenger. Bortsett fra det deler stackene bare `key` og adressen til backend-en.

**Ble den ene rullet ut uten den andre?** Nei, i `dev` fulgtes de alltid ad. Nettverket ble applyet først, deretter appen. Ved opprydding gikk jeg motsatt vei: app først, nettverk sist. Det eneste tilfellet der de ikke fulgtes ad, var forsøket i `prod` i D.3. Der viste det seg at app-stacken ikke kan planlegges uten at nettverket finnes. Det er en *rekkefølgeavhengighet*, og den gjelder bare én vei: nettverket kan stå uten appen, men appen ikke uten nettverket.

**Løst eller tett koblet?** Etter min vurdering er koblingen forholdsvis løs på data, men tett på tidspunkt og rekkefølge. Løs, fordi bare én verdi krysser grensa, gjennom et navngitt grensesnitt (root-output), og fordi ingen av stackene kjenner den andres kode. Modulene er uendret, og nettverket kunne byttes ut så lenge `subnet_ids` fortsatt finnes. Tett, fordi app-stacken ikke kan kjøres i det hele tatt uten at nettverkets state finnes, noe D.3 viste. I tillegg leser `terraform_remote_state` hele state-fila, mens outputs er det eneste som er ment å være grensesnitt. Det gir app-stacken lesetilgang til alt i nettverkets state, og koblingen avhenger av at `key` og outputnavn er like i begge stacks. Feilmeldingen i D.3 var dessuten vanskelig å tolke, som er typisk for skjult kobling.

**Beholde oppdelingen eller slå sammen?** I et ekte prosjekt ville jeg beholdt oppdelingen, men bare fordi lagene har ulik endringstakt og ulikt eierskap. Nettverk endres sjelden og er dyrt å ødelegge, mens VM-er endres og rives ofte. Med to stacks kan en `apply` eller `destroy` i `app` aldri ta med seg vnet og subnett (mindre skadeomfang). Det åpner også for at ulike team eier hver sin del med hver sin lås og tilgang. Et enkelt eksempel er at en `plan` i `app` ikke trenger å oppdatere nettverksressurser. Med kun én VM og tre subnett for én student hadde en enkelt stack vært enklere og mer robust. Det hadde spart oss to `init`-er, to keyer, remote state-oppslaget og en rekkefølge vi må huske selv. Prisen for oppdelingen er nettopp den manuelle rekkefølgen og den skjulte koblingen. Jeg ville derfor delt oppsettet opp bare der det finnes en reell grunn (ulike team, ulik endringsfrekvens eller behov for å begrense skadeomfang), og ellers holdt det samlet.

# Oppgave 3 – svar på tekstspørsmålene

Kode og kommandoer ligger i README og mappene. Her er de skriftlige svarene.

## Del C – hvorfor er den ene endringen billig og den andre dyr?

Begge er én linje i `terraform.tfvars`, men de rører ulike ting.

**Fjerne `app` fra `subnets`.** Nøkkelen `"app"` er identiteten i state
(`azurerm_subnet.subnet["app"]`). Forsvinner nøkkelen, forsvinner bare den
instansen. `web` og `data` har sine egne nøkler og uendrede `netnum`, så de er
ikke berørt. Planen rev `subnet["app"]` og NSG-koblingen `snet_nsg["app"]`, og
ingenting annet. VM-en står i `web` og blir liggende.

**Endre `address_space`.** Alle prefiksene regnes ut fra adresserommet med
`cidrsubnet(var.address_space, 8, netnum)`. Ny adresse gir nytt prefiks for
hvert subnett, og et subnett kan ikke endre adresse i drift. Terraform må derfor
rive og gjenskape alle subnettene, og alt som henger på dem (NSG-koblinger, og
NIC-en for VM-en i `web`). Vnet-et selv kan oppdateres på stedet.

**Forskjellen.** Den første endringen fjerner en identitet, og de andre er
uavhengige av den. Den andre endringen forandrer en verdi som alle instansene
er utledet fra. Hvor mye som rives avhenger av hva som henger sammen, ikke av
hvor mange linjer jeg endrer. Det er også derfor `netnum` står skrevet ned i
mapet: med `index()` eller `count` ville selv den første endringen flyttet
adressene til `data`, og da hadde den vært like dyr.

## K4 – hvorfor `netnum` er skrevet ned

Utledet `netnum` (posisjon) forskyver seg når settet endres. Da bytter subnett
IP-adresse, og må rives og bygges på nytt med alt de bærer. Skrevet ned er det
data som ligger i ro.

## Hvor mange stacks har oppsettet? (kap. 7)

Tre stacks, fordi det er tre state-filer: `environments/dev`, `test` og `prod`.
De er **tre instanser av samme stack**, ikke tre ulike stacks. Koden er
identisk (K1), bare tfvars skiller dem. `stacks/` har ingen state og teller
ikke.

Innenfor hver stack ligger nettverk og compute i samme stack, som to moduler:

| Kriterium | Nettverk vs. compute i oppgaven |
|---|---|
| Blast radius | En feil i ett påvirker lite i det andre |
| Endringstakt | Endres samtidig mens jeg jobber |
| Eierskap | Meg, begge |
| Livssyklus | Rives med samme `destroy` |

Ingen kriterier peker mot en grense, så én stack med to moduler er riktig.
Skulle nettverket delt seg ut i en hub som flere andre kobler seg til, ville
eierskap og livssyklus tilsi en egen stack.

Dev og prod holdes i hver sin state fordi blast radius peker mot skille: en
feil `apply` i dev skal aldri kunne ramme prod.

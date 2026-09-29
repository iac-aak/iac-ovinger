# Oppgave 3 – aak

Min versjon av oppgave 3, bygd videre fra oppgave 2: Linux-VM med SSH-nøkkel,
`westeurope`, prefiks `aak`.

| Miljø | Adresserom | Subnett | VM-størrelse | Rulles ut? |
|---|---|---|---|---|
| dev  | 10.162.0.0/16 | web, app, data       | Standard_B2as_v2 | Ja |
| test | 10.163.0.0/16 | web, app, data       | Standard_B2as_v2 | Nei, bare plan |
| prod | 10.164.0.0/16 | web, app, data, mgmt | Standard_D2s_v5  | Ja |

Struktur: `modules/` (network, compute) → `stacks/` (setter dem sammen, uten
state) → `environments/<miljø>/` (den egentlige stacken med state).

## Kjøre

```bash
az login
cd environments/dev  && terraform init && terraform plan && terraform apply
cd ../prod           && terraform init && terraform plan && terraform apply
cd ../test           && terraform init && terraform plan   # ikke apply
```

## Del C

I `environments/dev`, endre `terraform.tfvars`, kjør `terraform plan`, og sett
tilbake etterpå:

1. Fjern `app` fra `subnets`. Bare `subnet["app"]` og NSG-koblingen for `app`
   rives. VM-en ligger i `web` og berøres ikke.
2. Legg `app` tilbake og endre `address_space` til `10.172.0.0/16`. Alle
   subnett byttes ut.

## Kravsjekk

```bash
diff environments/dev/main.tf environments/prod/main.tf    # K1, tom
diff environments/dev/main.tf environments/test/main.tf    # K1, tom
grep -rnE '"[0-9]{1,3}(\.[0-9]{1,3}){3}/[0-9]{1,2}"' modules/   # K2, tom
grep -rn 'resource "azurerm_subnet"' modules/                   # K3, ett treff
```

## Rydde opp

```bash
cd environments/dev  && terraform destroy
cd ../prod           && terraform destroy
```

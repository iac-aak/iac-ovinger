# Oppgave 3 – aak

Personlig versjon av løsningsforslaget (`../losningsforslag/`), bygd videre fra
Oppgave 2: Linux-VM med SSH-nøkkel, `westeurope`, prefiks `aak`.

| Miljø | Adresserom | Subnett | VM-størrelse | Rulles ut? |
|---|---|---|---|---|
| dev  | 10.162.0.0/16 | web, app, data       | Standard_B2as_v2 | Ja |
| test | 10.163.0.0/16 | web, app, data       | Standard_B2as_v2 | Nei – bare plan |
| prod | 10.164.0.0/16 | web, app, data, mgmt | Standard_D2s_v5  | Ja |

Ressursnavn: `rg-oppg3-dev-aak`, `vnet-oppg3-dev-aak`, `snet-app-oppg3-dev-aak`,
`nsg-oppg3-dev-aak`, `nic-oppg3-dev-aak`, `vm-oppg3-dev-aak`.

## Kjøre

`terraform.tfvars` lastes automatisk, så ingen `-var-file` trengs.

```bash
az login
cd environments/dev  && terraform init && terraform plan && terraform apply
cd ../prod           && terraform init && terraform plan && terraform apply
cd ../test           && terraform init && terraform plan     # IKKE apply
```

## Del C – beviset

```bash
cd environments/dev
terraform state list                 # ...subnet["app"], ikke subnet[0]

# 1) Fjern "app" (det midterste) fra subnets i terraform.tfvars -> terraform plan
#    Forventet: subnet["app"] og NSG-koblingen snet_nsg["app"] rives, web og data
#    nevnes ikke. VM-en ligger i "web" (vm_subnet_key), så den berøres ikke.
# 2) Legg "app" tilbake, endre address_space til f.eks. 10.172.0.0/16 -> terraform plan
#    Forventet: alle subnett (og det som henger på dem) må byttes ut, vnet oppdateres
# Sett verdiene tilbake etterpå.
```

## Sjekk kravene

```bash
diff environments/dev/main.tf environments/prod/main.tf    # K1 – tom
diff environments/dev/main.tf environments/test/main.tf    # K1 – tom
grep -rnE '"[0-9]{1,3}(\.[0-9]{1,3}){3}/[0-9]{1,2}"' modules/   # K2 – tom
grep -rn 'resource "azurerm_subnet"' modules/                   # K3 – ett treff
grep -n 'for_each' modules/network/main.tf                      # K5
```

## Rydde opp

```bash
cd environments/dev  && terraform destroy
cd ../prod           && terraform destroy
```

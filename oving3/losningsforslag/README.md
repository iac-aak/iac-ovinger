# Oppgave 3 – kjørbart løsningsforslag
 
Referanseløsningen på Del A–C. Koden er kommentert for å bli lest: hver
`.tf`-fil forklarer *hvorfor* den er skrevet som den er, ikke bare hva den
gjør.
 
## Før du kjører
 
```bash
# 1. Bytt kortnavn i alle tre tfvars-filene
grep -rn 'shortname' environments/*/terraform.tfvars
 
# 2. Logg inn i riktig tenant
az login --tenant "<tenant-id-fra-Canvas>"
az account show --query '{tenant:tenantId, sub:name}'
 
# 3. Passordet settes som miljøvariabel, ikke i tfvars
export TF_VAR_admin_password='<et-langt-passord>'
```
 
Passordet ligger uansett i klartekst i state-fila – Terraform noterer alt den
har opprettet. Miljøvariabelen holder det i det minste ute av Git. Den
ordentlige løsningen er Key Vault og en managed identity, som kommer senere i
emnet.
 
## Kjøre
 
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```
 
`test` skal bare planlegges, aldri rulles ut:
 
```bash
cd environments/test
terraform init
terraform plan          # beviset på at et tredje miljø ikke krevde kodeendringer
```
 
## Rydde opp
 
```bash
cd environments/dev  && terraform destroy
cd ../prod           && terraform destroy
```
 
En virtuell maskin koster penger så lenge den går, og her er det to av dem.
 
## Sjekk kravene selv
 
```bash
# K1 – identiske miljøfiler
diff environments/dev/main.tf environments/prod/main.tf
diff environments/dev/main.tf environments/test/main.tf
 
# K2 – ingen CIDR skrevet inn i modulene
grep -rnE '"[0-9]{1,3}(\.[0-9]{1,3}){3}/[0-9]{1,2}"' modules/
 
# K3 – én subnet-blokk
grep -rn 'resource "azurerm_subnet"' modules/
 
# K5 – NSG-koblingen følger subnettene
grep -n 'for_each' modules/network/main.tf
```
 
De to første skal gi tom utskrift. Merk at et naivt søk etter `10.` også
treffer kommentarene i denne løsningen — de nevner adresser med vilje, for å
forklare dem.
 
## Mappene
 
| Mappe | Rolle | State? |
|---|---|---|
| `modules/network/`, `modules/compute/` | Én komponent hver | Nei |
| `stacks/` | Setter komponentene sammen. Er en Terraform-modul, ikke en stack | Nei |
| `environments/dev,test,prod/` | Root modules. Her kjører du kommandoene | Ja – én hver |
 
`.terraform.lock.hcl` er utelatt fra Git med vilje: den låser provider-hasher
per plattform, og studentene kjører på både macOS, Windows og Linux. I et ekte
prosjekt skal den derimot committes.
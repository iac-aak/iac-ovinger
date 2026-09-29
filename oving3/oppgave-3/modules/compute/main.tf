# =============================================================================
#  modules/compute/  –  compute-komponenten
# -----------------------------------------------------------------------------
#  Nettverkskort og virtuell maskin. Modulen får subnet-ID-en utlevert og slår
#  den aldri opp selv – den vet ikke engang at det finnes en nettverksmodul.
#  Det er den egenskapen som gjør at den kan gjenbrukes et helt annet sted.
#
#  Bygd videre fra modules/compute i Oppgave 2: Linux (Ubuntu 22.04) med
#  SSH-nøkkel i stedet for Windows med passord. Da slipper vi et passord som
#  havner i klartekst i state.
# =============================================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

locals {
  # Linux tåler bindestreker og opptil 64 tegn i computer_name, så her holder
  # det å gjenbruke ressursnavnet. (Windows ville krevd maks 15 tegn og ingen
  # bindestreker.) Uansett hører regelen hjemme HER i modulen (K7), ikke i
  # miljømappa.
  #   "oppg3-dev-aak" -> "vm-oppg3-dev-aak"
  vm_name = format("vm-%s", var.base_name)
}

resource "azurerm_network_interface" "nic" {
  name                = format("nic-%s", var.base_name)
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  ip_configuration {
    name = "ipconfig1"

    # Subnettet kommer inn som en variabel. Modulen har ingen data-blokk som
    # leter det opp, og ingen ID skrevet inn for hånd – den får det utlevert
    # av den som setter komponentene sammen.
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = local.vm_name
  computer_name       = local.vm_name
  location            = var.location
  resource_group_name = var.rg_name

  # Størrelsen kommer utenfra – det er den som skiller dev fra prod.
  size = var.vm_size

  admin_username = var.admin_username

  # Merk hakeparentesene: en VM kan ha flere nettverkskort, så argumentet er
  # en liste selv når vi bare har ett.
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = var.tags
}

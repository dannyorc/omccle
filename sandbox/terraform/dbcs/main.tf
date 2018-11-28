// Created by Zach Hamilton: zach.hamilton@oracle.com

locals {
  database_service_name  = "batadase"
  ADSN                   = 1
  availability_domain    = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[local.ADSN],"name")}"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.compartment_ocid}"
}

# Oracle Database Instance
resource "oraclepaas_database_service_instance" "database" {
  count             = 1
  name              = "${local.database_service_name}"
  description       = "Created by Ferratorm"
  version           = "12.2.0.1"
  edition           = "EE"
  subscription_type = "HOURLY"
  ssh_public_key    = "${join(" ",slice(split(" ",file("~/.ssh/sshkey.pub")),0,2))}"

  bring_your_own_license = true

  # OCI Settings
  region              = "${var.region}"
  availability_domain = "${local.availability_domain}"
  shape               = "VM.Standard2.1"

  # DB Configuration
  database_configuration {
    admin_password     = "Adm1npassw0rd_"
    backup_destination = "NONE"
    sid                = "ORCL"
    usable_storage     = 50
  }
}
// Created by Zach Hamilton: zach.hamilton@oracle.com

locals {
  java_service_name   = "lebwogic"
  AD                  = 2
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[local.AD],"name")}"
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.compartment_ocid}"
}

resource "oraclepaas_java_service_instance" "jcs" {
  name        = "${local.java_service_name}"
  description = "Created by Ferratorm"

  edition                = "EE"            
  service_version        = "12cRelease213" 
  metering_frequency     = "HOURLY"        
  bring_your_own_license = true

  ssh_public_key = "${file("~/.ssh/sshkey.pub")}"

  # OCI Settings
  region              = "${var.region}"
  availability_domain = "${local.availability_domain}"

  weblogic_server {
    shape = "VM.Standard2.2"

    database {
      name     = "${var.database_name}"
      username = "sys"
      password = "Adm1npassw0rd_"
    }

    admin {
      username = "weblogic"
      password = "Adm1npassw0rd_"
    }
  }

  backups {
    cloud_storage_container = "https://swiftobjectstorage.${var.region}.oraclecloud.com/v1/${var.tenancy_ocid}/${var.bucket_name}"
  }
}
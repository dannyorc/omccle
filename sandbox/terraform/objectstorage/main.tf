// Created by Zach Hamilton: zach.hamilton@oracle.com

## OBJECT STORAGE MOODULE MAIN
resource "oci_objectstorage_bucket" "backup_bucket" {
    compartment_id = "${var.compartment_ocid}"
    name           = "${var.bucket_name}"
    namespace      = "${var.bucket_namespace}"
}
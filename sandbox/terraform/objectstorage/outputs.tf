// Created by Zach Hamilton: zach.hamilton@oracle.com

## OBJECT STORAGE MODULE OUTPUTS
#output "backup_bucket_name" {
#	description = "name of new object storage bucket"
#	value		= "${oci_objectstorage_bucket.this.name}"
#}
#
#output "backup_bucket_namespace" {
#	description = "namespace of new object storage bucket"
#	value		= "${oci_objectstorage_bucket.this.namespace}"
#}
// Created by Zach Hamilton: zach.hamilton@oracle.com

##OCI PROVIDER VARIABLES
variable "tenancy_ocid"     {}
variable "user_ocid"        {}
variable "fingerprint"      {}
variable "private_key_path" {}
variable "region"		        {}
variable "compartment_ocid" {}

##PAAS PROVIDER VARIABLES
variable "opc_username"        {}
variable "opc_password"        {}
variable "opc_identity_domain" {}

##VCN VARIABLES
variable "vcn_display_name" {
	default = "ncv"
}
variable "vcn_cidr" {
	default = "10.0.0.0/16"
}

##OBJECT STORAGE VARIABLES
variable "bucket_name"      {}
variable "bucket_namespace" {}

#### FROM PROVIDER: OCI
##PROVIDER
provider "oci" {
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region           = "${var.region}"
}
## CREATE COMPARTMENT 
#module "compartment" {
#	source = "./compartment/"
#	compartment_ocid = "${var.compartment_ocid}"
#}
##SETUP VCN
module "vcn" {
  source           = "./vcn/"
  compartment_ocid = "${var.compartment_ocid}"
  vcn_display_name = "${var.vcn_display_name}"
  vcn_cidr         = "${var.vcn_cidr}"
}
##OBJECT STORAGE BUCKET
module "objectstorage" {
	source 			     = "./objectstorage/"
	compartment_ocid = "${var.compartment_ocid}"
	bucket_name 	   = "${var.bucket_name}"
	bucket_namespace = "${var.bucket_namespace}"
}
#### AUTH TOKEN FOR BUCKET
# k+giAIoRSKdh4VJXXR1:

#### IAM POLICY FOR PSM
# IAM Configurations
module "iam" {
  source = "./iam/"
  compartment_ocid = "${var.compartment_ocid}"
  compartment_name = "managedcompartmentforpaas"
  tenancy_ocid     = "${var.tenancy_ocid}"
}
#### FROM PROVIDER: PAAS
## PROVIDER
provider "oraclepaas" {
  user              = "${var.opc_username}"
  password          = "${var.opc_password}"
  identity_domain   = "${var.opc_identity_domain}"
  database_endpoint = "https://dbaas.oraclecloud.com"
  java_endpoint     = "https://jaas.oraclecloud.com"
}
## DBCS
#module "dbcs" {
#  source            = "./dbcs/"
#  region            = "${var.region}"
#  tenancy_ocid      = "${var.tenancy_ocid}"
#  compartment_ocid  = "${var.compartment_ocid}"
#}
## JCS
#module "jcs" {
#  source           = "./jcs/"
#  region           = "${var.region}"
#  tenancy_ocid     = "${var.tenancy_ocid}"
#  compartment_ocid = "${var.compartment_ocid}"
#  database_name    = "${module.dbcs.database_service_name}"
#  bucket_name      = "${var.bucket_name}"
#}
#
#
#
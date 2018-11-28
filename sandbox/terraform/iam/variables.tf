// Created by Zach Hamilton: zach.hamilton@oracle.com

variable "compartment_ocid" {}
variable "compartment_name" {}
variable "tenancy_ocid" {}

variable "policy_description" {
	default = "Access Policy for all users to manage PSM resources"
}
variable "policy_name" {
	default = "MngdCompPaaSUserAccessPolicy"
}
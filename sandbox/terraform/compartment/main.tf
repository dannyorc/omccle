# CREATE COMPARTMENT 

resource "oci_identity_compartment" "xob" {
	compartment_id = "${var.compartment_ocid}"
	description    = "Box for stuff"
	name           = "xob"
}
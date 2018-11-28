## OUTPUT FOR COMPARTMENT

output "box_name" {
	value = "${oci_identity_compartment.xob.name}"
}
output "box_id" {
	value = "${oci_identity_compartment.xob.id}"
}
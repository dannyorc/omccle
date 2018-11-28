## IAM MAIN

resource "oci_identity_policy" "psm_box_policy" {
    compartment_id = "${var.compartment_ocid}"
    description    = "${var.policy_description}"
    name           = "${var.policy_name}"
    statements = ["allow any-user to manage all-resources in compartment managedcompartmentforpaas"]
}

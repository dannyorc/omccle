## DBCS PROVISIONERS

provisioner "local-exec" {
	command = "echo ${oraclepaas_database_service_instance.database.compute_site_name >> ../database/db.properties"
}
// Created by Zach Hamilton: zach.hamilton@oracle.com

output "database_service_name" {
  value = "${oraclepaas_database_service_instance.database.name}"
}

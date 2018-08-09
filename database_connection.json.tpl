{
    "plugin_name": "mysql-database-plugin",
    "connection_url": "{{username}}:{{password}}@tcp(${db_endpoint})/",
    "allowed_roles": ["mysql_admin", "mysql_ro"],
    "username": "${username}",
    "password": "${password}"
}
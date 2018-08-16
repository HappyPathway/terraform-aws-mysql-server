CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}'; 
grant SELECT on ${var.db_name}.* to '{{name}}'@'%'; 
flush privileges

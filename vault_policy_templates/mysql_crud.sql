CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';
GRANT ALTER, CREATE ON ${var.db_name} to '{{name}}'@'%'; 
grant CREATE,DROP,SELECT,INSERT,UPDATE,DELETE on ${var.db_name}.* to '{{name}}'@'%'; 
flush privileges

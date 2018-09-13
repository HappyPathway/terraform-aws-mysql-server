CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';
GRANT ALTER, CREATE ON ${db_name} to '{{name}}'@'%'; 
grant CREATE,DROP,SELECT,INSERT,UPDATE,DELETE on ${db_name}.* to '{{name}}'@'%'; 
flush privileges

CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}'; 
grant SELECT on ${db_name}.* to '{{name}}'@'%'; 
flush privileges

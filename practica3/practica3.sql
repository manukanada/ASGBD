#Tarea 1: Creación de usuarios y políticas de conexión y caducidad.
1.1
CREATE USER 'gestor_tienda'@'localhost'
IDENTIFIED BY 'Gestor_tienda.2026';
CREATE USER 'auditor_externo'@'%'
IDENTIFIED BY 'Auditor_externo.2026';
#Para establecer una contraseña segura he añadido una mayúscula,
#un carácter especial como el punto y la barrabaja y añadimos números.
1.2
ALTER USER 'auditor_externo'@'%'
PASSWORD EXPIRE INTERVAL 30 DAY;
1.3
SET GLOBAL wait_timeout = 3600;
#Este apartado lo he realizado de forma global porque no se puede
#especificar el usuario al que queremos aplicarselo.

#Tarea 2: Creación y asignación de roles.
2.1
CREATE ROLE 'rol_consultor'
2.2
GRANT SELECT ON Tienda_informatica_reparaciones.* TO 'rol_consultor';
2.3 
GRANT 'rol_consultor' TO 'auditor_externo'@'localhost';

#Tarea 3: Seguridad mediante Vistas y Privilegios Granulares.
3.1
CREATE VIEW v_tecnicos_activos AS
Select id, nombre, especialidad from tecnicos;
3.2
GRANT SELECT ON Tienda_informatica_reparaciones.v_tecnicos_activos TO 'gestor_tienda'@'localhost';
3.3
SELECT * FROM v_tecnicos_activos;
#Cuando realizamos la consulta a la vista, nos devuelve todos los 
#técnicos que hay en la tabla, ya que no hemos aplicado ningún filtro.

#Tarea 4: Consistencia y control con WITH CHECK OPTION.
4.1
CREATE VIEW v_articulos_gama_baja AS 
Select id, nombre, precio, fabricante_id
from articulos 
where precio <= 50.00
WITH CHECK OPTION;
4.2
INSERT INTO v_articulos_gama_baja(id, nombre, precio, fabricante_id)
VALUES(100, 'Disco SSD de prueba', 75.00, 1);
#En este caso cuando un usuario o administrador intenta insertar estos datos
#aparece un error con el CHECK OPTION failed, ya que el precio del artículo es
#mayor que 50.00.

#Tarea 5: Auditoría, Resolución de Incidencias y Reflexión Crítica (Apartado de
Análisis y Razonamiento)

5.1
SHOW GRANTS FOR 'auditor_externo'@'%';
SHOW GRANTS FOR 'rol_consultor';
SELECT CURRENT_ROLE();
5.2
5.3
#Si eliminamos WITH CHECK OPTION, podremos insertar artícuulos cuyo 
#precio sea superior a 50 € a través de la vista, aunque no cumplan su 
#condición. El registro se guardará en la tabla original articulos, 
#pero no aparecerá en la vista porque no cumple el filtro precio <= 50.00.


#Bateria de Consultas 1:
#1. Muestra el nombre y el precio de aquellos artículos que sean, 
#exactamente, el artículo más caro de su respectivo fabricante.
SELECT nombre, precio, fabricante_id
from articulos
group by fabricante_id
having precio = (Select Max(precio)
					FROM articulos);

#2. Muestra el nombre de los fabricantes que no tienen ningún artículo 
#con un precio inferior o igual a la media general de precios de 
#toda la tienda.

#3. Muestra la descripción y el coste de aquellas reparaciones cuyo coste 
#sea estrictamente superior a la media de las reparaciones realizadas 
#por su propio técnico.

#4. Muestra el identificador y la especialidad de los técnicos cuya suma 
#total del coste de las reparaciones que han realizado supere el doble 
#de su propio salario.

#5. Muestra el nombre del fabricante (o fabricantes) que posee el mayor 
#número de artículos registrados en la base de datos.

#6. Muestra el nombre de los técnicos que han realizado alguna reparación, 
#pero que nunca han realizado ninguna reparación cuyo coste haya superado 
#los 100.00 euros.

#7. Muestra el nombre y el salario de los técnicos cuyo salario sea 
#inferior a la media salarial de su propia especialidad.

#8. Muestra el nombre de los fabricantes cuyo país coincide con el país 
#del fabricante que produce el artículo más caro de toda la tienda.

#9. Muestra el nombre y el precio del artículo más barato de entre todos 
#los fabricantes que son originarios de 'Estados Unidos'.

#10. Muestra el identificador del técnico (tecnico_id) que ha acumulado 
#el mayor coste total en reparaciones.

#Bateria de consultas 2:
#1. Muestra el nombre de cada artículo junto con el nombre de su fabricante,
#pero únicamente para aquellos artículos cuyo precio sea superior a 
#100.00 euros.
select a.nombre, a.fabricante_id
from articulos a
join fabricantes f ON a.fabricante_id = f.id 
where precio > 100.00;

#2. Muestra el nombre de todos los fabricantes de la base de datos y, al 
#lado, el nombre de sus artículos. Asegúrate de que aparezcan los 
#fabricantes que no tienen ningún artículo registrado.
select f.nombre, a.nombre
from articulos a
right join fabricantes f ON a.fabricante_id = f.id;

#3. Muestra el nombre del fabricante y la media de los precios de sus 
#artículos, pero solo para aquellos fabricantes cuya media de precios 
#supere los 150.00 euros.
select f.nombre, avg(a.precio) as media
from articulos a
join fabricantes f ON a.fabricante_id = f.id
group by f.id
having media > 150.00; 

#4. Muestra la descripción de la avería, el coste de la reparación y el 
#nombre del técnico que la ha llevado a cabo, ordenado por el coste de 
#mayor a menor.
select descripcion_averia, coste_reparacion, t.nombre
from reparaciones r 
join tecnicos t ON r.tecnico_id = t.id 
order by coste_reparacion DESC;

#5. Muestra el nombre de aquellos técnicos que no han realizado ninguna 
#reparación, utilizando obligatoriamente un cruce externo de tablas.
select t.nombre
from tecnicos t
left join reparaciones r ON r.tecnico_id = t.id
where t.id NOT IN SELECT t.nombre 
					FROM tecnicos;


#6. Muestra el nombre del técnico y la suma total del dinero recaudado 
#con sus reparaciones, filtrando únicamente aquellos técnicos cuya 
#recaudación total supere los 100.00 euros.

#7. Muestra el nombre de los artículos y el nombre de su respectivo 
#fabricante, pero filtrando exclusivamente aquellos artículos cuyos 
#fabricantes sean originarios de 'Estados Unidos' o 'Taiwán' .

#8. Muestra el nombre de todos los técnicos y, al lado, el número total 
#de reparaciones que ha realizado cada uno de ellos.

#9. Muestra el nombre del fabricante y el número total de artículos que 
#produce, pero solo de aquellos fabricantes que tengan un número de 
#artículos mayor o igual a 2.

#10. Muestra el nombre del técnico, su especialidad y la descripción de 
#la reparación más costosa que ha realizado cada uno de ellos.
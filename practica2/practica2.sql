#Bateria de Consultas 1:
#1. Muestra el nombre y el precio de aquellos artículos que sean, 
#exactamente, el artículo más caro de su respectivo fabricante.
SELECT nombre, precio
from articulos a1
where precio = (Select Max(precio)
				FROM articulos a2
				where a2.fabricante_id=a1.fabricante_id);

#2. Muestra el nombre de los fabricantes que no tienen ningún artículo 
#con un precio inferior o igual a la media general de precios de 
#toda la tienda.
SELECT nombre
from fabricantes
where id in (Select fabricante_id 
			from articulos
			where precio > (Select AVG(precio)
							from articulos));

#3. Muestra la descripción y el coste de aquellas reparaciones cuyo coste 
#sea estrictamente superior a la media de las reparaciones realizadas 
#por su propio técnico.
select descripcion_averia, coste_reparacion
from reparaciones r1
where coste_reparacion > (Select avg(coste_reparacion)
							from reparaciones r2
							where r1.tecnico_id=r2.tecnico_id);

#4. Muestra el identificador y la especialidad de los técnicos cuya suma 
#total del coste de las reparaciones que han realizado supere el doble 
#de su propio salario.
select id, especialidad 
from tecnicos t
where (Select sum(coste_reparacion)
					from reparaciones r
					where r.tecnico_id=t.id
					group by tecnico_id) > 2 * salario;

#5. Muestra el nombre del fabricante (o fabricantes) que posee el mayor 
#número de artículos registrados en la base de datos.
select nombre
from fabricantes f
where (
    select count(*)
    from articulos a
    where a.fabricante_id = f.id
) = (
    select max(total)
    from (
        select count(*) as total
        from articulos
        group by fabricante_id
    ) as cantidades
);

#6. Muestra el nombre de los técnicos que han realizado alguna reparación, 
#pero que nunca han realizado ninguna reparación cuyo coste haya superado 
#los 100.00 euros.
select nombre
from tecnicos t
where exists (
    select *
    from reparaciones r
    where r.tecnico_id = t.id
)
and not exists (
    select *
    from reparaciones r
    where r.tecnico_id = t.id
    and r.coste_reparacion > 100
);
#7. Muestra el nombre y el salario de los técnicos cuyo salario sea 
#inferior a la media salarial de su propia especialidad.
select nombre, salario
from tecnicos t1
where salario < (select avg(salario)
				 from tecnicos t2
				 where t2.especialidad=t1.especialidad)

#8. Muestra el nombre de los fabricantes cuyo país coincide con el país 
#del fabricante que produce el artículo más caro de toda la tienda.
SELECT nombre
FROM fabricantes
WHERE pais IN (
    SELECT pais
    FROM fabricantes
    WHERE id IN (
        SELECT fabricante_id
        FROM articulos
        WHERE precio = (
            SELECT MAX(precio)
            FROM articulos
        )
    )
);
#9. Muestra el nombre y el precio del artículo más barato de entre todos 
#los fabricantes que son originarios de 'Estados Unidos'.
SELECT nombre, precio
FROM articulos a1
WHERE fabricante_id IN (
    SELECT id
    FROM fabricantes
    WHERE pais = 'Estados Unidos'
)
AND precio = (
    SELECT MIN(precio)
    FROM articulos a2
    WHERE fabricante_id IN (
        SELECT id
        FROM fabricantes
        WHERE pais = 'Estados Unidos'
    )
);
	
#10. Muestra el identificador del técnico (tecnico_id) que ha acumulado 
#el mayor coste total en reparaciones.
select tecnico_id
from reparaciones
group by tecnico_id
having sum(coste_reparacion) >= ALL (
    select sum(coste_reparacion)
    from reparaciones
    group by tecnico_id
);

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
where t.id NOT IN (SELECT t.nombre 
					FROM tecnicos);

#6. Muestra el nombre del técnico y la suma total del dinero recaudado 
#con sus reparaciones, filtrando únicamente aquellos técnicos cuya 
#recaudación total supere los 100.00 euros.
select t.nombre, sum(r.coste_reparacion) as suma_total
from tecnicos t 
join reparaciones r ON r.tecnico_id = t.id 
group by t.id
having suma_total > 100.00;

#7. Muestra el nombre de los artículos y el nombre de su respectivo 
#fabricante, pero filtrando exclusivamente aquellos artículos cuyos 
#fabricantes sean originarios de 'Estados Unidos' o 'Taiwán' .
select a.nombre, f.nombre
from articulos a 
join fabricantes f ON f.id= a.fabricante_id
where lower(f.pais) = 'estados unidos' OR 'taiwán';

#8. Muestra el nombre de todos los técnicos y, al lado, el número total 
#de reparaciones que ha realizado cada uno de ellos.
select t.nombre, sum(r.id) as suma_reparaciones
from tecnicos t
inner join reparaciones r ON r.tecnico_id = t.id
group by t.nombre;

#9. Muestra el nombre del fabricante y el número total de artículos que 
#produce, pero solo de aquellos fabricantes que tengan un número de 
#artículos mayor o igual a 2.
select f.nombre, sum(a.id) as total_articulos
from fabricantes f 
join articulos a ON a.fabricante_id = f.id 
group by f.nombre
having total_articulos >= 2;

#10. Muestra el nombre del técnico, su especialidad y la descripción de 
#la reparación más costosa que ha realizado cada uno de ellos.
select t.nombre, t.especialidad, r.descripcion_averia
from tecnicos t 
join reparaciones r ON  r.tecnico_id = t.id
group by t.nombre 
having max(coste_reparacion)
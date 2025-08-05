
/*
2. Muestra los nombres de todas las películas con una clasificación por
edades de ‘R’
*/

SELECT "title" FROM film f WHERE f.rating = 'R';

/*
3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30
y 40.
*/

SELECT "first_name", "last_name" FROM actor a  WHERE actor_id BETWEEN 30 AND 40

/*
 4. Obtén las películas cuyo idioma coincide con el idioma original.
*/

SELECT "title" FROM film f WHERE f.language_id = f.original_language_id AND f.original_language_id IS NOT NULL ;

/*
5.Ordena las películas por duración de forma ascendente
*/

SELECT "title","length" FROM film f ORDER BY f.length ASC;

--Comentario importante el asc no es necesario porque por defecto ordena de esta forma al no ser que se indique lo contrario, pero lo dejare marcado.

/*
6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su
apellido.
*/

SELECT "first_name", "last_name" FROM actor a WHERE last_name LIKE '%Allen%';

/*
7. Encuentra la cantidad total de películas en cada clasificación de la tabla
“film” y muestra la clasificación junto con el recuento.
*/

SELECT "rating",count(*) AS "Tota_peliculas" FROM film f group BY rating;

/*
8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una
duración mayor a 3 horas en la tabla film
*/

SELECT "title", "rating", "length"  FROM film f WHERE rating = 'PG-13' OR f.length > 120;

/*
9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
*/

SELECT stddev_samp(replacement_cost ) AS NOT IN ('NC-17', 'G') FROM film f;

/*
10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
*/

SELECT max(length) AS "Maxduration", min(length) AS "Minduration" FROM film f;

/*
11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
*/

SELECT "title", "rental_date" FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id  JOIN film f ON i.film_id = f.film_id  ORDER BY r.rental_date ASC OFFSET 2 LIMIT 1;

/*
12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.
*/

SELECT "title", "rating" FROM film f WHERE f.rating not IN ('NC-17', 'G');


/*
13. Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración.
*/

select "rating" AS "Clasification", AVG(length) AS "Promedio" FROM film f group BY rating;


/*
14. Encuentra el título de todas las películas que tengan una duración mayor
a 180 minutos.
*/

SELECT "title", "length" AS "Duration" FROM film f WHERE length > 180;

/*
15.¿Cuanto dinero ha generado en total la empresa?
*/

SELECT SUM(amount) AS total_generado FROM payment;

/*
16. Muestra los 10 clientes con mayor valor de id
*/

SELECT "CustomerId"  FROM "Customer" c ORDER BY "CustomerId" DESC LIMIT 10;

/*
17. Encuentra el nombre y apellido de los actores que aparecen en la
película con título ‘Egg Igby’
*/

SELECT "first_name", "last_name" FROM actor a JOIN film_actor fa  ON a.actor_id = fa.actor_id JOIN film f ON f.film_id = fa.film_id WHERE 'f.title' = 'ALONE TRIP';

/*
18. Selecciona todos los nombres de las películas únicos. 
*/

SELECT DISTINCT "title" FROM film f ;

/*
19. Encuentra el título de las películas que son comedias y tienen una
duración mayor a 180 minutos en la tabla “film”.
*/

SELECT "title" FROM film f JOIN film_category fc ON fc.film_id = f.film_id JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'Comedy';

/*
20. Encuentra las categorías de películas que tienen un promedio de
duración superior a 110 minutos y muestra el nombre de la categoría
junto con el promedio de duración.
*/

SELECT "rating" AS "Category", AVG(length) AS "Duration" FROM film f WHERE 'Duration' > 110;

/*
21.¿Cuál es la media de duración del alquiler de las películas?
*/

SELECT  AVG(EXTRACT(EPOCH FROM (return_date - rental_date)) / 60) AS "Media_Minutos" FROM rental r WHERE return_date IS NOT NULL;

/*
He realizado una división entre 60 para devolver los datos en minutos.
*/


/*
22. Crea una columna con el nombre y apellidos de todos los actores y
actrices.
*/

/* Realizo la consulta para ver que columnas tenemos en la tabla*/
SELECT * FROM actor a;

/* Creamos la columna en la tabla.*/
ALTER Table actor ADD full_name VARCHAR(150);

/*Agregamos la info a la nueva columna */
UPDATE actor SET full_name = CONCAT(first_name, ' ', last_name);


/*
23. Números de alquiler por día, ordenados por cantidad de alquiler de
forma descendente.
*/

/* Paso la función DATE para pasar solo la fecha sin la hora*/

SELECT DATE(rental_date) AS fecha_alquiler, COUNT(*) AS cantidad_alquileres FROM rental GROUP BY DATE(rental_date) ORDER BY cantidad_alquileres DESC;

/*
24. Encuentra las películas con una duración superior al promedio.
*/

SELECT "title", "length" FROM film f WHERE length > (SELECT avg(length) FROM film);


/*
25. Averigua el número de alquileres registrados por mes.
*/
SELECT COUNT(rental_id ) AS "n_alquiler_mes", DATE(rental_date) AS "mes_alquieler" FROM rental r group by DATE(rental_date);

/*
26. Encuentra el promedio, la desviación estándar y varianza del total
pagado.
*/

SELECT AVG(amount) AS "promedioM", stddev(amount) AS "desviacion_estandar", VARIANCE(amount) AS "varianza" from payment p;

/*
27. ¿Qué películas se alquilan por encima del precio medio?
*/

SELECT "title", rental_rate FROM film f WHERE rental_rate > (SELECT AVG(rental_rate) FROM film f2 );

/*
28. Muestra el id de los actores que hayan participado en más de 40
películas.
*/

SELECT "actor_id", COUNT(film_id) AS "peliculasP" FROM film_actor fa GROUP BY actor_id HAVING COUNT(film_id) > 40

/*
29. Obtener todas las películas y, si están disponibles en el inventario,
mostrar la cantidad disponible.
*/
SELECT "title", COUNT("inventory_id") AS "cantidad_disponible" FROM film f LEFT JOIN inventory i ON f.film_id = i.film_id GROUP BY f.film_id, f.title ORDER BY f.title;

/*
30. Obtener los actores y el número de películas en las que ha actuado.
*/

SELECT"full_name", COUNT(film_id) AS "numero_peliculas" FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id GROUP BY a.full_name ORDER BY numero_peliculas DESC;

/*
31. Obtener todas las películas y mostrar los actores que han actuado en
ellas, incluso si algunas películas no tienen actores asociados.
*/

SELECT "title","full_name" FROM film f LEFT JOIN film_actor fa ON f.film_id = fa.film_id LEFT JOIN actor a ON fa.actor_id = a.actor_id ORDER BY f.title,a.full_name;

/*
32. Obtener todos los actores y mostrar las películas en las que han
actuado, incluso si algunos actores no han actuado en ninguna película.
*/

SELECT "title","full_name" FROM actor a LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id LEFT JOIN film f ON fa.film_id = f.film_id ORDER BY a.full_name, f.title;

/*
33. Obtener todas las películas que tenemos y todos los registros de
alquiler.
*/

SELECT "title", "rental_id", "rental_date", "return_date", "customer_id" FROM film f LEFT JOIN inventory i ON f.film_id = i.film_id LEFT JOIN rental r ON i.inventory_id = r.inventory_id ORDER BY f.title, r.rental_date;

/*
34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
*/ 

SELECT  "first_name", "last_name", SUM(p.amount) AS "total_gastado" FROM customer c JOIN payment p ON c.customer_id = p.customer_id GROUP BY c.first_name, c.last_name ORDER BY total_gastado DESC LIMIT 5;

/*
35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
*/

SELECT * FROM "Album" a WHERE 'first_name' = 'Johnny';

/*
36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
*/

SELECT "first_name" AS "Nombre","last_name" AS "Apellido" FROM actor a;

/*
37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
*/

SELECT MIN(actor_id) AS "id_mas_bajo", MAX(actor_id) AS "id_mas_alto" FROM actor a;

/* 
38. Cuenta cuántos actores hay en la tabla “actor”.
*/
SELECT COUNT(*) AS "total_actores" FROM actor a;

/*
39. Selecciona todos los actores y ordénalos por apellido en orden
ascendente.
*/

SELECT * FROM actor a ORDER BY a.last_name asc;

/*
40. Selecciona las primeras 5 películas de la tabla “film”.
*/

SELECT * FROM film f ORDER BY f.film_id ASC LIMIT 5;

/*
Agrupa los actores por su nombre y cuenta cuántos actores tienen el
mismo nombre. ¿Cuál es el nombre más repetido?
*/

SELECT "first_name" AS nombre, COUNT(*) AS cantidad FROM actor GROUP BY first_name ORDER BY cantidad DESC;

/*¿Cuál es el nombre más repetido?*/

SELECT "first_name" AS nombre, COUNT(*) AS cantidad FROM actor GROUP BY first_name ORDER BY cantidad desc limit 1;


/*
42. Encuentra todos los alquileres y los nombres de los clientes que los
realizaron.
*/
SELECT "rental_date","return_date",concat("first_name",' ', "last_name") FROM rental r JOIN customer c ON r.customer_id = c.customer_id order BY r.rental_date;

/*
43. Muestra todos los clientes y sus alquileres si existen, incluyendo
aquellos que no tienen alquileres.
*/
SELECT  CONCAT("first_name", ' ', "last_name") AS "cliente","rental_date","return_date" FROM customer c LEFT JOIN rental r ON c.customer_id = r.customer_id ORDER BY r.rental_date;

/*
44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
esta consulta? ¿Por qué? Deja después de la consulta la contestación.
*/

SELECT "title" AS pelicula, "name" AS categoria FROM film f CROSS JOIN category c LIMIT 100;

/*No aporta valor directamente en un contexto real.
 Esto lo unico que hace es unir todas las categorias con todas las peliculas (Producto cartesiano)*/


/*
45. Encuentra los actores que han participado en películas de la categoría
'Action'.
*/

SELECT DISTINCT "first_name","last_name" FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film f ON fa.film_id = f.film_id JOIN film_category fc ON f.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Action' ORDER BY a.last_name, a.first_name;


/*
46. Encuentra todos los actores que no han participado en películas.
*/

SELECT "first_name","last_name" FROM actor a LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id WHERE fa.film_id IS null ORDER BY a.last_name, a.first_name;

/*
47. Selecciona el nombre de los actores y la cantidad de películas en las
que han participado.
*/
SELECT "first_name","last_name", COUNT(film_id) AS cantidad_peliculas FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id GROUP BY a.actor_id, a.first_name, a.last_name ORDER BY cantidad_peliculas DESC;


/*
48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres
de los actores y el número de películas en las que han participado.
*/

CREATE VIEW actor_num_peliculas as SELECT "first_name","last_name", COUNT("film_id") AS "cantidad_peliculas" FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id GROUP BY a.actor_id, a.first_name, a.last_name;

/*Consulta para vizualizar la vista*/

SELECT * FROM actor_num_peliculas ORDER BY cantidad_peliculas DESC;

/*
49. Calcula el número total de alquileres realizados por cada cliente.
*/

SELECT "first_name","last_name",COUNT(r.rental_id) AS total_alquileres FROM customer c JOIN rental r ON c.customer_id = r.customer_id  GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY total_alquileres DESC;

/*
50. Calcula la duración total de las películas en la categoría 'Action'.
*/

SELECT  "name" AS categoria, SUM(f.length) AS duracion_total FROM film f JOIN film_category fc ON f.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Action' GROUP BY c.name;


/*
51. Crea una tabla temporal llamada “cliente_rentas_temporal” para
almacenar el total de alquileres por cliente.
*/

CREATE TEMP TABLE cliente_rentas_temporal as SELECT "first_name","last_name",COUNT(r.rental_id) AS total_rentas FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROUP BY c.customer_id, c.first_name, c.last_name;

/*Consulta para vizualizar la vista*/

SELECT * FROM cliente_rentas_temporal


/*
52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
películas que han sido alquiladas al menos 10 veces.
*/

CREATE TEMP TABLE peliculas_alquiladas as SELECT "title",COUNT(r.rental_id) AS total_alquileres FROM film f JOIN inventory i ON f.film_id = i.film_id JOIN rental r ON i.inventory_id = r.inventory_id GROUP BY f.film_id, f.title HAVING COUNT(r.rental_id) >= 10;


/*consultar la tabla*/

SELECT * FROM peliculas_alquiladas



/*
53. Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película.
*/

SELECT DISTINCT f.title FROM customer c JOIN rental r ON c.customer_id = r.customer_id JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id WHERE c.first_name = 'Tammy' AND c.last_name = 'Sanders' AND r.return_date IS null ORDER BY f.title;



/*
54. Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
alfabéticamente por apellido. 
*/

SELECT DISTINCT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film_category fc ON fa.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Sci-Fi' ORDER BY a.last_name, a.first_name;

/*
55. Encuentra el nombre y apellido de los actores que han actuado en
películas que se alquilaron después de que la película ‘Spartacus
Cheaper’ se alquilara por primera vez. Ordena los resultados
alfabéticamente por apellido.
*/

SELECT DISTINCT a.first_name,a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN inventory i ON fa.film_id = i.film_id JOIN rental r ON i.inventory_id = r.inventory_id WHERE r.rental_date > ( SELECT MIN(r2.rental_date) FROM film f2 JOIN inventory i2 ON f2.film_id = i2.film_id JOIN rental r2 ON i2.inventory_id = r2.inventory_id WHERE f2.title = 'Spartacus Cheaper' ) ORDER BY a.last_name, a.first_name;

/*
56. Encuentra el nombre y apellido de los actores que no han actuado en
ninguna película de la categoría ‘Music’.
*/

SELECT a.first_name, a.last_name FROM actor a WHERE NOT EXISTS ( SELECT 1 FROM film_actor fa JOIN film_category fc ON fa.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE fa.actor_id = a.actor_id AND c.name = 'Music') ORDER BY a.last_name, a.first_name;

/*
57. Encuentra el título de todas las películas que fueron alquiladas por más
de 8 días.
*/

SELECT DISTINCT f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE r.return_date IS NOT NULL
  AND (r.return_date - r.rental_date) > INTERVAL '8 days';

/* 58. Encuentra el título de todas las películas que son de la misma categoría 
que ‘Animationʼ */

SELECT f.title 
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Animation'
ORDER BY f.title;

/* 59.Encuentra los nombres de las películas que tienen la misma duración 
que la película con el título ‘Dancing Feverʼ. Ordena los resultados 
alfabéticamente por título de película.*/

SELECT title
FROM film
WHERE length = (
    SELECT length
    FROM film
    WHERE title = 'Dancing Fever'
)
ORDER BY title;
/*60. Encuentra los nombres de los clientes que han alquilado al menos 7 
películas distintas. Ordena los resultados alfabéticamente por apellido.*/

SELECT c.first_name, c.last_name, COUNT(DISTINCT f.film_id) AS cantidad_peliculas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT f.film_id) >= 7
ORDER BY c.last_name, c.first_name;

/* 61. Encuentra la cantidad total de películas alquiladas por categoría y 
muestra el nombre de la categoría junto con el recuento de alquileres.*/

SELECT c.name AS categoria, COUNT(r.rental_id) AS total_alquileres
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_alquileres DESC;

/*62. Encuentra el número de películas por categoría estrenadas en 2006.*/

SELECT c.name AS categoria, COUNT(f.film_id) AS total_peliculas
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY total_peliculas DESC;

/*63.Obtén todas las combinaciones posibles de trabajadores con las tiendas 
que tenemos.*/

SELECT s.staff_id, s.first_name, s.last_name, st.store_id
FROM staff s
CROSS JOIN store st
ORDER BY s.staff_id, st.store_id;

/*64. Encuentra la cantidad total de películas alquiladas por cada cliente y 
muestra el ID del cliente, su nombre y apellido junto con la cantidad de 
películas alquiladas.*/

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_peliculas_alquiladas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_peliculas_alquiladas DESC;

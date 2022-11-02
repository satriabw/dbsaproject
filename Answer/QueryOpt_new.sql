----Query 1
CREATE INDEX IF NOT EXISTS film_length_idx ON film USING btree (length);
CREATE INDEX IF NOT EXISTS rental_inventory_id_idx ON rental USING btree (inventory_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental USING btree (customer_id);

Cluster rental using rental_inventory_id_idx;

EXPLAIN ANALYSE
WITH films_bigger_than_180 AS (
	SELECT film_id FROM film where length >= 180
)
SELECT cu.customer_id, cu.last_name 
FROM customer cu
WHERE NOT EXISTS( Select distinct r.customer_id
From films_bigger_than_180 f
	NATURAL Join inventory i
 	INNER Join rental r on i.inventory_id = r.inventory_id
Where r.customer_id = cu.customer_id
);

Drop index film_length_idx,rental_customer_id_idx;

-------------------------------------------------------------------------------------
----Query 2
CREATE INDEX IF NOT EXISTS customer_address_id_idx ON customer USING Btree (address_id);
CREATE INDEX IF NOT EXISTS address_address_id_idx ON address USING Btree (address_id);
CREATE INDEX IF NOT EXISTS country_country_id_idx ON country USING Btree (country_id);
Create INDEX IF NOT EXISTS city_idx ON city Using Btree(city_id,country_id);
CREATE INDEX IF NOT EXISTS address_city_id_idx ON address USING Btree (city_id);
Set enable_hashjoin=off;

EXPLAIN ANALYZE 
SELECT country.country_id, country.country
FROM
    (
        SELECT city.country_id, city.city_id, COUNT(customer.customer_id) AS n_customers
        FROM customer
            INNER JOIN address ON customer.address_id = address.address_id
            INNER JOIN city ON city.city_id = address.city_id
        GROUP BY city.city_id
    ) AS countries_w_cities_w_at_least_more_than_1_customer
    INNER JOIN country ON country.country_id = countries_w_cities_w_at_least_more_than_1_customer.country_id
WHERE n_customers > 1;

Set enable_hashjoin=on;
Drop index customer_address_id_idx,address_address_id_idx,
country_country_id_idx,city_idx,address_city_id_idx;

-----------------------------------------------------------------------------------------
----Query3
CREATE INDEX IF NOT EXISTS customer_customer_id_idx ON customer USING Btree (customer_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental USING Btree (customer_id);
Cluster customer using customer_customer_id_idx;

explain ANALYZE select customer_id, last_name
from customer
natural join
(
   select customer_id
	from rental
     group by customer_id, return_date::date
    having count(*) > 3
 ) customer_id
 group by customer_id
 having count(*) > 1;
 
 Drop index rental_customer_id_idx;
 
 ------------------------------------------------------------------------------------
 ----Query4
 CREATE INDEX IF NOT EXISTS inventory_film_id_idx ON inventory USING BTree (film_id);
CREATE INDEX IF NOT EXISTS inventory_inventory_id_idx ON inventory USING BTREE(inventory_id) INCLUDE (film_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental USING BTREE (customer_id);
CREATE INDEX IF NOT EXISTS film_film_id_idx ON film USING BTREE (film_id);
CREATE INDEX IF NOT EXISTS fc_film_id_idx ON film_category USING BTREE (film_id);

EXPLAIN ANALYSE
WITH inventory_ids AS (
    SELECT inventory_id, film_id FROM inventory
),
film_ids AS(
    SELECT film_id FROM film
),
film_categories_ids AS(
    SELECT film_id, category_id FROM film_category
)
SELECT c.customer_id, c.last_name
FROM (
SELECT DISTINCT fc.category_id, r.customer_id
FROM rental r
NATURAL JOIN inventory_ids i -- on i.inventory_id = r.inventory_id
NATURAL JOIN film_ids f --on i.film_id = f.film_id
NATURAL JOIN film_categories_ids fc -- on fc.film_id = f.film_id
) inner_query, customer c
WHERE c.customer_id = inner_query.customer_id
GROUP BY c.customer_id
HAVING count(category_id)  = (
    SELECT count(category_id) FROM category
);

Drop index customer_customer_id_idx,inventory_film_id_idx,inventory_inventory_id_idx,
rental_inventory_id_idx,rental_customer_id_idx,film_film_id_idx,fc_film_id_idx;
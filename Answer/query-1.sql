CREATE INDEX IF NOT EXISTS film_film_id_idx ON film USING BRIN (film_id);
CREATE INDEX IF NOT EXISTS film_length_idx ON film USING BTREE(film_id) WHERE length >= 180;
CREATE INDEX IF NOT EXISTS inventory_film_id_idx ON inventory USING BRIN (film_id);
CREATE INDEX IF NOT EXISTS inventory_inventory_id_idx ON inventory USING BRIN (inventory_id);
CREATE INDEX IF NOT EXISTS rental_inventory_id_idx ON rental USING BRIN (inventory_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental USING BRIN (customer_id);
CREATE INDEX IF NOT EXISTS customer_ln_id_idx ON customer USING BTREE (customer_id) INCLUDE (last_name);

EXPLAIN ANALYSE
WITH films_bigger_than_180 AS (
	SELECT film_id FROM film where length >= 180
)
SELECT cu.customer_id, cu.last_name 
FROM customer cu
WHERE NOT EXISTS( Select distinct r.customer_id
From films_bigger_than_180 f
	NATURAL Join inventory i -- on f.film_id = i.film_id
 	INNER Join rental r on i.inventory_id = r.inventory_id
Where r.customer_id = cu.customer_id
);

Drop index IF EXISTS film_film_id_idx,inventory_film_id_idx,inventory_inventory_id_idx
,rental_inventory_id_idx,rental_customer_id_idx, film_length_idx, customer_id_idx;
--Indexes Query 4
CREATE INDEX IF NOT EXISTS customer_customer_id_idx ON customer USING BTREE (customer_id) INCLUDE (last_name);
--CREATE INDEX rental_idx ON rental(customer_id,inventory_id);
--CREATE INDEX inventory_idx ON inventory(inventory_id,film_id);
CREATE INDEX IF NOT EXISTS inventory_film_id_idx ON inventory USING BRIN (film_id);
CREATE INDEX IF NOT EXISTS inventory_inventory_id_idx ON inventory USING BTREE(inventory_id) INCLUDE (film_id);
CREATE INDEX IF NOT EXISTS rental_inventory_id_idx ON rental USING BRIN (inventory_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental USING BRIN (customer_id);

CREATE INDEX IF NOT EXISTS film_film_id_idx ON film USING BRIN (film_id);
CREATE INDEX IF NOT EXISTS fc_film_id_idx ON film_category USING BRIN (film_id);

--  --Query 4 
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

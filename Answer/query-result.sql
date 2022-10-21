-- --Query 1
-- CREATE INDEX IF NOT EXISTS filmLengthIdx on fllm (length);
-- CREATE INDEX IF NOT EXIST custIdx on rental (customerId);
-- CREATE INDEX IF NOT EXIST invIdx on rental (inventory_id);
-- CREATE INDEX IF NOT EXISTS invfilmIdIdx on inventory (film_id);



EXPLAIN ANALYSE SELECT cu.customer_id,cu.last_name 
FROM customer cu
WHERE not EXISTS
(Select distinct r.customer_id
From film f
	Inner Join inventory i
	on f.film_id = i.film_id
 	and f.length >= 180
 	Inner Join rental r
 	on i.inventory_id = r.inventory_id
Where r.customer_id = cu.customer_id 
);

-- Query 2 (2 Options)

EXPLAIN ANALYZE SELECT country.country_id, country.country
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

-- -- --Query 3
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
 
--  --Query 4

EXPLAIN ANALYZE SELECT c.customer_id, c.last_name
FROM (
SELECT DISTINCT fc.category_id, r.customer_id
FROM rental r
INNER JOIN inventory i on i.inventory_id = r.inventory_id
INNER JOIN film f on i.film_id = f.film_id
INNER JOIN film_category fc on fc.film_id = f.film_id
) inner_query, customer c
WHERE c.customer_id = inner_query.customer_id
GROUP BY c.customer_id
HAVING count(category_id)  = (
    SELECT count(category_id) FROM category
);

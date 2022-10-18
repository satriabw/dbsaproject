-- Number 1 : Unoptimized --
SELECT customer_id, last_name from customer
where customer_id not in
( SELECT distinct(c.customer_id) FROM customer c
    INNER JOIN rental r on c.customer_id = r.customer_id
    INNER JOIN inventory i on r.inventory_id = i.inventory_id
    INNER JOIN film f on i.film_id = f.film_id
    where f.length >= 180
);

-- -- Number 2: unoptimized
SELECT distinct c.country from country c, city ct, address ad
INNER JOIN customer cust on cust.address_id = ad.address_id
where c.country_id = ct.country_id and ct.city_id = ad.city_id
GROUP BY c.country, ct.city
having count(customer_id) > 1;


-- -- Number 3: unoptimized
SELECT customer_id, last_name
FROM (SELECT c.customer_id, c.last_name
FROM customer c
INNER JOIN rental r on c.customer_id = r.customer_id
group by c.customer_id, r.return_date::timestamp::date
having count(r.inventory_id) >= 4
) t
GROUP BY customer_id, last_name
having count(customer_id) > 1;

-- Number 4: unoptimized
SELECT c.customer_id, c.last_name
FROM customer c
INNER JOIN rental r on r.customer_id = c.customer_id
INNER JOIN inventory i on i.inventory_id = r.inventory_id
INNER JOIN film f on i.film_id = f.film_id
INNER JOIN film_category fc on fc.film_id = f.film_id
INNER JOIN category ct on ct.category_id = fc.category_id
GROUP BY c.customer_id, c.last_name
HAVING count(distinct ct.name) = (
    SELECT count(category_id) FROM category
)

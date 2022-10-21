--Indexes Query 3
CREATE INDEX IF NOT EXISTS customer_customer_id_idx ON customer USING BRIN (customer_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental USING BTREE ((return_date::date), customer_id);
CREATE INDEX IF NOT EXISTS rental_date_idx on rental USING btree ((return_date::date));

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

DROP INDEX IF EXISTS customer_customer_id_idx,rental_customer_id_idx, rental_date_idx;

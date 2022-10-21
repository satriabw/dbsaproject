-- Indexes query 1
CREATE INDEX IF NOT EXISTS film_film_id_idx ON film USING BRIN (film_id);
CREATE INDEX IF NOT EXISTS inventory_film_id_idx ON inventory USING BRIN (film_id);
CREATE INDEX IF NOT EXISTS inventory_inventory_id_idx ON inventory USING BRIN (inventory_id);
CREATE INDEX IF NOT EXISTS rental_inventory_id_idx ON rental USING BRIN (inventory_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental USING BRIN (customer_id);
--CREATE INDEX film_length_idx ON film (length);

Drop index film_film_id_idx,inventory_film_id_idx,inventory_inventory_id_idx
,rental_inventory_id_idx,rental_customer_id_idx; --,film_length_idx

-- Indexes query 2
CREATE INDEX IF NOT EXISTS customer_address_id_idx ON customer USING Btree (address_id);
CREATE INDEX IF NOT EXISTS address_address_id_idx ON address USING Btree (address_id);
CREATE INDEX IF NOT EXISTS country_country_id_idx ON country USING Btree (country_id);
-- CREATE INDEX city_country_id_idx ON city USING BRIN (country_id);
-- CREATE INDEX city_city_id_idx ON city USING BRIN (city_id);
Create INDEX IF NOT EXISTS city_idx ON city Using Btree(city_id,country_id);
-- Create INDEX address_idx ON address (address_id,city_id);
CREATE INDEX IF NOT EXISTS address_city_id_idx ON address USING Btree (city_id);

Drop index customer_address_id_idx,address_address_id_idx,
country_country_id_idx,city_idx,address_city_id_idx;

--Indexes Query 3
CREATE INDEX IF NOT EXISTS customer_customer_id_idx ON customer USING BRIN (customer_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental USING BRIN (customer_id);

Drop index customer_customer_id_idx,rental_customer_id_idx;

--Indexes Query 4
CREATE INDEX IF NOT EXISTS customer_customer_id_idx ON customer USING BRIN (customer_id);
--CREATE INDEX rental_idx ON rental(customer_id,inventory_id);
--CREATE INDEX inventory_idx ON inventory(inventory_id,film_id);
CREATE INDEX IF NOT EXISTS inventory_film_id_idx ON inventory USING BRIN (film_id);
CREATE INDEX IF NOT EXISTS inventory_inventory_id_idx ON inventory USING BRIN (inventory_id);
CREATE INDEX IF NOT EXISTS rental_inventory_id_idx ON rental USING BRIN (inventory_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental USING BRIN (customer_id);

CREATE INDEX IF NOT EXISTS film_film_id_idx ON film USING BRIN (film_id);
CREATE INDEX IF NOT EXISTS fc_film_id_idx ON film_category USING BRIN (film_id);

Drop index customer_customer_id_idx,inventory_film_id_idx,inventory_inventory_id_idx,
rental_inventory_id_idx,rental_customer_id_idx,film_film_id_idx,fc_film_id_idx;

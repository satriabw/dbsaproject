CREATE INDEX IF NOT EXISTS customer_address_id_idx ON customer USING BRIN (address_id);
CREATE INDEX IF NOT EXISTS address_address_id_idx ON address USING BRIN (address_id);
CREATE INDEX IF NOT EXISTS country_country_id_idx ON country(country_id) INCLUDE (country);
---CREATE INDEX city_country_id_idx ON city USING BRIN (country_id);
-- CREATE INDEX city_city_id_idx ON city USING BRIN (city_id);
Create INDEX IF NOT EXISTS city_idx ON city (city_id,country_id);
-- Create INDEX address_idx ON address (address_id,city_id);
CREATE INDEX IF NOT EXISTS address_city_id_idx ON address USING BRIN (city_id);

-- Query 2 (2 Options)
EXPLAIN ANALYSE
SELECT country.country_id, country.country
FROM
    (
        SELECT city.country_id, city.city_id, COUNT(customer.customer_id) AS n_customers
        FROM customer
            INNER JOIN address ON customer.address_id = address.address_id
            INNER JOIN city ON city.city_id = address.city_id
        GROUP BY city.city_id
    ) AS countries_w_cities_w_at_least_more_than_1_customer
    NATURAL JOIN country --ON country.country_id = countries_w_cities_w_at_least_more_than_1_customer.country_id
WHERE n_customers > 1;

Drop index if exists customer_address_id_idx,address_address_id_idx,
country_country_id_idx,city_idx,address_city_id_idx;
INSERT INTO detailed_table
SELECT
    u.city,
    a.city_id,
    c.customer_id,         --used other tables for data to populate detailed table
    p.amount,
    p.payment_date
FROM us_cities u
JOIN address a
    ON u.city_id = a.city_id
JOIN customer c
    ON a.address_id = c.address_id --join customer id where address is in US city
JOIN payment p
    ON c.customer_id = p.customer_id;--get only payments from US customers

INSERT INTO summary
SELECT
    d.city,
    SUM(d.amount) AS total_payment --get sum of amount in detailed and store as total_payment
FROM detailed_table d
GROUP BY d.city;
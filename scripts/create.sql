select country, country_id from country where country.country = 'United States';
select distinct city.city from city where country_id = 103; --select unique cities with the US id(103)
create table US_cities as
    select city.city, city_id
          from city
where country_id = 103; --create table that only has US cities

CREATE TABLE detailed_table ( --new detailed table with required columns
    city VARCHAR(30),
    city_id INT,
    customer_id INT,
    amount NUMERIC(5,2),
    payment_date DATE
);

CREATE TABLE summary( -- summary table for only city and their total payment
    city VARCHAR(30) PRIMARY KEY,
    total_payment NUMERIC(8,2)
);
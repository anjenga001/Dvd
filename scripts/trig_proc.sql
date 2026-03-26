CREATE OR REPLACE FUNCTION summary_update()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE summary
    SET
        total_payment = total_payment + NEW.amount --add new 'amounts' in detailed to summary sum
    WHERE city = NEW.city;

    IF NOT FOUND THEN
        INSERT INTO summary (city, total_payment) --add new city to summary when added to detailed
        VALUES (NEW.city, NEW.amount);
    END IF;

    RETURN NEW;
END;
$$  LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_summary_update
    AFTER INSERT ON detailed_table
    FOR EACH ROW
    EXECUTE FUNCTION summary_update();

INSERT INTO detailed_table
VALUES ('Manchester', 322, 400, 99.99, '2007-01-01');

SELECT * FROM summary;

CREATE OR REPLACE PROCEDURE refresh_data()
AS $$
BEGIN
    ALTER TABLE detailed_table
    DISABLE TRIGGER trg_summary_update; --disable trigger before procedure to avoid interruptions

    TRUNCATE TABLE summary;
    TRUNCATE TABLE detailed_table;--delete both tables for refresh

    INSERT INTO detailed_table(city, city_id, customer_id, amount, payment_date) --inserts refreshed data
    SELECT
    u.city,
    a.city_id,
    c.customer_id,
    p.amount,
    p.payment_date
    FROM us_cities u
    JOIN address a
        ON u.city_id = a.city_id
    JOIN customer c
    ON a.address_id = c.address_id
    JOIN payment p
    ON c.customer_id = p.customer_id;

    INSERT INTO summary ( city, total_payment)
    SELECT
        d.city,
        SUM(d.amount) AS total_payment
    FROM detailed_table d
    GROUP BY d.city;

    ALTER TABLE detailed_table
    ENABLE TRIGGER trg_summary_update;
END;
$$ LANGUAGE plpgsql;

CALL refresh_data();

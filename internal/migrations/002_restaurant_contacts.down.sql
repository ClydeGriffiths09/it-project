BEGIN;

LOCK TABLE restaurant_contacts IN ACCESS EXCLUSIVE MODE;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM restaurant_contacts WHERE type NOT IN ('phone', 'email')) THEN
        RAISE EXCEPTION 'cannot roll back: unsupported restaurant contact type';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM restaurant_contacts
        GROUP BY restaurant_id, type
        HAVING count(*) > 1
    ) THEN
        RAISE EXCEPTION 'cannot roll back: multiple contacts of the same type for a restaurant';
    END IF;
END;
$$;

ALTER TABLE restaurant ADD COLUMN phone text, ADD COLUMN email text;

UPDATE restaurant r
SET phone = (SELECT value FROM restaurant_contacts WHERE restaurant_id = r.id AND type = 'phone'),
    email = (SELECT value FROM restaurant_contacts WHERE restaurant_id = r.id AND type = 'email');

DROP TABLE restaurant_contacts;

COMMIT;

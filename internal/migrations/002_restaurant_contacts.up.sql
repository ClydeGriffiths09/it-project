BEGIN;

CREATE TABLE IF NOT EXISTS restaurant_contacts (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    restaurant_id bigint NOT NULL REFERENCES restaurant(id) ON DELETE CASCADE,
    type text NOT NULL CHECK (btrim(type) <> ''),
    value text NOT NULL CHECK (btrim(value) <> '')
);

INSERT INTO restaurant_contacts (restaurant_id, type, value)
SELECT id, 'phone', phone FROM restaurant WHERE phone IS NOT NULL AND btrim(phone) <> '';

INSERT INTO restaurant_contacts (restaurant_id, type, value)
SELECT id, 'email', email FROM restaurant WHERE email IS NOT NULL AND btrim(email) <> '';

ALTER TABLE restaurant DROP COLUMN IF EXISTS phone, DROP COLUMN IF EXISTS email;

COMMIT;

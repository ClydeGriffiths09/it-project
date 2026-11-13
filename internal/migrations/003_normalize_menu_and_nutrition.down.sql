BEGIN;

DROP VIEW IF EXISTS dish_nutrition_full;

ALTER TABLE dish_nutrition
    ADD COLUMN calories      numeric(10,2),
    ADD COLUMN protein       numeric(10,2),
    ADD COLUMN fat           numeric(10,2),
    ADD COLUMN carbohydrates numeric(10,2);

UPDATE dish_nutrition dn
SET calories      = m.calories,
    protein       = m.protein,
    fat           = m.fat,
    carbohydrates = m.carbohydrates
FROM dish_nutrition_manual m
WHERE m.dish_id = dn.dish_id;

DROP TABLE dish_nutrition_manual;

ALTER TABLE dish_nutrition
    ALTER COLUMN is_manual DROP DEFAULT;

ALTER TABLE menu_drafts
    ADD COLUMN published_at timestamptz;

UPDATE menu_drafts d
SET published_at = p.published_at
FROM menu_published p
WHERE p.draft_id = d.id;

DROP TABLE menu_published;

ALTER TABLE menu_drafts DROP CONSTRAINT IF EXISTS menu_drafts_status_check;

COMMIT;
BEGIN;

DROP VIEW IF EXISTS dish_nutrition_full;

CREATE TABLE IF NOT EXISTS dish_nutrition (
    dish_id bigint PRIMARY KEY REFERENCES dishes(id) ON DELETE CASCADE,
    is_manual boolean NOT NULL DEFAULT false,
    calories numeric(10,2),
    protein numeric(10,2),
    fat numeric(10,2),
    carbohydrates numeric(10,2),
    CHECK (
        (NOT is_manual AND calories IS NULL AND protein IS NULL AND fat IS NULL AND carbohydrates IS NULL)
        OR
        (is_manual AND calories IS NOT NULL AND protein IS NOT NULL AND fat IS NOT NULL AND carbohydrates IS NOT NULL
         AND calories >= 0 AND protein >= 0 AND fat >= 0 AND carbohydrates >= 0)
    )
);

INSERT INTO dish_nutrition (dish_id, is_manual, calories, protein, fat, carbohydrates)
SELECT dish_id, true, calories, protein, fat, carbohydrates
FROM dish_nutrition_manual
ON CONFLICT (dish_id) DO NOTHING;

INSERT INTO dish_nutrition (dish_id, is_manual)
SELECT id, false FROM dishes
ON CONFLICT (dish_id) DO NOTHING;

DROP TABLE IF EXISTS dish_nutrition_manual;

COMMIT;
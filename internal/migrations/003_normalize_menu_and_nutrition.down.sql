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

ALTER TABLE menu_drafts ADD COLUMN IF NOT EXISTS published_at timestamptz;

UPDATE menu_drafts d
SET published_at = p.published_at
FROM menu_published p
WHERE p.draft_id = d.id;

DROP TABLE IF EXISTS menu_published;

ALTER TABLE menu_drafts DROP CONSTRAINT IF EXISTS menu_drafts_status_check;
ALTER TABLE menu_drafts DROP CONSTRAINT IF EXISTS menu_drafts_check;
ALTER TABLE menu_drafts ADD CONSTRAINT menu_drafts_check
CHECK ((status = 'draft' AND published_at IS NULL) OR (status = 'published' AND published_at IS NOT NULL));

COMMIT;
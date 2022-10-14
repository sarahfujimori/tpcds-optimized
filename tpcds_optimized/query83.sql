WITH "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_date" AS "d_date"
  FROM "date_dim" AS "date_dim"
), "_u_0" AS (
  SELECT
    "date_dim"."d_week_seq" AS "d_week_seq"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_date" IN ('1999-06-30', '1999-08-28', '1999-11-18')
  GROUP BY
    "date_dim"."d_week_seq"
), "_u_1" AS (
  SELECT
    "date_dim"."d_date" AS "d_date"
  FROM "date_dim" AS "date_dim"
  LEFT JOIN "_u_0" AS "_u_0"
    ON "date_dim"."d_week_seq" = "_u_0"."d_week_seq"
  WHERE
    NOT "_u_0"."d_week_seq" IS NULL
  GROUP BY
    "date_dim"."d_date"
), "item_2" AS (
  SELECT
    "item"."i_item_sk" AS "i_item_sk",
    "item"."i_item_id" AS "i_item_id"
  FROM "item" AS "item"
), "sr_items" AS (
  SELECT
    "item"."i_item_id" AS "item_id",
    SUM("store_returns"."sr_return_quantity") AS "sr_item_qty"
  FROM "store_returns" AS "store_returns"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_returns"."sr_returned_date_sk" = "date_dim"."d_date_sk"
  LEFT JOIN "_u_1" AS "_u_1"
    ON "date_dim"."d_date" = "_u_1"."d_date"
  JOIN "item_2" AS "item"
    ON "store_returns"."sr_item_sk" = "item"."i_item_sk"
  WHERE
    NOT "_u_1"."d_date" IS NULL
  GROUP BY
    "item"."i_item_id"
), "_u_3" AS (
  SELECT
    "date_dim"."d_date" AS "d_date"
  FROM "date_dim" AS "date_dim"
  LEFT JOIN "_u_0" AS "_u_2"
    ON "date_dim"."d_week_seq" = "_u_2"."d_week_seq"
  WHERE
    NOT "_u_2"."d_week_seq" IS NULL
  GROUP BY
    "date_dim"."d_date"
), "cr_items" AS (
  SELECT
    "item"."i_item_id" AS "item_id",
    SUM("catalog_returns"."cr_return_quantity") AS "cr_item_qty"
  FROM "catalog_returns" AS "catalog_returns"
  JOIN "date_dim_2" AS "date_dim"
    ON "catalog_returns"."cr_returned_date_sk" = "date_dim"."d_date_sk"
  LEFT JOIN "_u_3" AS "_u_3"
    ON "date_dim"."d_date" = "_u_3"."d_date"
  JOIN "item_2" AS "item"
    ON "catalog_returns"."cr_item_sk" = "item"."i_item_sk"
  WHERE
    NOT "_u_3"."d_date" IS NULL
  GROUP BY
    "item"."i_item_id"
), "_u_5" AS (
  SELECT
    "date_dim"."d_date" AS "d_date"
  FROM "date_dim" AS "date_dim"
  LEFT JOIN "_u_0" AS "_u_4"
    ON "date_dim"."d_week_seq" = "_u_4"."d_week_seq"
  WHERE
    NOT "_u_4"."d_week_seq" IS NULL
  GROUP BY
    "date_dim"."d_date"
), "wr_items" AS (
  SELECT
    "item"."i_item_id" AS "item_id",
    SUM("web_returns"."wr_return_quantity") AS "wr_item_qty"
  FROM "web_returns" AS "web_returns"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_returns"."wr_returned_date_sk" = "date_dim"."d_date_sk"
  LEFT JOIN "_u_5" AS "_u_5"
    ON "date_dim"."d_date" = "_u_5"."d_date"
  JOIN "item_2" AS "item"
    ON "web_returns"."wr_item_sk" = "item"."i_item_sk"
  WHERE
    NOT "_u_5"."d_date" IS NULL
  GROUP BY
    "item"."i_item_id"
)
SELECT
  "sr_items"."item_id" AS "item_id",
  "sr_items"."sr_item_qty" AS "sr_item_qty",
  "sr_items"."sr_item_qty" / (
    "sr_items"."sr_item_qty" + "cr_items"."cr_item_qty" + "wr_items"."wr_item_qty"
  ) / 3.0 * 100 AS "sr_dev",
  "cr_items"."cr_item_qty" AS "cr_item_qty",
  "cr_items"."cr_item_qty" / (
    "sr_items"."sr_item_qty" + "cr_items"."cr_item_qty" + "wr_items"."wr_item_qty"
  ) / 3.0 * 100 AS "cr_dev",
  "wr_items"."wr_item_qty" AS "wr_item_qty",
  "wr_items"."wr_item_qty" / (
    "sr_items"."sr_item_qty" + "cr_items"."cr_item_qty" + "wr_items"."wr_item_qty"
  ) / 3.0 * 100 AS "wr_dev",
  (
    "sr_items"."sr_item_qty" + "cr_items"."cr_item_qty" + "wr_items"."wr_item_qty"
  ) / 3.0 AS "average"
FROM "sr_items"
JOIN "cr_items"
  ON "sr_items"."item_id" = "cr_items"."item_id"
JOIN "wr_items"
  ON "sr_items"."item_id" = "wr_items"."item_id"
ORDER BY
  "sr_items"."item_id",
  "sr_item_qty"
LIMIT 100
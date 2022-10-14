SELECT
  "date_dim"."d_year" AS "d_year",
  "item"."i_brand_id" AS "brand_id",
  "item"."i_brand" AS "brand",
  SUM("store_sales"."ss_ext_discount_amt") AS "sum_agg"
FROM "date_dim" AS "date_dim"
JOIN "store_sales" AS "store_sales"
  ON "date_dim"."d_date_sk" = "store_sales"."ss_sold_date_sk"
JOIN "item" AS "item"
  ON "item"."i_manufact_id" = 427
  AND "store_sales"."ss_item_sk" = "item"."i_item_sk"
WHERE
  "date_dim"."d_moy" = 11
GROUP BY
  "date_dim"."d_year",
  "item"."i_brand",
  "item"."i_brand_id"
ORDER BY
  "date_dim"."d_year",
  "sum_agg" DESC,
  "brand_id"
LIMIT 100
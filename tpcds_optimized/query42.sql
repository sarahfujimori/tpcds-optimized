SELECT
  "date_dim"."d_year" AS "d_year",
  "item"."i_category_id" AS "i_category_id",
  "item"."i_category" AS "i_category",
  SUM("store_sales"."ss_ext_sales_price") AS "_col_3"
FROM "date_dim" AS "date_dim"
JOIN "store_sales" AS "store_sales"
  ON "date_dim"."d_date_sk" = "store_sales"."ss_sold_date_sk"
JOIN "item" AS "item"
  ON "item"."i_manager_id" = 1
  AND "store_sales"."ss_item_sk" = "item"."i_item_sk"
WHERE
  "date_dim"."d_moy" = 12
  AND "date_dim"."d_year" = 2000
GROUP BY
  "date_dim"."d_year",
  "item"."i_category_id",
  "item"."i_category"
ORDER BY
  SUM("store_sales"."ss_ext_sales_price") DESC,
  "date_dim"."d_year",
  "item"."i_category_id",
  "item"."i_category"
LIMIT 100
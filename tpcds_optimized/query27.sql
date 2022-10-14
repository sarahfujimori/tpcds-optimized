SELECT
  "item"."i_item_id" AS "i_item_id",
  "store"."s_state" AS "s_state",
  GROUPING("store"."s_state") AS "g_state",
  AVG("store_sales"."ss_quantity") AS "agg1",
  AVG("store_sales"."ss_list_price") AS "agg2",
  AVG("store_sales"."ss_coupon_amt") AS "agg3",
  AVG("store_sales"."ss_sales_price") AS "agg4"
FROM "store_sales" AS "store_sales"
JOIN "customer_demographics" AS "customer_demographics"
  ON "customer_demographics"."cd_education_status" = 'College'
  AND "customer_demographics"."cd_gender" = 'M'
  AND "customer_demographics"."cd_marital_status" = 'D'
  AND "store_sales"."ss_cdemo_sk" = "customer_demographics"."cd_demo_sk"
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_year" = 2000
  AND "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
JOIN "store" AS "store"
  ON "store"."s_state" IN ('TN', 'TN', 'TN', 'TN', 'TN', 'TN')
  AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
JOIN "item" AS "item"
  ON "store_sales"."ss_item_sk" = "item"."i_item_sk"
GROUP BY
ROLLUP (
  "i_item_id",
  "s_state"
)
ORDER BY
  "i_item_id",
  "s_state"
LIMIT 100
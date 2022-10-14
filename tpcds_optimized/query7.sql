SELECT
  "item"."i_item_id" AS "i_item_id",
  AVG("store_sales"."ss_quantity") AS "agg1",
  AVG("store_sales"."ss_list_price") AS "agg2",
  AVG("store_sales"."ss_coupon_amt") AS "agg3",
  AVG("store_sales"."ss_sales_price") AS "agg4"
FROM "store_sales" AS "store_sales"
JOIN "customer_demographics" AS "customer_demographics"
  ON "customer_demographics"."cd_education_status" = '2 yr Degree'
  AND "customer_demographics"."cd_gender" = 'F'
  AND "customer_demographics"."cd_marital_status" = 'W'
  AND "store_sales"."ss_cdemo_sk" = "customer_demographics"."cd_demo_sk"
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_year" = 1998
  AND "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
JOIN "item" AS "item"
  ON "store_sales"."ss_item_sk" = "item"."i_item_sk"
JOIN "promotion" AS "promotion"
  ON (
    "promotion"."p_channel_email" = 'N'
    OR "promotion"."p_channel_event" = 'N'
  )
  AND "store_sales"."ss_promo_sk" = "promotion"."p_promo_sk"
GROUP BY
  "item"."i_item_id"
ORDER BY
  "i_item_id"
LIMIT 100
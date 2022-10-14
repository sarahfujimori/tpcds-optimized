SELECT
  "item"."i_item_id" AS "i_item_id",
  AVG("catalog_sales"."cs_quantity") AS "agg1",
  AVG("catalog_sales"."cs_list_price") AS "agg2",
  AVG("catalog_sales"."cs_coupon_amt") AS "agg3",
  AVG("catalog_sales"."cs_sales_price") AS "agg4"
FROM "catalog_sales" AS "catalog_sales"
JOIN "customer_demographics" AS "customer_demographics"
  ON "catalog_sales"."cs_bill_cdemo_sk" = "customer_demographics"."cd_demo_sk"
  AND "customer_demographics"."cd_education_status" = 'Secondary'
  AND "customer_demographics"."cd_gender" = 'F'
  AND "customer_demographics"."cd_marital_status" = 'W'
JOIN "date_dim" AS "date_dim"
  ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  AND "date_dim"."d_year" = 2000
JOIN "item" AS "item"
  ON "catalog_sales"."cs_item_sk" = "item"."i_item_sk"
JOIN "promotion" AS "promotion"
  ON "catalog_sales"."cs_promo_sk" = "promotion"."p_promo_sk"
  AND (
    "promotion"."p_channel_email" = 'N'
    OR "promotion"."p_channel_event" = 'N'
  )
GROUP BY
  "item"."i_item_id"
ORDER BY
  "i_item_id"
LIMIT 100
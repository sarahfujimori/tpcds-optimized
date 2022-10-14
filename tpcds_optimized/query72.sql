SELECT
  "item"."i_item_desc" AS "i_item_desc",
  "warehouse"."w_warehouse_name" AS "w_warehouse_name",
  "date_dim_2"."d_week_seq" AS "d_week_seq",
  SUM(CASE
      WHEN "promotion"."p_promo_sk" IS NULL
      THEN 1
      ELSE 0
  END) AS "no_promo",
  SUM(CASE
      WHEN NOT "promotion"."p_promo_sk" IS NULL
      THEN 1
      ELSE 0
  END) AS "promo",
  COUNT(*) AS "total_cnt"
FROM "catalog_sales" AS "catalog_sales"
JOIN "inventory" AS "inventory"
  ON "catalog_sales"."cs_item_sk" = "inventory"."inv_item_sk"
  AND "inventory"."inv_quantity_on_hand" < "catalog_sales"."cs_quantity"
JOIN "warehouse" AS "warehouse"
  ON "warehouse"."w_warehouse_sk" = "inventory"."inv_warehouse_sk"
JOIN "item" AS "item"
  ON "item"."i_item_sk" = "catalog_sales"."cs_item_sk"
JOIN "customer_demographics" AS "customer_demographics"
  ON "catalog_sales"."cs_bill_cdemo_sk" = "customer_demographics"."cd_demo_sk"
  AND "customer_demographics"."cd_marital_status" = 'M'
JOIN "household_demographics" AS "household_demographics"
  ON "catalog_sales"."cs_bill_hdemo_sk" = "household_demographics"."hd_demo_sk"
  AND "household_demographics"."hd_buy_potential" = '501-1000'
JOIN "date_dim" AS "date_dim"
  ON "inventory"."inv_date_sk" = "date_dim"."d_date_sk"
JOIN "date_dim" AS "date_dim_2"
  ON "catalog_sales"."cs_sold_date_sk" = "date_dim_2"."d_date_sk"
  AND "date_dim_2"."d_week_seq" = "date_dim"."d_week_seq"
  AND "date_dim_2"."d_year" = 2002
JOIN "date_dim" AS "date_dim_3"
  ON "catalog_sales"."cs_ship_date_sk" = "date_dim_3"."d_date_sk"
  AND "date_dim_3"."d_date" > "date_dim_2"."d_date" + INTERVAL '5' day
LEFT JOIN "promotion" AS "promotion"
  ON "catalog_sales"."cs_promo_sk" = "promotion"."p_promo_sk"
LEFT JOIN "catalog_returns" AS "catalog_returns"
  ON "catalog_returns"."cr_item_sk" = "catalog_sales"."cs_item_sk"
  AND "catalog_returns"."cr_order_number" = "catalog_sales"."cs_order_number"
GROUP BY
  "item"."i_item_desc",
  "warehouse"."w_warehouse_name",
  "date_dim_2"."d_week_seq"
ORDER BY
  "total_cnt" DESC,
  "i_item_desc",
  "w_warehouse_name",
  "d_week_seq"
LIMIT 100
SELECT
  "item"."i_item_id" AS "i_item_id",
  "customer_address"."ca_country" AS "ca_country",
  "customer_address"."ca_state" AS "ca_state",
  "customer_address"."ca_county" AS "ca_county",
  AVG(CAST("catalog_sales"."cs_quantity" AS DECIMAL(12, 2))) AS "agg1",
  AVG(CAST("catalog_sales"."cs_list_price" AS DECIMAL(12, 2))) AS "agg2",
  AVG(CAST("catalog_sales"."cs_coupon_amt" AS DECIMAL(12, 2))) AS "agg3",
  AVG(CAST("catalog_sales"."cs_sales_price" AS DECIMAL(12, 2))) AS "agg4",
  AVG(CAST("catalog_sales"."cs_net_profit" AS DECIMAL(12, 2))) AS "agg5",
  AVG(CAST("customer"."c_birth_year" AS DECIMAL(12, 2))) AS "agg6",
  AVG(CAST("customer_demographics"."cd_dep_count" AS DECIMAL(12, 2))) AS "agg7"
FROM "catalog_sales" AS "catalog_sales"
JOIN "customer_demographics" AS "customer_demographics"
  ON "catalog_sales"."cs_bill_cdemo_sk" = "customer_demographics"."cd_demo_sk"
  AND "customer_demographics"."cd_education_status" = 'Secondary'
  AND "customer_demographics"."cd_gender" = 'F'
JOIN "customer" AS "customer"
  ON "catalog_sales"."cs_bill_customer_sk" = "customer"."c_customer_sk"
  AND "customer"."c_birth_month" IN (8, 4, 2, 5, 11, 9)
JOIN "customer_demographics" AS "customer_demographics_2"
  ON "customer"."c_current_cdemo_sk" = "customer_demographics_2"."cd_demo_sk"
JOIN "customer_address" AS "customer_address"
  ON "customer"."c_current_addr_sk" = "customer_address"."ca_address_sk"
  AND "customer_address"."ca_state" IN ('KS', 'IA', 'AL', 'UT', 'VA', 'NC', 'TX')
JOIN "date_dim" AS "date_dim"
  ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  AND "date_dim"."d_year" = 2001
JOIN "item" AS "item"
  ON "catalog_sales"."cs_item_sk" = "item"."i_item_sk"
GROUP BY
ROLLUP (
  "i_item_id",
  "ca_country",
  "ca_state",
  "ca_county"
)
ORDER BY
  "ca_country",
  "ca_state",
  "ca_county",
  "i_item_id"
LIMIT 100
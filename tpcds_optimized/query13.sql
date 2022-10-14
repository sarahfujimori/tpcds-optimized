SELECT
  AVG("store_sales"."ss_quantity") AS "_col_0",
  AVG("store_sales"."ss_ext_sales_price") AS "_col_1",
  AVG("store_sales"."ss_ext_wholesale_cost") AS "_col_2",
  SUM("store_sales"."ss_ext_wholesale_cost") AS "_col_3"
FROM "store_sales" AS "store_sales"
JOIN "store" AS "store"
  ON "store"."s_store_sk" = "store_sales"."ss_store_sk"
CROSS JOIN "household_demographics" AS "household_demographics"
JOIN "customer_demographics" AS "customer_demographics"
  ON "customer_demographics"."cd_demo_sk" = "store_sales"."ss_cdemo_sk"
  AND "customer_demographics"."cd_education_status" = 'Advanced Degree'
  AND "customer_demographics"."cd_education_status" = 'Primary'
  AND "customer_demographics"."cd_education_status" = 'Secondary'
  AND "customer_demographics"."cd_marital_status" = 'D'
  AND "customer_demographics"."cd_marital_status" = 'M'
  AND "customer_demographics"."cd_marital_status" = 'U'
  AND "household_demographics"."hd_dep_count" = 1
  AND "household_demographics"."hd_dep_count" = 3
  AND "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
  AND "store_sales"."ss_sales_price" BETWEEN 100.00 AND 150.00
  AND "store_sales"."ss_sales_price" BETWEEN 150.00 AND 200.00
  AND "store_sales"."ss_sales_price" BETWEEN 50.00 AND 100.00
JOIN "customer_address" AS "customer_address"
  ON (
    "customer_address"."ca_country" = 'United States'
    AND "customer_address"."ca_state" IN ('AZ', 'NE', 'IA')
    AND "store_sales"."ss_addr_sk" = "customer_address"."ca_address_sk"
    AND "store_sales"."ss_net_profit" BETWEEN 100 AND 200
  )
  OR (
    "customer_address"."ca_country" = 'United States'
    AND "customer_address"."ca_state" IN ('GA', 'TX', 'NJ')
    AND "store_sales"."ss_addr_sk" = "customer_address"."ca_address_sk"
    AND "store_sales"."ss_net_profit" BETWEEN 50 AND 250
  )
  OR (
    "customer_address"."ca_country" = 'United States'
    AND "customer_address"."ca_state" IN ('MS', 'CA', 'NV')
    AND "store_sales"."ss_addr_sk" = "customer_address"."ca_address_sk"
    AND "store_sales"."ss_net_profit" BETWEEN 150 AND 300
  )
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_year" = 2001
  AND "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
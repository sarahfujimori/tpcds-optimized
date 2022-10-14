SELECT
  SUM("store_sales"."ss_quantity") AS "_col_0"
FROM "store_sales" AS "store_sales"
JOIN "store" AS "store"
  ON "store"."s_store_sk" = "store_sales"."ss_store_sk"
JOIN "customer_demographics" AS "customer_demographics"
  ON (
    "customer_demographics"."cd_demo_sk" = "store_sales"."ss_cdemo_sk"
    AND "customer_demographics"."cd_education_status" = '2 yr Degree'
    AND "customer_demographics"."cd_marital_status" = 'D'
    AND "store_sales"."ss_sales_price" BETWEEN 150.00 AND 200.00
  )
  OR (
    "customer_demographics"."cd_demo_sk" = "store_sales"."ss_cdemo_sk"
    AND "customer_demographics"."cd_education_status" = 'Advanced Degree'
    AND "customer_demographics"."cd_marital_status" = 'M'
    AND "store_sales"."ss_sales_price" BETWEEN 50.00 AND 100.00
  )
  OR (
    "customer_demographics"."cd_demo_sk" = "store_sales"."ss_cdemo_sk"
    AND "customer_demographics"."cd_education_status" = 'Secondary'
    AND "customer_demographics"."cd_marital_status" = 'W'
    AND "store_sales"."ss_sales_price" BETWEEN 100.00 AND 150.00
  )
JOIN "customer_address" AS "customer_address"
  ON (
    "customer_address"."ca_country" = 'United States'
    AND "customer_address"."ca_state" IN ('CO', 'TN', 'ND')
    AND "store_sales"."ss_addr_sk" = "customer_address"."ca_address_sk"
    AND "store_sales"."ss_net_profit" BETWEEN 150 AND 3000
  )
  OR (
    "customer_address"."ca_country" = 'United States'
    AND "customer_address"."ca_state" IN ('OK', 'PA', 'CA')
    AND "store_sales"."ss_addr_sk" = "customer_address"."ca_address_sk"
    AND "store_sales"."ss_net_profit" BETWEEN 50 AND 25000
  )
  OR (
    "customer_address"."ca_country" = 'United States'
    AND "customer_address"."ca_state" IN ('TX', 'NE', 'MO')
    AND "store_sales"."ss_addr_sk" = "customer_address"."ca_address_sk"
    AND "store_sales"."ss_net_profit" BETWEEN 0 AND 2000
  )
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_year" = 1999
  AND "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
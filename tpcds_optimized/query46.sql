WITH "customer_address_2" AS (
  SELECT
    "customer_address"."ca_address_sk" AS "ca_address_sk",
    "customer_address"."ca_city" AS "ca_city"
  FROM "customer_address" AS "customer_address"
), "dn" AS (
  SELECT
    "store_sales"."ss_ticket_number" AS "ss_ticket_number",
    "store_sales"."ss_customer_sk" AS "ss_customer_sk",
    "customer_address"."ca_city" AS "bought_city",
    SUM("store_sales"."ss_coupon_amt") AS "amt",
    SUM("store_sales"."ss_net_profit") AS "profit"
  FROM "store_sales" AS "store_sales"
  JOIN "date_dim" AS "date_dim"
    ON "date_dim"."d_dow" IN (6, 0)
    AND "date_dim"."d_year" IN (2000, 2001, 2002)
    AND "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "store" AS "store"
    ON "store"."s_city" IN ('Midway', 'Fairview', 'Fairview', 'Fairview', 'Fairview')
    AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
  JOIN "household_demographics" AS "household_demographics"
    ON (
      "household_demographics"."hd_dep_count" = 6
      OR "household_demographics"."hd_vehicle_count" = 0
    )
    AND "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
  JOIN "customer_address_2" AS "customer_address"
    ON "store_sales"."ss_addr_sk" = "customer_address"."ca_address_sk"
  GROUP BY
    "store_sales"."ss_ticket_number",
    "store_sales"."ss_customer_sk",
    "store_sales"."ss_addr_sk",
    "customer_address"."ca_city"
)
SELECT
  "customer"."c_last_name" AS "c_last_name",
  "customer"."c_first_name" AS "c_first_name",
  "current_addr"."ca_city" AS "ca_city",
  "dn"."bought_city" AS "bought_city",
  "dn"."ss_ticket_number" AS "ss_ticket_number",
  "dn"."amt" AS "amt",
  "dn"."profit" AS "profit"
FROM "dn" AS "dn"
JOIN "customer_address_2" AS "current_addr"
  ON "current_addr"."ca_city" <> "dn"."bought_city"
JOIN "customer" AS "customer"
  ON "customer"."c_current_addr_sk" = "current_addr"."ca_address_sk"
  AND "dn"."ss_customer_sk" = "customer"."c_customer_sk"
ORDER BY
  "c_last_name",
  "c_first_name",
  "ca_city",
  "bought_city",
  "ss_ticket_number"
LIMIT 100
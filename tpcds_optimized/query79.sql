WITH "ms" AS (
  SELECT
    "store_sales"."ss_ticket_number" AS "ss_ticket_number",
    "store_sales"."ss_customer_sk" AS "ss_customer_sk",
    "store"."s_city" AS "s_city",
    SUM("store_sales"."ss_coupon_amt") AS "amt",
    SUM("store_sales"."ss_net_profit") AS "profit"
  FROM "store_sales" AS "store_sales"
  JOIN "date_dim" AS "date_dim"
    ON "date_dim"."d_dow" = 1
    AND "date_dim"."d_year" IN (2000, 2001, 2002)
    AND "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "store" AS "store"
    ON "store"."s_number_employees" BETWEEN 200 AND 295
    AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
  JOIN "household_demographics" AS "household_demographics"
    ON (
      "household_demographics"."hd_dep_count" = 8
      OR "household_demographics"."hd_vehicle_count" > 4
    )
    AND "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
  GROUP BY
    "store_sales"."ss_ticket_number",
    "store_sales"."ss_customer_sk",
    "store_sales"."ss_addr_sk",
    "store"."s_city"
)
SELECT
  "customer"."c_last_name" AS "c_last_name",
  "customer"."c_first_name" AS "c_first_name",
  SUBSTR("ms"."s_city", 1, 30) AS "_col_2",
  "ms"."ss_ticket_number" AS "ss_ticket_number",
  "ms"."amt" AS "amt",
  "ms"."profit" AS "profit"
FROM "ms" AS "ms"
JOIN "customer" AS "customer"
  ON "ms"."ss_customer_sk" = "customer"."c_customer_sk"
ORDER BY
  "c_last_name",
  "c_first_name",
  SUBSTR("ms"."s_city", 1, 30),
  "profit"
LIMIT 100
WITH "dj" AS (
  SELECT
    "store_sales"."ss_ticket_number" AS "ss_ticket_number",
    "store_sales"."ss_customer_sk" AS "ss_customer_sk",
    COUNT(*) AS "cnt"
  FROM "store_sales" AS "store_sales"
  JOIN "date_dim" AS "date_dim"
    ON "date_dim"."d_dom" BETWEEN 1 AND 2
    AND "date_dim"."d_year" IN (2000, 2001, 2002)
    AND "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "store" AS "store"
    ON "store"."s_county" IN ('Williamson County', 'Williamson County', 'Williamson County', 'Williamson County')
    AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
  JOIN "household_demographics" AS "household_demographics"
    ON (
      "household_demographics"."hd_buy_potential" = '0-500'
      OR "household_demographics"."hd_buy_potential" = '>10000'
    )
    AND "household_demographics"."hd_vehicle_count" > 0
    AND "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
    AND CASE
      WHEN "household_demographics"."hd_vehicle_count" > 0
      THEN "household_demographics"."hd_dep_count" / "household_demographics"."hd_vehicle_count"
      ELSE NULL
    END > 1
  GROUP BY
    "store_sales"."ss_ticket_number",
    "store_sales"."ss_customer_sk"
)
SELECT
  "customer"."c_last_name" AS "c_last_name",
  "customer"."c_first_name" AS "c_first_name",
  "customer"."c_salutation" AS "c_salutation",
  "customer"."c_preferred_cust_flag" AS "c_preferred_cust_flag",
  "dj"."ss_ticket_number" AS "ss_ticket_number",
  "dj"."cnt" AS "cnt"
FROM "dj" AS "dj"
JOIN "customer" AS "customer"
  ON "dj"."ss_customer_sk" = "customer"."c_customer_sk"
WHERE
  "dj"."cnt" BETWEEN 1 AND 5
ORDER BY
  "cnt" DESC,
  "c_last_name"
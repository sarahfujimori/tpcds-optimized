WITH "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_year" AS "d_year",
    "date_dim"."d_qoy" AS "d_qoy"
  FROM "date_dim" AS "date_dim"
), "customer_address_2" AS (
  SELECT
    "customer_address"."ca_address_sk" AS "ca_address_sk",
    "customer_address"."ca_county" AS "ca_county"
  FROM "customer_address" AS "customer_address"
), "ss" AS (
  SELECT
    "customer_address"."ca_county" AS "ca_county",
    "date_dim"."d_qoy" AS "d_qoy",
    "date_dim"."d_year" AS "d_year",
    SUM("store_sales"."ss_ext_sales_price") AS "store_sales"
  FROM "store_sales" AS "store_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "customer_address_2" AS "customer_address"
    ON "store_sales"."ss_addr_sk" = "customer_address"."ca_address_sk"
  GROUP BY
    "customer_address"."ca_county",
    "date_dim"."d_qoy",
    "date_dim"."d_year"
), "ws" AS (
  SELECT
    "customer_address"."ca_county" AS "ca_county",
    "date_dim"."d_qoy" AS "d_qoy",
    "date_dim"."d_year" AS "d_year",
    SUM("web_sales"."ws_ext_sales_price") AS "web_sales"
  FROM "web_sales" AS "web_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "customer_address_2" AS "customer_address"
    ON "web_sales"."ws_bill_addr_sk" = "customer_address"."ca_address_sk"
  GROUP BY
    "customer_address"."ca_county",
    "date_dim"."d_qoy",
    "date_dim"."d_year"
)
SELECT
  "ss1"."ca_county" AS "ca_county",
  "ss1"."d_year" AS "d_year",
  "ws2"."web_sales" / "ws1"."web_sales" AS "web_q1_q2_increase",
  "ss2"."store_sales" / "ss1"."store_sales" AS "store_q1_q2_increase",
  "ws3"."web_sales" / "ws2"."web_sales" AS "web_q2_q3_increase",
  "ss3"."store_sales" / "ss2"."store_sales" AS "store_q2_q3_increase"
FROM "ss" AS "ss1"
JOIN "ss" AS "ss2"
  ON "ss1"."ca_county" = "ss2"."ca_county"
  AND "ss2"."d_qoy" = 2
  AND "ss2"."d_year" = 2001
JOIN "ws" AS "ws2"
  ON "ws2"."d_qoy" = 2
  AND "ws2"."d_year" = 2001
JOIN "ws" AS "ws1"
  ON "ss1"."ca_county" = "ws1"."ca_county"
  AND "ws1"."ca_county" = "ws2"."ca_county"
  AND "ws1"."d_qoy" = 1
  AND "ws1"."d_year" = 2001
  AND CASE
    WHEN "ws1"."web_sales" > 0
    THEN "ws2"."web_sales" / "ws1"."web_sales"
    ELSE NULL
  END > CASE
    WHEN "ss1"."store_sales" > 0
    THEN "ss2"."store_sales" / "ss1"."store_sales"
    ELSE NULL
  END
JOIN "ws" AS "ws3"
  ON "ws1"."ca_county" = "ws3"."ca_county"
  AND "ws3"."d_qoy" = 3
  AND "ws3"."d_year" = 2001
JOIN "ss" AS "ss3"
  ON "ss2"."ca_county" = "ss3"."ca_county"
  AND "ss3"."d_qoy" = 3
  AND "ss3"."d_year" = 2001
  AND CASE
    WHEN "ws2"."web_sales" > 0
    THEN "ws3"."web_sales" / "ws2"."web_sales"
    ELSE NULL
  END > CASE
    WHEN "ss2"."store_sales" > 0
    THEN "ss3"."store_sales" / "ss2"."store_sales"
    ELSE NULL
  END
WHERE
  "ss1"."d_qoy" = 1
  AND "ss1"."d_year" = 2001
ORDER BY
  "ss1"."d_year"
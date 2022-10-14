WITH "cd2" AS (
  SELECT
    "customer_demographics"."cd_demo_sk" AS "cd_demo_sk",
    "customer_demographics"."cd_marital_status" AS "cd_marital_status",
    "customer_demographics"."cd_education_status" AS "cd_education_status"
  FROM "customer_demographics" AS "customer_demographics"
)
SELECT
  SUBSTR("reason"."r_reason_desc", 1, 20) AS "_col_0",
  AVG("web_sales"."ws_quantity") AS "_col_1",
  AVG("web_returns"."wr_refunded_cash") AS "_col_2",
  AVG("web_returns"."wr_fee") AS "_col_3"
FROM "web_sales" AS "web_sales"
JOIN "web_returns" AS "web_returns"
  ON "web_sales"."ws_item_sk" = "web_returns"."wr_item_sk"
  AND "web_sales"."ws_order_number" = "web_returns"."wr_order_number"
JOIN "web_page" AS "web_page"
  ON "web_sales"."ws_web_page_sk" = "web_page"."wp_web_page_sk"
JOIN "cd2" AS "cd2"
  ON "cd2"."cd_demo_sk" = "web_returns"."wr_returning_cdemo_sk"
JOIN "cd2" AS "cd1"
  ON "cd1"."cd_demo_sk" = "web_returns"."wr_refunded_cdemo_sk"
  AND (
    (
      "cd1"."cd_education_status" = "cd2"."cd_education_status"
      AND "cd1"."cd_education_status" = 'Advanced Degree'
      AND "cd1"."cd_marital_status" = "cd2"."cd_marital_status"
      AND "cd1"."cd_marital_status" = 'M'
      AND "web_sales"."ws_sales_price" BETWEEN 150.00 AND 200.00
    )
    OR (
      "cd1"."cd_education_status" = "cd2"."cd_education_status"
      AND "cd1"."cd_education_status" = 'Primary'
      AND "cd1"."cd_marital_status" = "cd2"."cd_marital_status"
      AND "cd1"."cd_marital_status" = 'W'
      AND "web_sales"."ws_sales_price" BETWEEN 100.00 AND 150.00
    )
    OR (
      "cd1"."cd_education_status" = "cd2"."cd_education_status"
      AND "cd1"."cd_education_status" = 'Secondary'
      AND "cd1"."cd_marital_status" = "cd2"."cd_marital_status"
      AND "cd1"."cd_marital_status" = 'D'
      AND "web_sales"."ws_sales_price" BETWEEN 50.00 AND 100.00
    )
  )
JOIN "customer_address" AS "customer_address"
  ON "customer_address"."ca_address_sk" = "web_returns"."wr_refunded_addr_sk"
  AND (
    (
      "customer_address"."ca_country" = 'United States'
      AND "customer_address"."ca_state" IN ('FL', 'WI', 'KS')
      AND "web_sales"."ws_net_profit" BETWEEN 50 AND 250
    )
    OR (
      "customer_address"."ca_country" = 'United States'
      AND "customer_address"."ca_state" IN ('KY', 'ME', 'IL')
      AND "web_sales"."ws_net_profit" BETWEEN 100 AND 200
    )
    OR (
      "customer_address"."ca_country" = 'United States'
      AND "customer_address"."ca_state" IN ('OK', 'NE', 'MN')
      AND "web_sales"."ws_net_profit" BETWEEN 150 AND 300
    )
  )
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_year" = 2001
  AND "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
JOIN "reason" AS "reason"
  ON "reason"."r_reason_sk" = "web_returns"."wr_reason_sk"
GROUP BY
  "reason"."r_reason_desc"
ORDER BY
  SUBSTR("reason"."r_reason_desc", 1, 20),
  AVG("web_sales"."ws_quantity"),
  AVG("web_returns"."wr_refunded_cash"),
  AVG("web_returns"."wr_fee")
LIMIT 100
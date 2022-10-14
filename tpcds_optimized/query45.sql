WITH "_u_0" AS (
  SELECT
    "item"."i_item_id" AS "i_item_id"
  FROM "item" AS "item"
  WHERE
    "item"."i_item_sk" IN (2, 3, 5, 7, 11, 13, 17, 19, 23, 29)
  GROUP BY
    "item"."i_item_id"
)
SELECT
  "customer_address"."ca_zip" AS "ca_zip",
  "customer_address"."ca_state" AS "ca_state",
  SUM("web_sales"."ws_sales_price") AS "_col_2"
FROM "web_sales" AS "web_sales"
JOIN "item" AS "item"
  ON "web_sales"."ws_item_sk" = "item"."i_item_sk"
LEFT JOIN "_u_0" AS "_u_0"
  ON "item"."i_item_id" = "_u_0"."i_item_id"
JOIN "customer" AS "customer"
  ON "web_sales"."ws_bill_customer_sk" = "customer"."c_customer_sk"
JOIN "customer_address" AS "customer_address"
  ON "customer"."c_current_addr_sk" = "customer_address"."ca_address_sk"
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_qoy" = 1
  AND "date_dim"."d_year" = 2000
  AND "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
WHERE
  NOT "_u_0"."i_item_id" IS NULL
  OR SUBSTR("customer_address"."ca_zip", 1, 5) IN ('85669', '86197', '88274', '83405', '86475', '85392', '85460', '80348', '81792')
GROUP BY
  "customer_address"."ca_zip",
  "customer_address"."ca_state"
ORDER BY
  "ca_zip",
  "ca_state"
LIMIT 100
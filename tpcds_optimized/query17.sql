WITH "d3" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_quarter_name" AS "d_quarter_name"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_quarter_name" IN ('1999Q1', '1999Q2', '1999Q3')
)
SELECT
  "item"."i_item_id" AS "i_item_id",
  "item"."i_item_desc" AS "i_item_desc",
  "store"."s_state" AS "s_state",
  COUNT("store_sales"."ss_quantity") AS "store_sales_quantitycount",
  AVG("store_sales"."ss_quantity") AS "store_sales_quantityave",
  STDDEV_SAMP("store_sales"."ss_quantity") AS "store_sales_quantitystdev",
  STDDEV_SAMP("store_sales"."ss_quantity") / AVG("store_sales"."ss_quantity") AS "store_sales_quantitycov",
  COUNT("store_returns"."sr_return_quantity") AS "store_returns_quantitycount",
  AVG("store_returns"."sr_return_quantity") AS "store_returns_quantityave",
  STDDEV_SAMP("store_returns"."sr_return_quantity") AS "store_returns_quantitystdev",
  STDDEV_SAMP("store_returns"."sr_return_quantity") / AVG("store_returns"."sr_return_quantity") AS "store_returns_quantitycov",
  COUNT("catalog_sales"."cs_quantity") AS "catalog_sales_quantitycount",
  AVG("catalog_sales"."cs_quantity") AS "catalog_sales_quantityave",
  STDDEV_SAMP("catalog_sales"."cs_quantity") / AVG("catalog_sales"."cs_quantity") AS "catalog_sales_quantitystdev",
  STDDEV_SAMP("catalog_sales"."cs_quantity") / AVG("catalog_sales"."cs_quantity") AS "catalog_sales_quantitycov"
FROM "store_sales" AS "store_sales"
CROSS JOIN "d3" AS "d3"
JOIN "catalog_sales" AS "catalog_sales"
  ON "catalog_sales"."cs_sold_date_sk" = "d3"."d_date_sk"
JOIN "store_returns" AS "store_returns"
  ON "store_returns"."sr_customer_sk" = "catalog_sales"."cs_bill_customer_sk"
  AND "store_returns"."sr_item_sk" = "catalog_sales"."cs_item_sk"
  AND "store_sales"."ss_customer_sk" = "store_returns"."sr_customer_sk"
  AND "store_sales"."ss_item_sk" = "store_returns"."sr_item_sk"
  AND "store_sales"."ss_ticket_number" = "store_returns"."sr_ticket_number"
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_date_sk" = "store_sales"."ss_sold_date_sk"
  AND "date_dim"."d_quarter_name" = '1999Q1'
JOIN "d3" AS "d2"
  ON "store_returns"."sr_returned_date_sk" = "d2"."d_date_sk"
JOIN "store" AS "store"
  ON "store"."s_store_sk" = "store_sales"."ss_store_sk"
JOIN "item" AS "item"
  ON "item"."i_item_sk" = "store_sales"."ss_item_sk"
GROUP BY
  "item"."i_item_id",
  "item"."i_item_desc",
  "store"."s_state"
ORDER BY
  "i_item_id",
  "i_item_desc",
  "s_state"
LIMIT 100
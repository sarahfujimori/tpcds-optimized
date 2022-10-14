WITH "d3" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_year" AS "d_year",
    "date_dim"."d_moy" AS "d_moy"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_moy" BETWEEN 4 AND 10
    AND "date_dim"."d_year" = 2001
)
SELECT
  "item"."i_item_id" AS "i_item_id",
  "item"."i_item_desc" AS "i_item_desc",
  "store"."s_store_id" AS "s_store_id",
  "store"."s_store_name" AS "s_store_name",
  MAX("store_sales"."ss_net_profit") AS "store_sales_profit",
  MAX("store_returns"."sr_net_loss") AS "store_returns_loss",
  MAX("catalog_sales"."cs_net_profit") AS "catalog_sales_profit"
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
  AND "date_dim"."d_moy" = 4
  AND "date_dim"."d_year" = 2001
JOIN "d3" AS "d2"
  ON "store_returns"."sr_returned_date_sk" = "d2"."d_date_sk"
JOIN "store" AS "store"
  ON "store"."s_store_sk" = "store_sales"."ss_store_sk"
JOIN "item" AS "item"
  ON "item"."i_item_sk" = "store_sales"."ss_item_sk"
GROUP BY
  "item"."i_item_id",
  "item"."i_item_desc",
  "store"."s_store_id",
  "store"."s_store_name"
ORDER BY
  "i_item_id",
  "i_item_desc",
  "s_store_id",
  "s_store_name"
LIMIT 100
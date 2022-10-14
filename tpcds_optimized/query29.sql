SELECT
  "item"."i_item_id" AS "i_item_id",
  "item"."i_item_desc" AS "i_item_desc",
  "store"."s_store_id" AS "s_store_id",
  "store"."s_store_name" AS "s_store_name",
  AVG("store_sales"."ss_quantity") AS "store_sales_quantity",
  AVG("store_returns"."sr_return_quantity") AS "store_returns_quantity",
  AVG("catalog_sales"."cs_quantity") AS "catalog_sales_quantity"
FROM "store_sales" AS "store_sales"
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_year" IN (1998, 1999, 2000)
JOIN "catalog_sales" AS "catalog_sales"
  ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
JOIN "store_returns" AS "store_returns"
  ON "store_returns"."sr_customer_sk" = "catalog_sales"."cs_bill_customer_sk"
  AND "store_returns"."sr_item_sk" = "catalog_sales"."cs_item_sk"
  AND "store_sales"."ss_customer_sk" = "store_returns"."sr_customer_sk"
  AND "store_sales"."ss_item_sk" = "store_returns"."sr_item_sk"
  AND "store_sales"."ss_ticket_number" = "store_returns"."sr_ticket_number"
JOIN "date_dim" AS "date_dim_2"
  ON "date_dim_2"."d_date_sk" = "store_sales"."ss_sold_date_sk"
  AND "date_dim_2"."d_moy" = 4
  AND "date_dim_2"."d_year" = 1998
JOIN "date_dim" AS "date_dim_3"
  ON "date_dim_3"."d_moy" BETWEEN 4 AND 7
  AND "date_dim_3"."d_year" = 1998
  AND "store_returns"."sr_returned_date_sk" = "date_dim_3"."d_date_sk"
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
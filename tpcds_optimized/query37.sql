SELECT
  "item"."i_item_id" AS "i_item_id",
  "item"."i_item_desc" AS "i_item_desc",
  "item"."i_current_price" AS "i_current_price"
FROM "item" AS "item"
JOIN "inventory" AS "inventory"
  ON "inventory"."inv_item_sk" = "item"."i_item_sk"
  AND "inventory"."inv_quantity_on_hand" BETWEEN 100 AND 500
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_date" BETWEEN CAST('1999-03-06' AS DATE) AND CAST('1999-05-05' AS DATE)
  AND "date_dim"."d_date_sk" = "inventory"."inv_date_sk"
JOIN "catalog_sales" AS "catalog_sales"
  ON "catalog_sales"."cs_item_sk" = "item"."i_item_sk"
WHERE
  "item"."i_current_price" BETWEEN 20 AND 50
  AND "item"."i_manufact_id" IN (843, 815, 850, 840)
GROUP BY
  "item"."i_item_id",
  "item"."i_item_desc",
  "item"."i_current_price"
ORDER BY
  "i_item_id"
LIMIT 100
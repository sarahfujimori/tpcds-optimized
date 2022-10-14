SELECT
  "item"."i_item_id" AS "i_item_id",
  "item"."i_item_desc" AS "i_item_desc",
  "item"."i_current_price" AS "i_current_price"
FROM "item" AS "item"
JOIN "inventory" AS "inventory"
  ON "inventory"."inv_item_sk" = "item"."i_item_sk"
  AND "inventory"."inv_quantity_on_hand" BETWEEN 100 AND 500
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_date" BETWEEN CAST('1998-04-27' AS DATE) AND CAST('1998-06-26' AS DATE)
  AND "date_dim"."d_date_sk" = "inventory"."inv_date_sk"
JOIN "store_sales" AS "store_sales"
  ON "store_sales"."ss_item_sk" = "item"."i_item_sk"
WHERE
  "item"."i_current_price" BETWEEN 63 AND 93
  AND "item"."i_manufact_id" IN (57, 293, 427, 320)
GROUP BY
  "item"."i_item_id",
  "item"."i_item_desc",
  "item"."i_current_price"
ORDER BY
  "i_item_id"
LIMIT 100
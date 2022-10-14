SELECT
  "item"."i_product_name" AS "i_product_name",
  "item"."i_brand" AS "i_brand",
  "item"."i_class" AS "i_class",
  "item"."i_category" AS "i_category",
  AVG("inventory"."inv_quantity_on_hand") AS "qoh"
FROM "inventory" AS "inventory"
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_month_seq" BETWEEN 1205 AND 1216
  AND "inventory"."inv_date_sk" = "date_dim"."d_date_sk"
JOIN "item" AS "item"
  ON "inventory"."inv_item_sk" = "item"."i_item_sk"
JOIN "warehouse" AS "warehouse"
  ON "inventory"."inv_warehouse_sk" = "warehouse"."w_warehouse_sk"
GROUP BY
ROLLUP (
  "i_product_name",
  "i_brand",
  "i_class",
  "i_category"
)
ORDER BY
  "qoh",
  "i_product_name",
  "i_brand",
  "i_class",
  "i_category"
LIMIT 100
SELECT
  "item"."i_item_id" AS "i_item_id",
  "item"."i_item_desc" AS "i_item_desc",
  "item"."i_category" AS "i_category",
  "item"."i_class" AS "i_class",
  "item"."i_current_price" AS "i_current_price",
  SUM("catalog_sales"."cs_ext_sales_price") AS "itemrevenue",
  SUM("catalog_sales"."cs_ext_sales_price") * 100 / SUM(SUM("catalog_sales"."cs_ext_sales_price")) OVER (PARTITION BY "item"."i_class") AS "revenueratio"
FROM "catalog_sales" AS "catalog_sales"
JOIN "item" AS "item"
  ON "catalog_sales"."cs_item_sk" = "item"."i_item_sk"
  AND "item"."i_category" IN ('Children', 'Women', 'Electronics')
JOIN "date_dim" AS "date_dim"
  ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  AND "date_dim"."d_date" BETWEEN CAST('2001-02-03' AS DATE) AND CAST('2001-03-05' AS DATE)
GROUP BY
  "item"."i_item_id",
  "item"."i_item_desc",
  "item"."i_category",
  "item"."i_class",
  "item"."i_current_price"
ORDER BY
  "i_category",
  "i_class",
  "i_item_id",
  "i_item_desc",
  "revenueratio"
LIMIT 100
SELECT
  "item"."i_item_id" AS "i_item_id",
  "item"."i_item_desc" AS "i_item_desc",
  "item"."i_category" AS "i_category",
  "item"."i_class" AS "i_class",
  "item"."i_current_price" AS "i_current_price",
  SUM("web_sales"."ws_ext_sales_price") AS "itemrevenue",
  SUM("web_sales"."ws_ext_sales_price") * 100 / SUM(SUM("web_sales"."ws_ext_sales_price")) OVER (PARTITION BY "item"."i_class") AS "revenueratio"
FROM "web_sales" AS "web_sales"
JOIN "item" AS "item"
  ON "item"."i_category" IN ('Home', 'Men', 'Women')
  AND "web_sales"."ws_item_sk" = "item"."i_item_sk"
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_date" BETWEEN CAST('2000-05-11' AS DATE) AND CAST('2000-06-10' AS DATE)
  AND "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
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
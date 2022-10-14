SELECT
  SUM("web_sales"."ws_net_paid") AS "total_sum",
  "item"."i_category" AS "i_category",
  "item"."i_class" AS "i_class",
  GROUPING("item"."i_category") + GROUPING("item"."i_class") AS "lochierarchy",
  RANK() OVER (PARTITION BY GROUPING("item"."i_category") + GROUPING("item"."i_class"), CASE
    WHEN GROUPING("item"."i_class") = 0
    THEN "item"."i_category"
  END ORDER BY SUM("web_sales"."ws_net_paid") DESC) AS "rank_within_parent"
FROM "web_sales" AS "web_sales"
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_date_sk" = "web_sales"."ws_sold_date_sk"
  AND "date_dim"."d_month_seq" BETWEEN 1183 AND 1194
JOIN "item" AS "item"
  ON "item"."i_item_sk" = "web_sales"."ws_item_sk"
GROUP BY
ROLLUP (
  "i_category",
  "i_class"
)
ORDER BY
  "lochierarchy" DESC,
  CASE
    WHEN "lochierarchy" = 0
    THEN "i_category"
  END,
  "rank_within_parent"
LIMIT 100
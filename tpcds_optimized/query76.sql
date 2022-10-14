WITH "item_2" AS (
  SELECT
    "item"."i_item_sk" AS "i_item_sk",
    "item"."i_category" AS "i_category"
  FROM "item" AS "item"
), "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_year" AS "d_year",
    "date_dim"."d_qoy" AS "d_qoy"
  FROM "date_dim" AS "date_dim"
), "cte_4" AS (
  SELECT
    'web' AS "channel",
    'ws_ship_hdemo_sk' AS "col_name",
    "date_dim"."d_year" AS "d_year",
    "date_dim"."d_qoy" AS "d_qoy",
    "item"."i_category" AS "i_category",
    "web_sales"."ws_ext_sales_price" AS "ext_sales_price"
  FROM "web_sales" AS "web_sales"
  JOIN "item_2" AS "item"
    ON "web_sales"."ws_item_sk" = "item"."i_item_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
  WHERE
    "web_sales"."ws_ship_hdemo_sk" IS NULL
  UNION ALL
  SELECT
    'catalog' AS "channel",
    'cs_warehouse_sk' AS "col_name",
    "date_dim"."d_year" AS "d_year",
    "date_dim"."d_qoy" AS "d_qoy",
    "item"."i_category" AS "i_category",
    "catalog_sales"."cs_ext_sales_price" AS "ext_sales_price"
  FROM "catalog_sales" AS "catalog_sales"
  JOIN "item_2" AS "item"
    ON "catalog_sales"."cs_item_sk" = "item"."i_item_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  WHERE
    "catalog_sales"."cs_warehouse_sk" IS NULL
), "foo" AS (
  SELECT
    'store' AS "channel",
    'ss_hdemo_sk' AS "col_name",
    "date_dim"."d_year" AS "d_year",
    "date_dim"."d_qoy" AS "d_qoy",
    "item"."i_category" AS "i_category",
    "store_sales"."ss_ext_sales_price" AS "ext_sales_price"
  FROM "store_sales" AS "store_sales"
  JOIN "item_2" AS "item"
    ON "store_sales"."ss_item_sk" = "item"."i_item_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  WHERE
    "store_sales"."ss_hdemo_sk" IS NULL
  UNION ALL
  SELECT
  FROM "cte_4" AS "cte_4"
)
SELECT
  "foo"."channel" AS "channel",
  "foo"."col_name" AS "col_name",
  "foo"."d_year" AS "d_year",
  "foo"."d_qoy" AS "d_qoy",
  "foo"."i_category" AS "i_category",
  COUNT(*) AS "sales_cnt",
  SUM("foo"."ext_sales_price") AS "sales_amt"
FROM "foo" AS "foo"
GROUP BY
  "foo"."channel",
  "foo"."col_name",
  "foo"."d_year",
  "foo"."d_qoy",
  "foo"."i_category"
ORDER BY
  "channel",
  "col_name",
  "d_year",
  "d_qoy",
  "i_category"
LIMIT 100
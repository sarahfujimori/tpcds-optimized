WITH "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_date" AS "d_date"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_date" BETWEEN CAST('2001-08-16' AS DATE) AND CAST('2001-09-15' AS DATE)
), "store_2" AS (
  SELECT
    "store"."s_store_sk" AS "s_store_sk"
  FROM "store" AS "store"
), "ss" AS (
  SELECT
    "store"."s_store_sk" AS "s_store_sk",
    SUM("store_sales"."ss_ext_sales_price") AS "sales",
    SUM("store_sales"."ss_net_profit") AS "profit"
  FROM "store_sales" AS "store_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "store_2" AS "store"
    ON "store_sales"."ss_store_sk" = "store"."s_store_sk"
  GROUP BY
    "store"."s_store_sk"
), "sr" AS (
  SELECT
    "store"."s_store_sk" AS "s_store_sk",
    SUM("store_returns"."sr_return_amt") AS "returns1",
    SUM("store_returns"."sr_net_loss") AS "profit_loss"
  FROM "store_returns" AS "store_returns"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_returns"."sr_returned_date_sk" = "date_dim"."d_date_sk"
  JOIN "store_2" AS "store"
    ON "store_returns"."sr_store_sk" = "store"."s_store_sk"
  GROUP BY
    "store"."s_store_sk"
), "cs" AS (
  SELECT
    "catalog_sales"."cs_call_center_sk" AS "cs_call_center_sk",
    SUM("catalog_sales"."cs_ext_sales_price") AS "sales",
    SUM("catalog_sales"."cs_net_profit") AS "profit"
  FROM "catalog_sales" AS "catalog_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  GROUP BY
    "catalog_sales"."cs_call_center_sk"
), "cr" AS (
  SELECT
    SUM("catalog_returns"."cr_return_amount") AS "returns1",
    SUM("catalog_returns"."cr_net_loss") AS "profit_loss"
  FROM "catalog_returns" AS "catalog_returns"
  JOIN "date_dim_2" AS "date_dim"
    ON "catalog_returns"."cr_returned_date_sk" = "date_dim"."d_date_sk"
  GROUP BY
    "catalog_returns"."cr_call_center_sk"
), "web_page_2" AS (
  SELECT
    "web_page"."wp_web_page_sk" AS "wp_web_page_sk"
  FROM "web_page" AS "web_page"
), "ws" AS (
  SELECT
    "web_page"."wp_web_page_sk" AS "wp_web_page_sk",
    SUM("web_sales"."ws_ext_sales_price") AS "sales",
    SUM("web_sales"."ws_net_profit") AS "profit"
  FROM "web_sales" AS "web_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "web_page_2" AS "web_page"
    ON "web_sales"."ws_web_page_sk" = "web_page"."wp_web_page_sk"
  GROUP BY
    "web_page"."wp_web_page_sk"
), "wr" AS (
  SELECT
    "web_page"."wp_web_page_sk" AS "wp_web_page_sk",
    SUM("web_returns"."wr_return_amt") AS "returns1",
    SUM("web_returns"."wr_net_loss") AS "profit_loss"
  FROM "web_returns" AS "web_returns"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_returns"."wr_returned_date_sk" = "date_dim"."d_date_sk"
  JOIN "web_page_2" AS "web_page"
    ON "web_returns"."wr_web_page_sk" = "web_page"."wp_web_page_sk"
  GROUP BY
    "web_page"."wp_web_page_sk"
), "cte_4" AS (
  SELECT
    'catalog channel' AS "channel",
    "cs"."cs_call_center_sk" AS "id",
    "cs"."sales" AS "sales",
    "cr"."returns1" AS "returns1",
    "cs"."profit" - "cr"."profit_loss" AS "profit"
  FROM "cs"
  CROSS JOIN "cr"
  UNION ALL
  SELECT
    'web channel' AS "channel",
    "ws"."wp_web_page_sk" AS "id",
    "ws"."sales" AS "sales",
    COALESCE("wr"."returns1", 0) AS "returns1",
    "ws"."profit" - COALESCE("wr"."profit_loss", 0) AS "profit"
  FROM "ws"
  LEFT JOIN "wr"
    ON "ws"."wp_web_page_sk" = "wr"."wp_web_page_sk"
), "x" AS (
  SELECT
    'store channel' AS "channel",
    "ss"."s_store_sk" AS "id",
    "ss"."sales" AS "sales",
    COALESCE("sr"."returns1", 0) AS "returns1",
    "ss"."profit" - COALESCE("sr"."profit_loss", 0) AS "profit"
  FROM "ss"
  LEFT JOIN "sr"
    ON "ss"."s_store_sk" = "sr"."s_store_sk"
  UNION ALL
  SELECT
  FROM "cte_4" AS "cte_4"
)
SELECT
  "x"."channel" AS "channel",
  "x"."id" AS "id",
  SUM("x"."sales") AS "sales",
  SUM("x"."returns1") AS "returns1",
  SUM("x"."profit") AS "profit"
FROM "x" AS "x"
GROUP BY
ROLLUP (
  "channel",
  "id"
)
ORDER BY
  "channel",
  "id"
LIMIT 100
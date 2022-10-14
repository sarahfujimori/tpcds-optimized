WITH "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_date" AS "d_date"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_date" BETWEEN CAST('2000-08-26' AS DATE) AND CAST('2000-09-25' AS DATE)
), "item_2" AS (
  SELECT
    "item"."i_item_sk" AS "i_item_sk",
    "item"."i_current_price" AS "i_current_price"
  FROM "item" AS "item"
  WHERE
    "item"."i_current_price" > 50
), "promotion_2" AS (
  SELECT
    "promotion"."p_promo_sk" AS "p_promo_sk",
    "promotion"."p_channel_tv" AS "p_channel_tv"
  FROM "promotion" AS "promotion"
  WHERE
    "promotion"."p_channel_tv" = 'N'
), "ssr" AS (
  SELECT
    "store"."s_store_id" AS "store_id",
    SUM("store_sales"."ss_ext_sales_price") AS "sales",
    SUM(COALESCE("store_returns"."sr_return_amt", 0)) AS "returns1",
    SUM("store_sales"."ss_net_profit" - COALESCE("store_returns"."sr_net_loss", 0)) AS "profit"
  FROM "store_sales" AS "store_sales"
  LEFT JOIN "store_returns" AS "store_returns"
    ON "store_sales"."ss_item_sk" = "store_returns"."sr_item_sk"
    AND "store_sales"."ss_ticket_number" = "store_returns"."sr_ticket_number"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "store" AS "store"
    ON "store_sales"."ss_store_sk" = "store"."s_store_sk"
  JOIN "item_2" AS "item"
    ON "store_sales"."ss_item_sk" = "item"."i_item_sk"
  JOIN "promotion_2" AS "promotion"
    ON "store_sales"."ss_promo_sk" = "promotion"."p_promo_sk"
  GROUP BY
    "store"."s_store_id"
), "csr" AS (
  SELECT
    "catalog_page"."cp_catalog_page_id" AS "catalog_page_id",
    SUM("catalog_sales"."cs_ext_sales_price") AS "sales",
    SUM(COALESCE("catalog_returns"."cr_return_amount", 0)) AS "returns1",
    SUM("catalog_sales"."cs_net_profit" - COALESCE("catalog_returns"."cr_net_loss", 0)) AS "profit"
  FROM "catalog_sales" AS "catalog_sales"
  LEFT JOIN "catalog_returns" AS "catalog_returns"
    ON "catalog_sales"."cs_item_sk" = "catalog_returns"."cr_item_sk"
    AND "catalog_sales"."cs_order_number" = "catalog_returns"."cr_order_number"
  JOIN "date_dim_2" AS "date_dim"
    ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "catalog_page" AS "catalog_page"
    ON "catalog_sales"."cs_catalog_page_sk" = "catalog_page"."cp_catalog_page_sk"
  JOIN "item_2" AS "item"
    ON "catalog_sales"."cs_item_sk" = "item"."i_item_sk"
  JOIN "promotion_2" AS "promotion"
    ON "catalog_sales"."cs_promo_sk" = "promotion"."p_promo_sk"
  GROUP BY
    "catalog_page"."cp_catalog_page_id"
), "wsr" AS (
  SELECT
    "web_site"."web_site_id" AS "web_site_id",
    SUM("web_sales"."ws_ext_sales_price") AS "sales",
    SUM(COALESCE("web_returns"."wr_return_amt", 0)) AS "returns1",
    SUM("web_sales"."ws_net_profit" - COALESCE("web_returns"."wr_net_loss", 0)) AS "profit"
  FROM "web_sales" AS "web_sales"
  LEFT JOIN "web_returns" AS "web_returns"
    ON "web_sales"."ws_item_sk" = "web_returns"."wr_item_sk"
    AND "web_sales"."ws_order_number" = "web_returns"."wr_order_number"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "web_site" AS "web_site"
    ON "web_sales"."ws_web_site_sk" = "web_site"."web_site_sk"
  JOIN "item_2" AS "item"
    ON "web_sales"."ws_item_sk" = "item"."i_item_sk"
  JOIN "promotion_2" AS "promotion"
    ON "web_sales"."ws_promo_sk" = "promotion"."p_promo_sk"
  GROUP BY
    "web_site"."web_site_id"
), "cte_4" AS (
  SELECT
    'catalog channel' AS "channel",
    'catalog_page' || "csr"."catalog_page_id" AS "id",
    "csr"."sales" AS "sales",
    "csr"."returns1" AS "returns1",
    "csr"."profit" AS "profit"
  FROM "csr"
  UNION ALL
  SELECT
    'web channel' AS "channel",
    'web_site' || "wsr"."web_site_id" AS "id",
    "wsr"."sales" AS "sales",
    "wsr"."returns1" AS "returns1",
    "wsr"."profit" AS "profit"
  FROM "wsr"
), "x" AS (
  SELECT
    'store channel' AS "channel",
    'store' || "ssr"."store_id" AS "id",
    "ssr"."sales" AS "sales",
    "ssr"."returns1" AS "returns1",
    "ssr"."profit" AS "profit"
  FROM "ssr"
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
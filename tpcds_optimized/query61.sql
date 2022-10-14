WITH "store_2" AS (
  SELECT
    "store"."s_store_sk" AS "s_store_sk",
    "store"."s_gmt_offset" AS "s_gmt_offset"
  FROM "store" AS "store"
  WHERE
    "store"."s_gmt_offset" = -7
), "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_year" AS "d_year",
    "date_dim"."d_moy" AS "d_moy"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_moy" = 12
    AND "date_dim"."d_year" = 2001
), "customer_2" AS (
  SELECT
    "customer"."c_customer_sk" AS "c_customer_sk",
    "customer"."c_current_addr_sk" AS "c_current_addr_sk"
  FROM "customer" AS "customer"
), "customer_address_2" AS (
  SELECT
    "customer_address"."ca_address_sk" AS "ca_address_sk",
    "customer_address"."ca_gmt_offset" AS "ca_gmt_offset"
  FROM "customer_address" AS "customer_address"
  WHERE
    "customer_address"."ca_gmt_offset" = -7
), "item_2" AS (
  SELECT
    "item"."i_item_sk" AS "i_item_sk",
    "item"."i_category" AS "i_category"
  FROM "item" AS "item"
  WHERE
    "item"."i_category" = 'Books'
), "promotional_sales" AS (
  SELECT
    SUM("store_sales"."ss_ext_sales_price") AS "promotions"
  FROM "store_sales" AS "store_sales"
  JOIN "store_2" AS "store"
    ON "store_sales"."ss_store_sk" = "store"."s_store_sk"
  JOIN "promotion" AS "promotion"
    ON (
      "promotion"."p_channel_dmail" = 'Y'
      OR "promotion"."p_channel_email" = 'Y'
      OR "promotion"."p_channel_tv" = 'Y'
    )
    AND "store_sales"."ss_promo_sk" = "promotion"."p_promo_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "customer_2" AS "customer"
    ON "store_sales"."ss_customer_sk" = "customer"."c_customer_sk"
  JOIN "customer_address_2" AS "customer_address"
    ON "customer_address"."ca_address_sk" = "customer"."c_current_addr_sk"
  JOIN "item_2" AS "item"
    ON "store_sales"."ss_item_sk" = "item"."i_item_sk"
), "all_sales" AS (
  SELECT
    SUM("store_sales"."ss_ext_sales_price") AS "total"
  FROM "store_sales" AS "store_sales", "store_2" AS "store", "date_dim_2" AS "date_dim", "customer_2" AS "customer", "customer_address_2" AS "customer_address", "item_2" AS "item"
  WHERE
    "customer_address"."ca_address_sk" = "customer"."c_current_addr_sk"
    AND "store_sales"."ss_customer_sk" = "customer"."c_customer_sk"
    AND "store_sales"."ss_item_sk" = "item"."i_item_sk"
    AND "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
    AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
)
SELECT
  "promotional_sales"."promotions" AS "promotions",
  "all_sales"."total" AS "total",
  CAST("promotional_sales"."promotions" AS DECIMAL(15, 4)) / CAST("all_sales"."total" AS DECIMAL(15, 4)) * 100 AS "_col_2"
FROM "promotional_sales" AS "promotional_sales"
CROSS JOIN "all_sales" AS "all_sales"
ORDER BY
  "promotions",
  "total"
LIMIT 100
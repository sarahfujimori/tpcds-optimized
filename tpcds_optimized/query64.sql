WITH "cs_ui" AS (
  SELECT
    "catalog_sales"."cs_item_sk" AS "cs_item_sk"
  FROM "catalog_sales" AS "catalog_sales"
  JOIN "catalog_returns" AS "catalog_returns"
    ON "catalog_sales"."cs_item_sk" = "catalog_returns"."cr_item_sk"
    AND "catalog_sales"."cs_order_number" = "catalog_returns"."cr_order_number"
  GROUP BY
    "catalog_sales"."cs_item_sk"
  HAVING
    SUM("catalog_sales"."cs_ext_list_price") > 2 * SUM("catalog_returns"."cr_refunded_cash" + "catalog_returns"."cr_reversed_charge" + "catalog_returns"."cr_store_credit")
), "d1" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_year" AS "d_year"
  FROM "date_dim" AS "date_dim"
), "ib2" AS (
  SELECT
    "income_band"."ib_income_band_sk" AS "ib_income_band_sk"
  FROM "income_band" AS "income_band"
), "hd2" AS (
  SELECT
    "household_demographics"."hd_demo_sk" AS "hd_demo_sk",
    "household_demographics"."hd_income_band_sk" AS "hd_income_band_sk"
  FROM "household_demographics" AS "household_demographics"
), "cd1" AS (
  SELECT
    "customer_demographics"."cd_demo_sk" AS "cd_demo_sk",
    "customer_demographics"."cd_marital_status" AS "cd_marital_status"
  FROM "customer_demographics" AS "customer_demographics"
), "ad1" AS (
  SELECT
    "customer_address"."ca_address_sk" AS "ca_address_sk",
    "customer_address"."ca_street_number" AS "ca_street_number",
    "customer_address"."ca_street_name" AS "ca_street_name",
    "customer_address"."ca_city" AS "ca_city",
    "customer_address"."ca_zip" AS "ca_zip"
  FROM "customer_address" AS "customer_address"
), "cross_sales" AS (
  SELECT
    "item"."i_product_name" AS "product_name",
    "item"."i_item_sk" AS "item_sk",
    "store"."s_store_name" AS "store_name",
    "store"."s_zip" AS "store_zip",
    "ad1"."ca_street_number" AS "b_street_number",
    "ad1"."ca_street_name" AS "b_streen_name",
    "ad1"."ca_city" AS "b_city",
    "ad1"."ca_zip" AS "b_zip",
    "ad2"."ca_street_number" AS "c_street_number",
    "ad2"."ca_street_name" AS "c_street_name",
    "ad2"."ca_city" AS "c_city",
    "ad2"."ca_zip" AS "c_zip",
    "d1"."d_year" AS "syear",
    COUNT(*) AS "cnt",
    SUM("store_sales"."ss_wholesale_cost") AS "s1",
    SUM("store_sales"."ss_list_price") AS "s2",
    SUM("store_sales"."ss_coupon_amt") AS "s3"
  FROM "store_sales" AS "store_sales"
  JOIN "store_returns" AS "store_returns"
    ON "store_sales"."ss_item_sk" = "store_returns"."sr_item_sk"
    AND "store_sales"."ss_ticket_number" = "store_returns"."sr_ticket_number"
  JOIN "cs_ui"
    ON "store_sales"."ss_item_sk" = "cs_ui"."cs_item_sk"
  JOIN "d1" AS "d1"
    ON "store_sales"."ss_sold_date_sk" = "d1"."d_date_sk"
  CROSS JOIN "ib2" AS "ib2"
  JOIN "hd2" AS "hd2"
    ON "hd2"."hd_income_band_sk" = "ib2"."ib_income_band_sk"
  JOIN "customer" AS "customer"
    ON "customer"."c_current_hdemo_sk" = "hd2"."hd_demo_sk"
    AND "store_sales"."ss_customer_sk" = "customer"."c_customer_sk"
  JOIN "d1" AS "d2"
    ON "customer"."c_first_sales_date_sk" = "d2"."d_date_sk"
  JOIN "d1" AS "d3"
    ON "customer"."c_first_shipto_date_sk" = "d3"."d_date_sk"
  JOIN "store" AS "store"
    ON "store_sales"."ss_store_sk" = "store"."s_store_sk"
  JOIN "cd1" AS "cd1"
    ON "store_sales"."ss_cdemo_sk" = "cd1"."cd_demo_sk"
  JOIN "cd1" AS "cd2"
    ON "cd1"."cd_marital_status" <> "cd2"."cd_marital_status"
    AND "customer"."c_current_cdemo_sk" = "cd2"."cd_demo_sk"
  JOIN "promotion" AS "promotion"
    ON "store_sales"."ss_promo_sk" = "promotion"."p_promo_sk"
  JOIN "hd2" AS "hd1"
    ON "store_sales"."ss_hdemo_sk" = "hd1"."hd_demo_sk"
  JOIN "ad1" AS "ad1"
    ON "store_sales"."ss_addr_sk" = "ad1"."ca_address_sk"
  JOIN "ad1" AS "ad2"
    ON "customer"."c_current_addr_sk" = "ad2"."ca_address_sk"
  JOIN "ib2" AS "ib1"
    ON "hd1"."hd_income_band_sk" = "ib1"."ib_income_band_sk"
  JOIN "item" AS "item"
    ON "item"."i_color" IN ('cyan', 'peach', 'blush', 'frosted', 'powder', 'orange')
    AND "item"."i_current_price" BETWEEN 58 AND 68
    AND "item"."i_current_price" BETWEEN 59 AND 73
    AND "store_sales"."ss_item_sk" = "item"."i_item_sk"
  GROUP BY
    "item"."i_product_name",
    "item"."i_item_sk",
    "store"."s_store_name",
    "store"."s_zip",
    "ad1"."ca_street_number",
    "ad1"."ca_street_name",
    "ad1"."ca_city",
    "ad1"."ca_zip",
    "ad2"."ca_street_number",
    "ad2"."ca_street_name",
    "ad2"."ca_city",
    "ad2"."ca_zip",
    "d1"."d_year",
    "d2"."d_year",
    "d3"."d_year"
)
SELECT
  "cs1"."product_name" AS "product_name",
  "cs1"."store_name" AS "store_name",
  "cs1"."store_zip" AS "store_zip",
  "cs1"."b_street_number" AS "b_street_number",
  "cs1"."b_streen_name" AS "b_streen_name",
  "cs1"."b_city" AS "b_city",
  "cs1"."b_zip" AS "b_zip",
  "cs1"."c_street_number" AS "c_street_number",
  "cs1"."c_street_name" AS "c_street_name",
  "cs1"."c_city" AS "c_city",
  "cs1"."c_zip" AS "c_zip",
  "cs1"."syear" AS "syear",
  "cs1"."cnt" AS "cnt",
  "cs1"."s1" AS "s1",
  "cs1"."s2" AS "s2",
  "cs1"."s3" AS "s3",
  "cs2"."s1" AS "s1",
  "cs2"."s2" AS "s2",
  "cs2"."s3" AS "s3",
  "cs2"."syear" AS "syear",
  "cs2"."cnt" AS "cnt"
FROM "cross_sales" AS "cs1"
JOIN "cross_sales" AS "cs2"
  ON "cs1"."item_sk" = "cs2"."item_sk"
  AND "cs1"."store_name" = "cs2"."store_name"
  AND "cs1"."store_zip" = "cs2"."store_zip"
  AND "cs2"."cnt" <= "cs1"."cnt"
  AND "cs2"."syear" = 2002
WHERE
  "cs1"."syear" = 2001
ORDER BY
  "cs1"."product_name",
  "cs1"."store_name",
  "cs2"."cnt"
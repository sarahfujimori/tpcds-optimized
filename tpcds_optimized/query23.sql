WITH "frequent_ss_items" AS (
  SELECT
    "item"."i_item_sk" AS "item_sk"
  FROM "store_sales" AS "store_sales"
  JOIN "date_dim" AS "date_dim"
    ON "date_dim"."d_year" IN (1998, 1999, 2000, 2001)
    AND "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "item" AS "item"
    ON "store_sales"."ss_item_sk" = "item"."i_item_sk"
  GROUP BY
    SUBSTR("item"."i_item_desc", 1, 30),
    "item"."i_item_sk",
    "date_dim"."d_date"
  HAVING
    COUNT(*) > 4
), "customer_2" AS (
  SELECT
    "customer"."c_customer_sk" AS "c_customer_sk"
  FROM "customer" AS "customer"
), "_q_0" AS (
  SELECT
    SUM("store_sales"."ss_quantity" * "store_sales"."ss_sales_price") AS "csales"
  FROM "store_sales" AS "store_sales"
  JOIN "customer_2" AS "customer"
    ON "store_sales"."ss_customer_sk" = "customer"."c_customer_sk"
  JOIN "date_dim" AS "date_dim"
    ON "date_dim"."d_year" IN (1998, 1999, 2000, 2001)
    AND "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  GROUP BY
    "customer"."c_customer_sk"
), "max_store_sales" AS (
  SELECT
    MAX("_q_0"."csales") AS "tpcds_cmax"
  FROM "_q_0" AS "_q_0"
), "best_ss_customer" AS (
  SELECT
    "customer"."c_customer_sk" AS "c_customer_sk"
  FROM "store_sales" AS "store_sales"
  JOIN "customer_2" AS "customer"
    ON "store_sales"."ss_customer_sk" = "customer"."c_customer_sk"
  GROUP BY
    "customer"."c_customer_sk"
  HAVING
    SUM("store_sales"."ss_quantity" * "store_sales"."ss_sales_price") > 0.95 * (
      SELECT
        "max_store_sales"."tpcds_cmax" AS "tpcds_cmax"
      FROM "max_store_sales"
    )
), "_u_0" AS (
  SELECT
    "best_ss_customer"."c_customer_sk" AS "c_customer_sk"
  FROM "best_ss_customer"
  GROUP BY
    "best_ss_customer"."c_customer_sk"
), "_u_1" AS (
  SELECT
    "frequent_ss_items"."item_sk" AS "item_sk"
  FROM "frequent_ss_items"
  GROUP BY
    "frequent_ss_items"."item_sk"
), "date_dim_4" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_year" AS "d_year",
    "date_dim"."d_moy" AS "d_moy"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_moy" = 6
    AND "date_dim"."d_year" = 1998
), "_q_1" AS (
  SELECT
    "catalog_sales"."cs_quantity" * "catalog_sales"."cs_list_price" AS "sales"
  FROM "catalog_sales" AS "catalog_sales"
  LEFT JOIN "_u_0" AS "_u_0"
    ON "catalog_sales"."cs_bill_customer_sk" = "_u_0"."c_customer_sk"
  LEFT JOIN "_u_1" AS "_u_1"
    ON "catalog_sales"."cs_item_sk" = "_u_1"."item_sk"
  JOIN "date_dim_4" AS "date_dim"
    ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  WHERE
    NOT "_u_0"."c_customer_sk" IS NULL
    AND NOT "_u_1"."item_sk" IS NULL
  UNION ALL
  SELECT
    "web_sales"."ws_quantity" * "web_sales"."ws_list_price" AS "sales"
  FROM "web_sales" AS "web_sales"
  LEFT JOIN "_u_0" AS "_u_2"
    ON "web_sales"."ws_bill_customer_sk" = "_u_2"."c_customer_sk"
  LEFT JOIN "_u_1" AS "_u_3"
    ON "web_sales"."ws_item_sk" = "_u_3"."item_sk"
  JOIN "date_dim_4" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
  WHERE
    NOT "_u_2"."c_customer_sk" IS NULL
    AND NOT "_u_3"."item_sk" IS NULL
)
SELECT
  SUM("_q_1"."sales") AS "_col_0"
FROM "_q_1" AS "_q_1"
LIMIT 100
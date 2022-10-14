WITH "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_date" AS "d_date",
    "date_dim"."d_month_seq" AS "d_month_seq"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_month_seq" BETWEEN 1188 AND 1199
), "customer_2" AS (
  SELECT
    "customer"."c_customer_sk" AS "c_customer_sk",
    "customer"."c_first_name" AS "c_first_name",
    "customer"."c_last_name" AS "c_last_name"
  FROM "customer" AS "customer"
), "cte" AS (
  SELECT DISTINCT
    "customer"."c_last_name" AS "c_last_name",
    "customer"."c_first_name" AS "c_first_name",
    "date_dim"."d_date" AS "d_date"
  FROM "store_sales" AS "store_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "customer_2" AS "customer"
    ON "store_sales"."ss_customer_sk" = "customer"."c_customer_sk"
), "cte_2" AS (
  SELECT DISTINCT
    "customer"."c_last_name" AS "c_last_name",
    "customer"."c_first_name" AS "c_first_name",
    "date_dim"."d_date" AS "d_date"
  FROM "catalog_sales" AS "catalog_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "customer_2" AS "customer"
    ON "catalog_sales"."cs_bill_customer_sk" = "customer"."c_customer_sk"
), "cte_3" AS (
  SELECT DISTINCT
    "customer"."c_last_name" AS "c_last_name",
    "customer"."c_first_name" AS "c_first_name",
    "date_dim"."d_date" AS "d_date"
  FROM "web_sales" AS "web_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "customer_2" AS "customer"
    ON "web_sales"."ws_bill_customer_sk" = "customer"."c_customer_sk"
), "cte_4" AS (
  SELECT
    "cte_2"."c_last_name" AS "c_last_name",
    "cte_2"."c_first_name" AS "c_first_name",
    "cte_2"."d_date" AS "d_date"
  FROM "cte_2" AS "cte_2"
  INTERSECT
  SELECT
    "cte_3"."c_last_name" AS "c_last_name",
    "cte_3"."c_first_name" AS "c_first_name",
    "cte_3"."d_date" AS "d_date"
  FROM "cte_3" AS "cte_3"
), "hot_cust" AS (
  SELECT
    "cte"."c_last_name" AS "c_last_name",
    "cte"."c_first_name" AS "c_first_name",
    "cte"."d_date" AS "d_date"
  FROM "cte" AS "cte"
  INTERSECT
  SELECT
  FROM "cte_4" AS "cte_4"
)
SELECT
  COUNT(*) AS "_col_0"
FROM "hot_cust" AS "hot_cust"
LIMIT 100
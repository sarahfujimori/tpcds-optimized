WITH "customer_2" AS (
  SELECT
    "customer"."c_customer_sk" AS "c_customer_sk",
    "customer"."c_customer_id" AS "c_customer_id",
    "customer"."c_first_name" AS "c_first_name",
    "customer"."c_last_name" AS "c_last_name"
  FROM "customer" AS "customer"
), "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_year" AS "d_year"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_year" IN (1999, 2000)
), "cte" AS (
  SELECT
    "customer"."c_customer_id" AS "customer_id",
    "customer"."c_first_name" AS "customer_first_name",
    "customer"."c_last_name" AS "customer_last_name",
    "date_dim"."d_year" AS "year1",
    SUM("store_sales"."ss_net_paid") AS "year_total",
    's' AS "sale_type"
  FROM "customer_2" AS "customer"
  JOIN "store_sales" AS "store_sales"
    ON "customer"."c_customer_sk" = "store_sales"."ss_customer_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  GROUP BY
    "customer"."c_customer_id",
    "customer"."c_first_name",
    "customer"."c_last_name",
    "date_dim"."d_year"
), "cte_2" AS (
  SELECT
    "customer"."c_customer_id" AS "customer_id",
    "customer"."c_first_name" AS "customer_first_name",
    "customer"."c_last_name" AS "customer_last_name",
    "date_dim"."d_year" AS "year1",
    SUM("web_sales"."ws_net_paid") AS "year_total",
    'w' AS "sale_type"
  FROM "customer_2" AS "customer"
  JOIN "web_sales" AS "web_sales"
    ON "customer"."c_customer_sk" = "web_sales"."ws_bill_customer_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
  GROUP BY
    "customer"."c_customer_id",
    "customer"."c_first_name",
    "customer"."c_last_name",
    "date_dim"."d_year"
), "year_total" AS (
  SELECT
    "cte"."customer_id" AS "customer_id",
    "cte"."customer_first_name" AS "customer_first_name",
    "cte"."customer_last_name" AS "customer_last_name",
    "cte"."year1" AS "year1",
    "cte"."year_total" AS "year_total",
    "cte"."sale_type" AS "sale_type"
  FROM "cte" AS "cte"
  UNION ALL
  SELECT
    "cte_2"."customer_id" AS "customer_id",
    "cte_2"."customer_first_name" AS "customer_first_name",
    "cte_2"."customer_last_name" AS "customer_last_name",
    "cte_2"."year1" AS "year1",
    "cte_2"."year_total" AS "year_total",
    "cte_2"."sale_type" AS "sale_type"
  FROM "cte_2" AS "cte_2"
)
SELECT
  "t_s_secyear"."customer_id" AS "customer_id",
  "t_s_secyear"."customer_first_name" AS "customer_first_name",
  "t_s_secyear"."customer_last_name" AS "customer_last_name"
FROM "year_total" AS "t_s_firstyear"
JOIN "year_total" AS "t_s_secyear"
  ON "t_s_secyear"."customer_id" = "t_s_firstyear"."customer_id"
  AND "t_s_secyear"."sale_type" = 's'
  AND "t_s_secyear"."year1" = 2000
JOIN "year_total" AS "t_w_secyear"
  ON "t_s_firstyear"."customer_id" = "t_w_secyear"."customer_id"
  AND "t_w_secyear"."sale_type" = 'w'
  AND "t_w_secyear"."year1" = 2000
JOIN "year_total" AS "t_w_firstyear"
  ON "t_s_firstyear"."customer_id" = "t_w_firstyear"."customer_id"
  AND "t_w_firstyear"."sale_type" = 'w'
  AND "t_w_firstyear"."year1" = 1999
  AND "t_w_firstyear"."year_total" > 0
  AND CASE
    WHEN "t_w_firstyear"."year_total" > 0
    THEN "t_w_secyear"."year_total" / "t_w_firstyear"."year_total"
    ELSE NULL
  END > CASE
    WHEN "t_s_firstyear"."year_total" > 0
    THEN "t_s_secyear"."year_total" / "t_s_firstyear"."year_total"
    ELSE NULL
  END
WHERE
  "t_s_firstyear"."sale_type" = 's'
  AND "t_s_firstyear"."year1" = 1999
  AND "t_s_firstyear"."year_total" > 0
ORDER BY
  "t_s_secyear"."customer_id",
  "t_s_secyear"."customer_first_name",
  "t_s_secyear"."customer_last_name"
LIMIT 100
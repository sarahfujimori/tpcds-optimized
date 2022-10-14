WITH "customer_2" AS (
  SELECT
    "customer"."c_customer_sk" AS "c_customer_sk",
    "customer"."c_customer_id" AS "c_customer_id",
    "customer"."c_first_name" AS "c_first_name",
    "customer"."c_last_name" AS "c_last_name",
    "customer"."c_preferred_cust_flag" AS "c_preferred_cust_flag",
    "customer"."c_birth_country" AS "c_birth_country",
    "customer"."c_login" AS "c_login",
    "customer"."c_email_address" AS "c_email_address"
  FROM "customer" AS "customer"
), "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_year" AS "d_year"
  FROM "date_dim" AS "date_dim"
), "cte" AS (
  SELECT
    "customer"."c_customer_id" AS "customer_id",
    "customer"."c_first_name" AS "customer_first_name",
    "customer"."c_last_name" AS "customer_last_name",
    "customer"."c_birth_country" AS "customer_birth_country",
    "date_dim"."d_year" AS "dyear",
    SUM("store_sales"."ss_ext_list_price" - "store_sales"."ss_ext_discount_amt") AS "year_total",
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
    "customer"."c_preferred_cust_flag",
    "customer"."c_birth_country",
    "customer"."c_login",
    "customer"."c_email_address",
    "date_dim"."d_year"
), "cte_2" AS (
  SELECT
    "customer"."c_customer_id" AS "customer_id",
    "customer"."c_first_name" AS "customer_first_name",
    "customer"."c_last_name" AS "customer_last_name",
    "customer"."c_birth_country" AS "customer_birth_country",
    "date_dim"."d_year" AS "dyear",
    SUM("web_sales"."ws_ext_list_price" - "web_sales"."ws_ext_discount_amt") AS "year_total",
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
    "customer"."c_preferred_cust_flag",
    "customer"."c_birth_country",
    "customer"."c_login",
    "customer"."c_email_address",
    "date_dim"."d_year"
), "year_total" AS (
  SELECT
    "cte"."customer_id" AS "customer_id",
    "cte"."customer_first_name" AS "customer_first_name",
    "cte"."customer_last_name" AS "customer_last_name",
    "cte"."customer_birth_country" AS "customer_birth_country",
    "cte"."dyear" AS "dyear",
    "cte"."year_total" AS "year_total",
    "cte"."sale_type" AS "sale_type"
  FROM "cte" AS "cte"
  UNION ALL
  SELECT
    "cte_2"."customer_id" AS "customer_id",
    "cte_2"."customer_first_name" AS "customer_first_name",
    "cte_2"."customer_last_name" AS "customer_last_name",
    "cte_2"."customer_birth_country" AS "customer_birth_country",
    "cte_2"."dyear" AS "dyear",
    "cte_2"."year_total" AS "year_total",
    "cte_2"."sale_type" AS "sale_type"
  FROM "cte_2" AS "cte_2"
)
SELECT
  "t_s_secyear"."customer_id" AS "customer_id",
  "t_s_secyear"."customer_first_name" AS "customer_first_name",
  "t_s_secyear"."customer_last_name" AS "customer_last_name",
  "t_s_secyear"."customer_birth_country" AS "customer_birth_country"
FROM "year_total" AS "t_s_firstyear"
JOIN "year_total" AS "t_s_secyear"
  ON "t_s_secyear"."customer_id" = "t_s_firstyear"."customer_id"
  AND "t_s_secyear"."dyear" = 2002
  AND "t_s_secyear"."sale_type" = 's'
JOIN "year_total" AS "t_w_secyear"
  ON "t_s_firstyear"."customer_id" = "t_w_secyear"."customer_id"
  AND "t_w_secyear"."dyear" = 2002
  AND "t_w_secyear"."sale_type" = 'w'
JOIN "year_total" AS "t_w_firstyear"
  ON "t_s_firstyear"."customer_id" = "t_w_firstyear"."customer_id"
  AND "t_w_firstyear"."dyear" = 2001
  AND "t_w_firstyear"."sale_type" = 'w'
  AND "t_w_firstyear"."year_total" > 0
  AND CASE
    WHEN "t_w_firstyear"."year_total" > 0
    THEN "t_w_secyear"."year_total" / "t_w_firstyear"."year_total"
    ELSE 0.0
  END > CASE
    WHEN "t_s_firstyear"."year_total" > 0
    THEN "t_s_secyear"."year_total" / "t_s_firstyear"."year_total"
    ELSE 0.0
  END
WHERE
  "t_s_firstyear"."dyear" = 2001
  AND "t_s_firstyear"."sale_type" = 's'
  AND "t_s_firstyear"."year_total" > 0
ORDER BY
  "t_s_secyear"."customer_id",
  "t_s_secyear"."customer_first_name",
  "t_s_secyear"."customer_last_name",
  "t_s_secyear"."customer_birth_country"
LIMIT 100
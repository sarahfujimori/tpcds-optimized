WITH "warehouse_2" AS (
  SELECT
    "warehouse"."w_warehouse_sk" AS "w_warehouse_sk",
    "warehouse"."w_warehouse_name" AS "w_warehouse_name",
    "warehouse"."w_warehouse_sq_ft" AS "w_warehouse_sq_ft",
    "warehouse"."w_city" AS "w_city",
    "warehouse"."w_county" AS "w_county",
    "warehouse"."w_state" AS "w_state",
    "warehouse"."w_country" AS "w_country"
  FROM "warehouse" AS "warehouse"
), "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_year" AS "d_year",
    "date_dim"."d_moy" AS "d_moy"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_year" = 1998
), "time_dim_2" AS (
  SELECT
    "time_dim"."t_time_sk" AS "t_time_sk",
    "time_dim"."t_time" AS "t_time"
  FROM "time_dim" AS "time_dim"
  WHERE
    "time_dim"."t_time" BETWEEN 7249 AND 36049
), "ship_mode_2" AS (
  SELECT
    "ship_mode"."sm_ship_mode_sk" AS "sm_ship_mode_sk",
    "ship_mode"."sm_carrier" AS "sm_carrier"
  FROM "ship_mode" AS "ship_mode"
  WHERE
    "ship_mode"."sm_carrier" IN ('ZOUROS', 'ZHOU')
), "cte" AS (
  SELECT
    "warehouse"."w_warehouse_name" AS "w_warehouse_name",
    "warehouse"."w_warehouse_sq_ft" AS "w_warehouse_sq_ft",
    "warehouse"."w_city" AS "w_city",
    "warehouse"."w_county" AS "w_county",
    "warehouse"."w_state" AS "w_state",
    "warehouse"."w_country" AS "w_country",
    'ZOUROS' || ',' || 'ZHOU' AS "ship_carriers",
    "date_dim"."d_year" AS "year1",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 1
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "jan_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 2
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "feb_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 3
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "mar_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 4
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "apr_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 5
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "may_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 6
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "jun_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 7
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "jul_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 8
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "aug_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 9
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "sep_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 10
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "oct_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 11
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "nov_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 12
        THEN "web_sales"."ws_ext_sales_price" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "dec_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 1
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "jan_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 2
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "feb_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 3
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "mar_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 4
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "apr_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 5
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "may_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 6
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "jun_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 7
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "jul_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 8
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "aug_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 9
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "sep_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 10
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "oct_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 11
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "nov_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 12
        THEN "web_sales"."ws_net_paid_inc_ship" * "web_sales"."ws_quantity"
        ELSE 0
    END) AS "dec_net"
  FROM "web_sales" AS "web_sales"
  JOIN "warehouse_2" AS "warehouse"
    ON "web_sales"."ws_warehouse_sk" = "warehouse"."w_warehouse_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "time_dim_2" AS "time_dim"
    ON "web_sales"."ws_sold_time_sk" = "time_dim"."t_time_sk"
  JOIN "ship_mode_2" AS "ship_mode"
    ON "web_sales"."ws_ship_mode_sk" = "ship_mode"."sm_ship_mode_sk"
  GROUP BY
    "warehouse"."w_warehouse_name",
    "warehouse"."w_warehouse_sq_ft",
    "warehouse"."w_city",
    "warehouse"."w_county",
    "warehouse"."w_state",
    "warehouse"."w_country",
    "date_dim"."d_year"
), "cte_2" AS (
  SELECT
    "warehouse"."w_warehouse_name" AS "w_warehouse_name",
    "warehouse"."w_warehouse_sq_ft" AS "w_warehouse_sq_ft",
    "warehouse"."w_city" AS "w_city",
    "warehouse"."w_county" AS "w_county",
    "warehouse"."w_state" AS "w_state",
    "warehouse"."w_country" AS "w_country",
    'ZOUROS' || ',' || 'ZHOU' AS "ship_carriers",
    "date_dim"."d_year" AS "year1",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 1
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "jan_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 2
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "feb_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 3
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "mar_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 4
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "apr_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 5
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "may_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 6
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "jun_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 7
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "jul_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 8
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "aug_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 9
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "sep_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 10
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "oct_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 11
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "nov_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 12
        THEN "catalog_sales"."cs_ext_sales_price" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "dec_sales",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 1
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "jan_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 2
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "feb_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 3
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "mar_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 4
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "apr_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 5
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "may_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 6
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "jun_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 7
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "jul_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 8
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "aug_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 9
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "sep_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 10
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "oct_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 11
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "nov_net",
    SUM(CASE
        WHEN "date_dim"."d_moy" = 12
        THEN "catalog_sales"."cs_net_paid" * "catalog_sales"."cs_quantity"
        ELSE 0
    END) AS "dec_net"
  FROM "catalog_sales" AS "catalog_sales"
  JOIN "warehouse_2" AS "warehouse"
    ON "catalog_sales"."cs_warehouse_sk" = "warehouse"."w_warehouse_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  JOIN "time_dim_2" AS "time_dim"
    ON "catalog_sales"."cs_sold_time_sk" = "time_dim"."t_time_sk"
  JOIN "ship_mode_2" AS "ship_mode"
    ON "catalog_sales"."cs_ship_mode_sk" = "ship_mode"."sm_ship_mode_sk"
  GROUP BY
    "warehouse"."w_warehouse_name",
    "warehouse"."w_warehouse_sq_ft",
    "warehouse"."w_city",
    "warehouse"."w_county",
    "warehouse"."w_state",
    "warehouse"."w_country",
    "date_dim"."d_year"
), "x" AS (
  SELECT
    "cte"."w_warehouse_name" AS "w_warehouse_name",
    "cte"."w_warehouse_sq_ft" AS "w_warehouse_sq_ft",
    "cte"."w_city" AS "w_city",
    "cte"."w_county" AS "w_county",
    "cte"."w_state" AS "w_state",
    "cte"."w_country" AS "w_country",
    "cte"."ship_carriers" AS "ship_carriers",
    "cte"."year1" AS "year1",
    "cte"."jan_sales" AS "jan_sales",
    "cte"."feb_sales" AS "feb_sales",
    "cte"."mar_sales" AS "mar_sales",
    "cte"."apr_sales" AS "apr_sales",
    "cte"."may_sales" AS "may_sales",
    "cte"."jun_sales" AS "jun_sales",
    "cte"."jul_sales" AS "jul_sales",
    "cte"."aug_sales" AS "aug_sales",
    "cte"."sep_sales" AS "sep_sales",
    "cte"."oct_sales" AS "oct_sales",
    "cte"."nov_sales" AS "nov_sales",
    "cte"."dec_sales" AS "dec_sales",
    "cte"."jan_net" AS "jan_net",
    "cte"."feb_net" AS "feb_net",
    "cte"."mar_net" AS "mar_net",
    "cte"."apr_net" AS "apr_net",
    "cte"."may_net" AS "may_net",
    "cte"."jun_net" AS "jun_net",
    "cte"."jul_net" AS "jul_net",
    "cte"."aug_net" AS "aug_net",
    "cte"."sep_net" AS "sep_net",
    "cte"."oct_net" AS "oct_net",
    "cte"."nov_net" AS "nov_net",
    "cte"."dec_net" AS "dec_net"
  FROM "cte" AS "cte"
  UNION ALL
  SELECT
    "cte_2"."w_warehouse_name" AS "w_warehouse_name",
    "cte_2"."w_warehouse_sq_ft" AS "w_warehouse_sq_ft",
    "cte_2"."w_city" AS "w_city",
    "cte_2"."w_county" AS "w_county",
    "cte_2"."w_state" AS "w_state",
    "cte_2"."w_country" AS "w_country",
    "cte_2"."ship_carriers" AS "ship_carriers",
    "cte_2"."year1" AS "year1",
    "cte_2"."jan_sales" AS "jan_sales",
    "cte_2"."feb_sales" AS "feb_sales",
    "cte_2"."mar_sales" AS "mar_sales",
    "cte_2"."apr_sales" AS "apr_sales",
    "cte_2"."may_sales" AS "may_sales",
    "cte_2"."jun_sales" AS "jun_sales",
    "cte_2"."jul_sales" AS "jul_sales",
    "cte_2"."aug_sales" AS "aug_sales",
    "cte_2"."sep_sales" AS "sep_sales",
    "cte_2"."oct_sales" AS "oct_sales",
    "cte_2"."nov_sales" AS "nov_sales",
    "cte_2"."dec_sales" AS "dec_sales",
    "cte_2"."jan_net" AS "jan_net",
    "cte_2"."feb_net" AS "feb_net",
    "cte_2"."mar_net" AS "mar_net",
    "cte_2"."apr_net" AS "apr_net",
    "cte_2"."may_net" AS "may_net",
    "cte_2"."jun_net" AS "jun_net",
    "cte_2"."jul_net" AS "jul_net",
    "cte_2"."aug_net" AS "aug_net",
    "cte_2"."sep_net" AS "sep_net",
    "cte_2"."oct_net" AS "oct_net",
    "cte_2"."nov_net" AS "nov_net",
    "cte_2"."dec_net" AS "dec_net"
  FROM "cte_2" AS "cte_2"
)
SELECT
  "x"."w_warehouse_name" AS "w_warehouse_name",
  "x"."w_warehouse_sq_ft" AS "w_warehouse_sq_ft",
  "x"."w_city" AS "w_city",
  "x"."w_county" AS "w_county",
  "x"."w_state" AS "w_state",
  "x"."w_country" AS "w_country",
  "x"."ship_carriers" AS "ship_carriers",
  "x"."year1" AS "year1",
  SUM("x"."jan_sales") AS "jan_sales",
  SUM("x"."feb_sales") AS "feb_sales",
  SUM("x"."mar_sales") AS "mar_sales",
  SUM("x"."apr_sales") AS "apr_sales",
  SUM("x"."may_sales") AS "may_sales",
  SUM("x"."jun_sales") AS "jun_sales",
  SUM("x"."jul_sales") AS "jul_sales",
  SUM("x"."aug_sales") AS "aug_sales",
  SUM("x"."sep_sales") AS "sep_sales",
  SUM("x"."oct_sales") AS "oct_sales",
  SUM("x"."nov_sales") AS "nov_sales",
  SUM("x"."dec_sales") AS "dec_sales",
  SUM("x"."jan_sales" / "x"."w_warehouse_sq_ft") AS "jan_sales_per_sq_foot",
  SUM("x"."feb_sales" / "x"."w_warehouse_sq_ft") AS "feb_sales_per_sq_foot",
  SUM("x"."mar_sales" / "x"."w_warehouse_sq_ft") AS "mar_sales_per_sq_foot",
  SUM("x"."apr_sales" / "x"."w_warehouse_sq_ft") AS "apr_sales_per_sq_foot",
  SUM("x"."may_sales" / "x"."w_warehouse_sq_ft") AS "may_sales_per_sq_foot",
  SUM("x"."jun_sales" / "x"."w_warehouse_sq_ft") AS "jun_sales_per_sq_foot",
  SUM("x"."jul_sales" / "x"."w_warehouse_sq_ft") AS "jul_sales_per_sq_foot",
  SUM("x"."aug_sales" / "x"."w_warehouse_sq_ft") AS "aug_sales_per_sq_foot",
  SUM("x"."sep_sales" / "x"."w_warehouse_sq_ft") AS "sep_sales_per_sq_foot",
  SUM("x"."oct_sales" / "x"."w_warehouse_sq_ft") AS "oct_sales_per_sq_foot",
  SUM("x"."nov_sales" / "x"."w_warehouse_sq_ft") AS "nov_sales_per_sq_foot",
  SUM("x"."dec_sales" / "x"."w_warehouse_sq_ft") AS "dec_sales_per_sq_foot",
  SUM("x"."jan_net") AS "jan_net",
  SUM("x"."feb_net") AS "feb_net",
  SUM("x"."mar_net") AS "mar_net",
  SUM("x"."apr_net") AS "apr_net",
  SUM("x"."may_net") AS "may_net",
  SUM("x"."jun_net") AS "jun_net",
  SUM("x"."jul_net") AS "jul_net",
  SUM("x"."aug_net") AS "aug_net",
  SUM("x"."sep_net") AS "sep_net",
  SUM("x"."oct_net") AS "oct_net",
  SUM("x"."nov_net") AS "nov_net",
  SUM("x"."dec_net") AS "dec_net"
FROM "x" AS "x"
GROUP BY
  "x"."w_warehouse_name",
  "x"."w_warehouse_sq_ft",
  "x"."w_city",
  "x"."w_county",
  "x"."w_state",
  "x"."w_country",
  "x"."ship_carriers",
  "x"."year1"
ORDER BY
  "w_warehouse_name"
LIMIT 100
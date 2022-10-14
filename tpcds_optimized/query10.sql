WITH "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_date_id" AS "d_date_id",
    "date_dim"."d_date" AS "d_date",
    "date_dim"."d_month_seq" AS "d_month_seq",
    "date_dim"."d_week_seq" AS "d_week_seq",
    "date_dim"."d_quarter_seq" AS "d_quarter_seq",
    "date_dim"."d_year" AS "d_year",
    "date_dim"."d_dow" AS "d_dow",
    "date_dim"."d_moy" AS "d_moy",
    "date_dim"."d_dom" AS "d_dom",
    "date_dim"."d_qoy" AS "d_qoy",
    "date_dim"."d_fy_year" AS "d_fy_year",
    "date_dim"."d_fy_quarter_seq" AS "d_fy_quarter_seq",
    "date_dim"."d_fy_week_seq" AS "d_fy_week_seq",
    "date_dim"."d_day_name" AS "d_day_name",
    "date_dim"."d_quarter_name" AS "d_quarter_name",
    "date_dim"."d_holiday" AS "d_holiday",
    "date_dim"."d_weekend" AS "d_weekend",
    "date_dim"."d_following_holiday" AS "d_following_holiday",
    "date_dim"."d_first_dom" AS "d_first_dom",
    "date_dim"."d_last_dom" AS "d_last_dom",
    "date_dim"."d_same_day_ly" AS "d_same_day_ly",
    "date_dim"."d_same_day_lq" AS "d_same_day_lq",
    "date_dim"."d_current_day" AS "d_current_day",
    "date_dim"."d_current_week" AS "d_current_week",
    "date_dim"."d_current_month" AS "d_current_month",
    "date_dim"."d_current_quarter" AS "d_current_quarter",
    "date_dim"."d_current_year" AS "d_current_year"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_moy" BETWEEN 4 AND 7
    AND "date_dim"."d_year" = 2002
), "_u_0" AS (
  SELECT
    "catalog_sales"."cs_ship_customer_sk" AS "_u_1"
  FROM "catalog_sales" AS "catalog_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  GROUP BY
    "catalog_sales"."cs_ship_customer_sk"
), "_u_2" AS (
  SELECT
    "web_sales"."ws_bill_customer_sk" AS "_u_3"
  FROM "web_sales" AS "web_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
  GROUP BY
    "web_sales"."ws_bill_customer_sk"
), "_u_4" AS (
  SELECT
    "store_sales"."ss_customer_sk" AS "_u_5"
  FROM "store_sales" AS "store_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  GROUP BY
    "store_sales"."ss_customer_sk"
)
SELECT
  "customer_demographics"."cd_gender" AS "cd_gender",
  "customer_demographics"."cd_marital_status" AS "cd_marital_status",
  "customer_demographics"."cd_education_status" AS "cd_education_status",
  COUNT(*) AS "cnt1",
  "customer_demographics"."cd_purchase_estimate" AS "cd_purchase_estimate",
  COUNT(*) AS "cnt2",
  "customer_demographics"."cd_credit_rating" AS "cd_credit_rating",
  COUNT(*) AS "cnt3",
  "customer_demographics"."cd_dep_count" AS "cd_dep_count",
  COUNT(*) AS "cnt4",
  "customer_demographics"."cd_dep_employed_count" AS "cd_dep_employed_count",
  COUNT(*) AS "cnt5",
  "customer_demographics"."cd_dep_college_count" AS "cd_dep_college_count",
  COUNT(*) AS "cnt6"
FROM "customer" AS "customer"
LEFT JOIN "_u_0" AS "_u_0"
  ON "customer"."c_customer_sk" = "_u_0"."_u_1"
LEFT JOIN "_u_2" AS "_u_2"
  ON "customer"."c_customer_sk" = "_u_2"."_u_3"
LEFT JOIN "_u_4" AS "_u_4"
  ON "customer"."c_customer_sk" = "_u_4"."_u_5"
JOIN "customer_address" AS "customer_address"
  ON "customer"."c_current_addr_sk" = "customer_address"."ca_address_sk"
  AND "customer_address"."ca_county" IN ('Lycoming County', 'Sheridan County', 'Kandiyohi County', 'Pike County', 'Greene County')
JOIN "customer_demographics" AS "customer_demographics"
  ON "customer_demographics"."cd_demo_sk" = "customer"."c_current_cdemo_sk"
WHERE
  (
    NOT "_u_0"."_u_1" IS NULL
    OR NOT "_u_2"."_u_3" IS NULL
  )
  AND NOT "_u_4"."_u_5" IS NULL
GROUP BY
  "customer_demographics"."cd_gender",
  "customer_demographics"."cd_marital_status",
  "customer_demographics"."cd_education_status",
  "customer_demographics"."cd_purchase_estimate",
  "customer_demographics"."cd_credit_rating",
  "customer_demographics"."cd_dep_count",
  "customer_demographics"."cd_dep_employed_count",
  "customer_demographics"."cd_dep_college_count"
ORDER BY
  "cd_gender",
  "cd_marital_status",
  "cd_education_status",
  "cd_purchase_estimate",
  "cd_credit_rating",
  "cd_dep_count",
  "cd_dep_employed_count",
  "cd_dep_college_count"
LIMIT 100
WITH "store_sales_2" AS (
  SELECT
    "store_sales"."ss_sold_time_sk" AS "ss_sold_time_sk",
    "store_sales"."ss_hdemo_sk" AS "ss_hdemo_sk",
    "store_sales"."ss_store_sk" AS "ss_store_sk"
  FROM "store_sales" AS "store_sales"
), "household_demographics_2" AS (
  SELECT
    "household_demographics"."hd_demo_sk" AS "hd_demo_sk",
    "household_demographics"."hd_dep_count" AS "hd_dep_count",
    "household_demographics"."hd_vehicle_count" AS "hd_vehicle_count"
  FROM "household_demographics" AS "household_demographics"
  WHERE
    (
      "household_demographics"."hd_dep_count" = -1
      OR "household_demographics"."hd_dep_count" = 2
      OR "household_demographics"."hd_dep_count" = 3
    )
    AND (
      "household_demographics"."hd_dep_count" = -1
      OR "household_demographics"."hd_dep_count" = 2
      OR "household_demographics"."hd_vehicle_count" <= 5
    )
    AND (
      "household_demographics"."hd_dep_count" = -1
      OR "household_demographics"."hd_dep_count" = 3
      OR "household_demographics"."hd_vehicle_count" <= 4
    )
    AND (
      "household_demographics"."hd_dep_count" = -1
      OR "household_demographics"."hd_vehicle_count" <= 4
      OR "household_demographics"."hd_vehicle_count" <= 5
    )
    AND (
      "household_demographics"."hd_dep_count" = 2
      OR "household_demographics"."hd_dep_count" = 3
      OR "household_demographics"."hd_vehicle_count" <= 1
    )
    AND (
      "household_demographics"."hd_dep_count" = 2
      OR "household_demographics"."hd_vehicle_count" <= 1
      OR "household_demographics"."hd_vehicle_count" <= 5
    )
    AND (
      "household_demographics"."hd_dep_count" = 3
      OR "household_demographics"."hd_vehicle_count" <= 1
      OR "household_demographics"."hd_vehicle_count" <= 4
    )
    AND (
      "household_demographics"."hd_vehicle_count" <= 1
      OR "household_demographics"."hd_vehicle_count" <= 4
      OR "household_demographics"."hd_vehicle_count" <= 5
    )
), "store_2" AS (
  SELECT
    "store"."s_store_sk" AS "s_store_sk",
    "store"."s_store_name" AS "s_store_name"
  FROM "store" AS "store"
  WHERE
    "store"."s_store_name" = 'ese'
), "s1" AS (
  SELECT
    COUNT(*) AS "h8_30_to_9"
  FROM "store_sales_2" AS "store_sales"
  JOIN "household_demographics_2" AS "household_demographics"
    ON "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
  JOIN "time_dim" AS "time_dim"
    ON "store_sales"."ss_sold_time_sk" = "time_dim"."t_time_sk"
    AND "time_dim"."t_hour" = 8
    AND "time_dim"."t_minute" >= 30
  JOIN "store_2" AS "store"
    ON "store_sales"."ss_store_sk" = "store"."s_store_sk"
), "s2" AS (
  SELECT
    COUNT(*) AS "h9_to_9_30"
  FROM "store_sales_2" AS "store_sales", "household_demographics_2" AS "household_demographics", "time_dim" AS "time_dim", "store_2" AS "store"
  WHERE
    "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
    AND "store_sales"."ss_sold_time_sk" = "time_dim"."t_time_sk"
    AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
    AND "time_dim"."t_hour" = 9
    AND "time_dim"."t_minute" < 30
), "s3" AS (
  SELECT
    COUNT(*) AS "h9_30_to_10"
  FROM "store_sales_2" AS "store_sales", "household_demographics_2" AS "household_demographics", "time_dim" AS "time_dim", "store_2" AS "store"
  WHERE
    "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
    AND "store_sales"."ss_sold_time_sk" = "time_dim"."t_time_sk"
    AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
    AND "time_dim"."t_hour" = 9
    AND "time_dim"."t_minute" >= 30
), "s4" AS (
  SELECT
    COUNT(*) AS "h10_to_10_30"
  FROM "store_sales_2" AS "store_sales", "household_demographics_2" AS "household_demographics", "time_dim" AS "time_dim", "store_2" AS "store"
  WHERE
    "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
    AND "store_sales"."ss_sold_time_sk" = "time_dim"."t_time_sk"
    AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
    AND "time_dim"."t_hour" = 10
    AND "time_dim"."t_minute" < 30
), "s5" AS (
  SELECT
    COUNT(*) AS "h10_30_to_11"
  FROM "store_sales_2" AS "store_sales", "household_demographics_2" AS "household_demographics", "time_dim" AS "time_dim", "store_2" AS "store"
  WHERE
    "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
    AND "store_sales"."ss_sold_time_sk" = "time_dim"."t_time_sk"
    AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
    AND "time_dim"."t_hour" = 10
    AND "time_dim"."t_minute" >= 30
), "s6" AS (
  SELECT
    COUNT(*) AS "h11_to_11_30"
  FROM "store_sales_2" AS "store_sales", "household_demographics_2" AS "household_demographics", "time_dim" AS "time_dim", "store_2" AS "store"
  WHERE
    "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
    AND "store_sales"."ss_sold_time_sk" = "time_dim"."t_time_sk"
    AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
    AND "time_dim"."t_hour" = 11
    AND "time_dim"."t_minute" < 30
), "s7" AS (
  SELECT
    COUNT(*) AS "h11_30_to_12"
  FROM "store_sales_2" AS "store_sales", "household_demographics_2" AS "household_demographics", "time_dim" AS "time_dim", "store_2" AS "store"
  WHERE
    "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
    AND "store_sales"."ss_sold_time_sk" = "time_dim"."t_time_sk"
    AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
    AND "time_dim"."t_hour" = 11
    AND "time_dim"."t_minute" >= 30
), "s8" AS (
  SELECT
    COUNT(*) AS "h12_to_12_30"
  FROM "store_sales_2" AS "store_sales", "household_demographics_2" AS "household_demographics", "time_dim" AS "time_dim", "store_2" AS "store"
  WHERE
    "store_sales"."ss_hdemo_sk" = "household_demographics"."hd_demo_sk"
    AND "store_sales"."ss_sold_time_sk" = "time_dim"."t_time_sk"
    AND "store_sales"."ss_store_sk" = "store"."s_store_sk"
    AND "time_dim"."t_hour" = 12
    AND "time_dim"."t_minute" < 30
)
SELECT
  "s1"."h8_30_to_9" AS "h8_30_to_9",
  "s2"."h9_to_9_30" AS "h9_to_9_30",
  "s3"."h9_30_to_10" AS "h9_30_to_10",
  "s4"."h10_to_10_30" AS "h10_to_10_30",
  "s5"."h10_30_to_11" AS "h10_30_to_11",
  "s6"."h11_to_11_30" AS "h11_to_11_30",
  "s7"."h11_30_to_12" AS "h11_30_to_12",
  "s8"."h12_to_12_30" AS "h12_to_12_30"
FROM "s1" AS "s1"
CROSS JOIN "s2" AS "s2"
CROSS JOIN "s3" AS "s3"
CROSS JOIN "s4" AS "s4"
CROSS JOIN "s5" AS "s5"
CROSS JOIN "s6" AS "s6"
CROSS JOIN "s7" AS "s7"
CROSS JOIN "s8" AS "s8"
WITH "wss" AS (
  SELECT
    "date_dim"."d_week_seq" AS "d_week_seq",
    "store_sales"."ss_store_sk" AS "ss_store_sk",
    SUM(CASE
        WHEN (
            "date_dim"."d_day_name" = 'Sunday'
          )
        THEN "store_sales"."ss_sales_price"
        ELSE NULL
    END) AS "sun_sales",
    SUM(CASE
        WHEN (
            "date_dim"."d_day_name" = 'Monday'
          )
        THEN "store_sales"."ss_sales_price"
        ELSE NULL
    END) AS "mon_sales",
    SUM(CASE
        WHEN (
            "date_dim"."d_day_name" = 'Tuesday'
          )
        THEN "store_sales"."ss_sales_price"
        ELSE NULL
    END) AS "tue_sales",
    SUM(CASE
        WHEN (
            "date_dim"."d_day_name" = 'Wednesday'
          )
        THEN "store_sales"."ss_sales_price"
        ELSE NULL
    END) AS "wed_sales",
    SUM(CASE
        WHEN (
            "date_dim"."d_day_name" = 'Thursday'
          )
        THEN "store_sales"."ss_sales_price"
        ELSE NULL
    END) AS "thu_sales",
    SUM(CASE
        WHEN (
            "date_dim"."d_day_name" = 'Friday'
          )
        THEN "store_sales"."ss_sales_price"
        ELSE NULL
    END) AS "fri_sales",
    SUM(CASE
        WHEN (
            "date_dim"."d_day_name" = 'Saturday'
          )
        THEN "store_sales"."ss_sales_price"
        ELSE NULL
    END) AS "sat_sales"
  FROM "store_sales" AS "store_sales"
  JOIN "date_dim" AS "date_dim"
    ON "date_dim"."d_date_sk" = "store_sales"."ss_sold_date_sk"
  GROUP BY
    "date_dim"."d_week_seq",
    "store_sales"."ss_store_sk"
), "store_2" AS (
  SELECT
    "store"."s_store_sk" AS "s_store_sk",
    "store"."s_store_id" AS "s_store_id",
    "store"."s_store_name" AS "s_store_name"
  FROM "store" AS "store"
)
SELECT
  "store"."s_store_name" AS "s_store_name1",
  "store"."s_store_id" AS "s_store_id1",
  "wss"."d_week_seq" AS "d_week_seq1",
  "wss"."sun_sales" / "wss_2"."sun_sales" AS "_col_3",
  "wss"."mon_sales" / "wss_2"."mon_sales" AS "_col_4",
  "wss"."tue_sales" / "wss_2"."tue_sales" AS "_col_5",
  "wss"."wed_sales" / "wss_2"."wed_sales" AS "_col_6",
  "wss"."thu_sales" / "wss_2"."thu_sales" AS "_col_7",
  "wss"."fri_sales" / "wss_2"."fri_sales" AS "_col_8",
  "wss"."sat_sales" / "wss_2"."sat_sales" AS "_col_9"
FROM "wss"
JOIN "store_2" AS "store"
  ON "wss"."ss_store_sk" = "store"."s_store_sk"
JOIN "date_dim" AS "date_dim"
  ON "date_dim"."d_month_seq" BETWEEN 1196 AND 1207
  AND "date_dim"."d_week_seq" = "wss"."d_week_seq"
JOIN "wss" AS "wss_2"
  ON "date_dim"."d_month_seq" BETWEEN 1208 AND 1219
  AND "date_dim"."d_week_seq" = "wss_2"."d_week_seq"
  AND "store"."s_store_id" = "store_2"."s_store_id"
  AND "wss"."d_week_seq" = "wss_2"."d_week_seq" - 52
  AND "wss_2"."ss_store_sk" = "store_2"."s_store_sk"
CROSS JOIN "store_2" AS "store_2"
CROSS JOIN "date_dim" AS "date_dim_2"
ORDER BY
  "s_store_name1",
  "s_store_id1",
  "d_week_seq1"
LIMIT 100
SELECT
  "store"."s_store_name" AS "s_store_name",
  "store"."s_store_id" AS "s_store_id",
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
FROM "date_dim" AS "date_dim"
JOIN "store_sales" AS "store_sales"
  ON "date_dim"."d_date_sk" = "store_sales"."ss_sold_date_sk"
JOIN "store" AS "store"
  ON "store"."s_gmt_offset" = -5
  AND "store"."s_store_sk" = "store_sales"."ss_store_sk"
WHERE
  "date_dim"."d_year" = 2002
GROUP BY
  "store"."s_store_name",
  "store"."s_store_id"
ORDER BY
  "s_store_name",
  "s_store_id",
  "sun_sales",
  "mon_sales",
  "tue_sales",
  "wed_sales",
  "thu_sales",
  "fri_sales",
  "sat_sales"
LIMIT 100
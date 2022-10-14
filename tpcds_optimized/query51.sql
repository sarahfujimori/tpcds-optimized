WITH "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_date" AS "d_date",
    "date_dim"."d_month_seq" AS "d_month_seq"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_month_seq" BETWEEN 1192 AND 1203
), "web_v1" AS (
  SELECT
    "web_sales"."ws_item_sk" AS "item_sk",
    "date_dim"."d_date" AS "d_date",
    SUM(SUM("web_sales"."ws_sales_price")) OVER (PARTITION BY "web_sales"."ws_item_sk" ORDER BY "d_date" rows BETWEEN UNBOUNDED PRECEDING AND CURRENT row) AS "cume_sales"
  FROM "web_sales" AS "web_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
  WHERE
    NOT "web_sales"."ws_item_sk" IS NULL
  GROUP BY
    "web_sales"."ws_item_sk",
    "date_dim"."d_date"
), "store_v1" AS (
  SELECT
    "store_sales"."ss_item_sk" AS "item_sk",
    "date_dim"."d_date" AS "d_date",
    SUM(SUM("store_sales"."ss_sales_price")) OVER (PARTITION BY "store_sales"."ss_item_sk" ORDER BY "d_date" rows BETWEEN UNBOUNDED PRECEDING AND CURRENT row) AS "cume_sales"
  FROM "store_sales" AS "store_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  WHERE
    NOT "store_sales"."ss_item_sk" IS NULL
  GROUP BY
    "store_sales"."ss_item_sk",
    "date_dim"."d_date"
), "y" AS (
  SELECT
    CASE
      WHEN NOT "web"."item_sk" IS NULL
      THEN "web"."item_sk"
      ELSE "store"."item_sk"
    END AS "item_sk",
    CASE
      WHEN NOT "web"."d_date" IS NULL
      THEN "web"."d_date"
      ELSE "store"."d_date"
    END AS "d_date",
    "web"."cume_sales" AS "web_sales",
    "store"."cume_sales" AS "store_sales",
    MAX("web"."cume_sales") OVER (PARTITION BY CASE
      WHEN NOT "web"."item_sk" IS NULL
      THEN "web"."item_sk"
      ELSE "store"."item_sk"
    END ORDER BY "d_date" rows BETWEEN UNBOUNDED PRECEDING AND CURRENT row) AS "web_cumulative",
    MAX("store"."cume_sales") OVER (PARTITION BY CASE
      WHEN NOT "web"."item_sk" IS NULL
      THEN "web"."item_sk"
      ELSE "store"."item_sk"
    END ORDER BY "d_date" rows BETWEEN UNBOUNDED PRECEDING AND CURRENT row) AS "store_cumulative"
  FROM "web_v1" AS "web"
  FULL JOIN "store_v1" AS "store"
    ON "web"."d_date" = "store"."d_date"
    AND "web"."item_sk" = "store"."item_sk"
  WHERE
    MAX("web"."cume_sales") OVER (PARTITION BY CASE
      WHEN NOT "web"."item_sk" IS NULL
      THEN "web"."item_sk"
      ELSE "store"."item_sk"
    END ORDER BY "d_date" rows BETWEEN UNBOUNDED PRECEDING AND CURRENT row) > MAX("store"."cume_sales") OVER (PARTITION BY CASE
      WHEN NOT "web"."item_sk" IS NULL
      THEN "web"."item_sk"
      ELSE "store"."item_sk"
    END ORDER BY "d_date" rows BETWEEN UNBOUNDED PRECEDING AND CURRENT row)
)
SELECT
  "y"."item_sk" AS "item_sk",
  "y"."d_date" AS "d_date",
  "y"."web_sales" AS "web_sales",
  "y"."store_sales" AS "store_sales",
  "y"."web_cumulative" AS "web_cumulative",
  "y"."store_cumulative" AS "store_cumulative"
FROM "y" AS "y"
ORDER BY
  "y"."item_sk",
  "y"."d_date"
LIMIT 100
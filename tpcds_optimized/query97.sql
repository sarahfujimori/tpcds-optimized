WITH "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_month_seq" AS "d_month_seq"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_month_seq" BETWEEN 1196 AND 1207
), "ssci" AS (
  SELECT
    "store_sales"."ss_customer_sk" AS "customer_sk",
    "store_sales"."ss_item_sk" AS "item_sk"
  FROM "store_sales" AS "store_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  GROUP BY
    "store_sales"."ss_customer_sk",
    "store_sales"."ss_item_sk"
), "csci" AS (
  SELECT
    "catalog_sales"."cs_bill_customer_sk" AS "customer_sk",
    "catalog_sales"."cs_item_sk" AS "item_sk"
  FROM "catalog_sales" AS "catalog_sales"
  JOIN "date_dim_2" AS "date_dim"
    ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  GROUP BY
    "catalog_sales"."cs_bill_customer_sk",
    "catalog_sales"."cs_item_sk"
)
SELECT
  SUM(CASE
      WHEN "csci"."customer_sk" IS NULL
        AND NOT "ssci"."customer_sk" IS NULL
      THEN 1
      ELSE 0
  END) AS "store_only",
  SUM(CASE
      WHEN "ssci"."customer_sk" IS NULL
        AND NOT "csci"."customer_sk" IS NULL
      THEN 1
      ELSE 0
  END) AS "catalog_only",
  SUM(CASE
      WHEN NOT "csci"."customer_sk" IS NULL
        AND NOT "ssci"."customer_sk" IS NULL
      THEN 1
      ELSE 0
  END) AS "store_and_catalog"
FROM "ssci"
FULL JOIN "csci"
  ON "ssci"."customer_sk" = "csci"."customer_sk"
  AND "ssci"."item_sk" = "csci"."item_sk"
LIMIT 100
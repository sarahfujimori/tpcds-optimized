WITH "store_sales_2" AS (
  SELECT
    "store_sales"."ss_sold_date_sk" AS "ss_sold_date_sk",
    "store_sales"."ss_store_sk" AS "ss_store_sk",
    "store_sales"."ss_net_profit" AS "ss_net_profit"
  FROM "store_sales" AS "store_sales"
), "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_month_seq" AS "d_month_seq"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_month_seq" BETWEEN 1200 AND 1211
), "tmp1" AS (
  SELECT
    "store"."s_state" AS "s_state",
    RANK() OVER (PARTITION BY "store"."s_state" ORDER BY SUM("store_sales"."ss_net_profit") DESC) AS "ranking"
  FROM "store_sales_2" AS "store_sales"
  JOIN "store" AS "store"
    ON "store"."s_store_sk" = "store_sales"."ss_store_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "date_dim"."d_date_sk" = "store_sales"."ss_sold_date_sk"
  GROUP BY
    "store"."s_state"
), "_u_0" AS (
  SELECT
    "tmp1"."s_state" AS "s_state"
  FROM "tmp1" AS "tmp1"
  WHERE
    "tmp1"."ranking" <= 5
  GROUP BY
    "tmp1"."s_state"
)
SELECT
  SUM("store_sales"."ss_net_profit") AS "total_sum",
  "store"."s_state" AS "s_state",
  "store"."s_county" AS "s_county",
  GROUPING("store"."s_state") + GROUPING("store"."s_county") AS "lochierarchy",
  RANK() OVER (PARTITION BY GROUPING("store"."s_state") + GROUPING("store"."s_county"), CASE
    WHEN GROUPING("store"."s_county") = 0
    THEN "store"."s_state"
  END ORDER BY SUM("store_sales"."ss_net_profit") DESC) AS "rank_within_parent"
FROM "store_sales_2" AS "store_sales"
JOIN "store" AS "store"
  ON "store"."s_store_sk" = "store_sales"."ss_store_sk"
LEFT JOIN "_u_0" AS "_u_0"
  ON "store"."s_state" = "_u_0"."s_state"
JOIN "date_dim_2" AS "d1"
  ON "d1"."d_date_sk" = "store_sales"."ss_sold_date_sk"
WHERE
  NOT "_u_0"."s_state" IS NULL
GROUP BY
ROLLUP (
  "s_state",
  "s_county"
)
ORDER BY
  "lochierarchy" DESC,
  CASE
    WHEN "lochierarchy" = 0
    THEN "s_state"
  END,
  "rank_within_parent"
LIMIT 100
WITH "customer_total_return" AS (
  SELECT
    "store_returns"."sr_customer_sk" AS "ctr_customer_sk",
    "store_returns"."sr_store_sk" AS "ctr_store_sk",
    SUM("store_returns"."sr_return_amt") AS "ctr_total_return"
  FROM "store_returns" AS "store_returns"
  JOIN "date_dim" AS "date_dim"
    ON "date_dim"."d_year" = 2001
    AND "store_returns"."sr_returned_date_sk" = "date_dim"."d_date_sk"
  GROUP BY
    "store_returns"."sr_customer_sk",
    "store_returns"."sr_store_sk"
), "_u_0" AS (
  SELECT
    AVG("ctr2"."ctr_total_return") * 1.2 AS "_col_0",
    "ctr2"."ctr_store_sk" AS "_u_1"
  FROM "customer_total_return" AS "ctr2"
  GROUP BY
    "ctr2"."ctr_store_sk"
)
SELECT
  "customer"."c_customer_id" AS "c_customer_id"
FROM "customer_total_return" AS "ctr1"
LEFT JOIN "_u_0" AS "_u_0"
  ON "ctr1"."ctr_store_sk" = "_u_0"."_u_1"
JOIN "store" AS "store"
  ON "store"."s_state" = 'TN'
  AND "store"."s_store_sk" = "ctr1"."ctr_store_sk"
JOIN "customer" AS "customer"
  ON "ctr1"."ctr_customer_sk" = "customer"."c_customer_sk"
WHERE
  "ctr1"."ctr_total_return" > "_u_0"."_col_0"
  AND NOT "_u_0"."_u_1" IS NULL
ORDER BY
  "c_customer_id"
LIMIT 100
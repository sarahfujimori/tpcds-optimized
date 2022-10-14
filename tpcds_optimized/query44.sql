WITH "V1" AS (
  SELECT
    "ss1"."ss_item_sk" AS "item_sk",
    AVG("ss1"."ss_net_profit") AS "rank_col"
  FROM "store_sales" AS "ss1"
  WHERE
    "ss1"."ss_store_sk" = 4
  GROUP BY
    "ss1"."ss_item_sk"
  HAVING
    AVG("ss1"."ss_net_profit") > 0.9 * (
      SELECT
        AVG("store_sales"."ss_net_profit") AS "rank_col"
      FROM "store_sales" AS "store_sales"
      WHERE
        "store_sales"."ss_cdemo_sk" IS NULL
        AND "store_sales"."ss_store_sk" = 4
      GROUP BY
        "store_sales"."ss_store_sk"
    )
), "i1" AS (
  SELECT
    "item"."i_item_sk" AS "i_item_sk",
    "item"."i_product_name" AS "i_product_name"
  FROM "item" AS "item"
)
SELECT
  RANK() OVER (ORDER BY "V1"."rank_col") AS "rnk",
  "i1"."i_product_name" AS "best_performing",
  "i2"."i_product_name" AS "worst_performing"
FROM "V1" AS "V1"
JOIN "V1" AS "V2"
  ON RANK() OVER (ORDER BY "V1"."rank_col") = RANK() OVER (ORDER BY "V2"."rank_col" DESC)
  AND RANK() OVER (ORDER BY "V2"."rank_col" DESC) < 11
JOIN "i1" AS "i1"
  ON "i1"."i_item_sk" = "V1"."item_sk"
JOIN "i1" AS "i2"
  ON "i2"."i_item_sk" = "V2"."item_sk"
WHERE
  RANK() OVER (ORDER BY "V1"."rank_col") < 11
ORDER BY
  RANK() OVER (ORDER BY "V1"."rank_col")
LIMIT 100
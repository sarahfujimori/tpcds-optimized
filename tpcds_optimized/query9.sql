SELECT
  CASE
    WHEN (
        SELECT
          COUNT(*) AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 1 AND 20
      ) > 3672
    THEN (
        SELECT
          AVG("store_sales"."ss_ext_list_price") AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 1 AND 20
      )
    ELSE (
        SELECT
          AVG("store_sales"."ss_net_profit") AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 1 AND 20
      )
  END AS "bucket1",
  CASE
    WHEN (
        SELECT
          COUNT(*) AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 21 AND 40
      ) > 3392
    THEN (
        SELECT
          AVG("store_sales"."ss_ext_list_price") AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 21 AND 40
      )
    ELSE (
        SELECT
          AVG("store_sales"."ss_net_profit") AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 21 AND 40
      )
  END AS "bucket2",
  CASE
    WHEN (
        SELECT
          COUNT(*) AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 41 AND 60
      ) > 32784
    THEN (
        SELECT
          AVG("store_sales"."ss_ext_list_price") AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 41 AND 60
      )
    ELSE (
        SELECT
          AVG("store_sales"."ss_net_profit") AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 41 AND 60
      )
  END AS "bucket3",
  CASE
    WHEN (
        SELECT
          COUNT(*) AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 61 AND 80
      ) > 26032
    THEN (
        SELECT
          AVG("store_sales"."ss_ext_list_price") AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 61 AND 80
      )
    ELSE (
        SELECT
          AVG("store_sales"."ss_net_profit") AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 61 AND 80
      )
  END AS "bucket4",
  CASE
    WHEN (
        SELECT
          COUNT(*) AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 81 AND 100
      ) > 23982
    THEN (
        SELECT
          AVG("store_sales"."ss_ext_list_price") AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 81 AND 100
      )
    ELSE (
        SELECT
          AVG("store_sales"."ss_net_profit") AS "_col_0"
        FROM "store_sales" AS "store_sales"
        WHERE
          "store_sales"."ss_quantity" BETWEEN 81 AND 100
      )
  END AS "bucket5"
FROM "reason" AS "reason"
WHERE
  "reason"."r_reason_sk" = 1
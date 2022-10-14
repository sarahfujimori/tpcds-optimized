WITH "B1" AS (
  SELECT
    AVG("store_sales"."ss_list_price") AS "B1_LP",
    COUNT("store_sales"."ss_list_price") AS "B1_CNT",
    COUNT(DISTINCT "store_sales"."ss_list_price") AS "B1_CNTD"
  FROM "store_sales" AS "store_sales"
  WHERE
    (
      "store_sales"."ss_coupon_amt" BETWEEN 1939 AND 2939
      OR "store_sales"."ss_list_price" BETWEEN 18 AND 28
      OR "store_sales"."ss_wholesale_cost" BETWEEN 34 AND 54
    )
    AND "store_sales"."ss_quantity" BETWEEN 0 AND 5
), "B2" AS (
  SELECT
    AVG("store_sales"."ss_list_price") AS "B2_LP",
    COUNT("store_sales"."ss_list_price") AS "B2_CNT",
    COUNT(DISTINCT "store_sales"."ss_list_price") AS "B2_CNTD"
  FROM "store_sales" AS "store_sales"
  WHERE
    (
      "store_sales"."ss_coupon_amt" BETWEEN 35 AND 1035
      OR "store_sales"."ss_list_price" BETWEEN 1 AND 11
      OR "store_sales"."ss_wholesale_cost" BETWEEN 50 AND 70
    )
    AND "store_sales"."ss_quantity" BETWEEN 6 AND 10
), "B3" AS (
  SELECT
    AVG("store_sales"."ss_list_price") AS "B3_LP",
    COUNT("store_sales"."ss_list_price") AS "B3_CNT",
    COUNT(DISTINCT "store_sales"."ss_list_price") AS "B3_CNTD"
  FROM "store_sales" AS "store_sales"
  WHERE
    (
      "store_sales"."ss_coupon_amt" BETWEEN 1412 AND 2412
      OR "store_sales"."ss_list_price" BETWEEN 91 AND 101
      OR "store_sales"."ss_wholesale_cost" BETWEEN 17 AND 37
    )
    AND "store_sales"."ss_quantity" BETWEEN 11 AND 15
), "B4" AS (
  SELECT
    AVG("store_sales"."ss_list_price") AS "B4_LP",
    COUNT("store_sales"."ss_list_price") AS "B4_CNT",
    COUNT(DISTINCT "store_sales"."ss_list_price") AS "B4_CNTD"
  FROM "store_sales" AS "store_sales"
  WHERE
    (
      "store_sales"."ss_coupon_amt" BETWEEN 5270 AND 6270
      OR "store_sales"."ss_list_price" BETWEEN 9 AND 19
      OR "store_sales"."ss_wholesale_cost" BETWEEN 29 AND 49
    )
    AND "store_sales"."ss_quantity" BETWEEN 16 AND 20
), "B5" AS (
  SELECT
    AVG("store_sales"."ss_list_price") AS "B5_LP",
    COUNT("store_sales"."ss_list_price") AS "B5_CNT",
    COUNT(DISTINCT "store_sales"."ss_list_price") AS "B5_CNTD"
  FROM "store_sales" AS "store_sales"
  WHERE
    (
      "store_sales"."ss_coupon_amt" BETWEEN 826 AND 1826
      OR "store_sales"."ss_list_price" BETWEEN 45 AND 55
      OR "store_sales"."ss_wholesale_cost" BETWEEN 5 AND 25
    )
    AND "store_sales"."ss_quantity" BETWEEN 21 AND 25
), "B6" AS (
  SELECT
    AVG("store_sales"."ss_list_price") AS "B6_LP",
    COUNT("store_sales"."ss_list_price") AS "B6_CNT",
    COUNT(DISTINCT "store_sales"."ss_list_price") AS "B6_CNTD"
  FROM "store_sales" AS "store_sales"
  WHERE
    (
      "store_sales"."ss_coupon_amt" BETWEEN 5548 AND 6548
      OR "store_sales"."ss_list_price" BETWEEN 174 AND 184
      OR "store_sales"."ss_wholesale_cost" BETWEEN 42 AND 62
    )
    AND "store_sales"."ss_quantity" BETWEEN 26 AND 30
)
SELECT
  "B1"."B1_LP" AS "B1_LP",
  "B1"."B1_CNT" AS "B1_CNT",
  "B1"."B1_CNTD" AS "B1_CNTD",
  "B2"."B2_LP" AS "B2_LP",
  "B2"."B2_CNT" AS "B2_CNT",
  "B2"."B2_CNTD" AS "B2_CNTD",
  "B3"."B3_LP" AS "B3_LP",
  "B3"."B3_CNT" AS "B3_CNT",
  "B3"."B3_CNTD" AS "B3_CNTD",
  "B4"."B4_LP" AS "B4_LP",
  "B4"."B4_CNT" AS "B4_CNT",
  "B4"."B4_CNTD" AS "B4_CNTD",
  "B5"."B5_LP" AS "B5_LP",
  "B5"."B5_CNT" AS "B5_CNT",
  "B5"."B5_CNTD" AS "B5_CNTD",
  "B6"."B6_LP" AS "B6_LP",
  "B6"."B6_CNT" AS "B6_CNT",
  "B6"."B6_CNTD" AS "B6_CNTD"
FROM "B1" AS "B1"
CROSS JOIN "B2" AS "B2"
CROSS JOIN "B3" AS "B3"
CROSS JOIN "B4" AS "B4"
CROSS JOIN "B5" AS "B5"
CROSS JOIN "B6" AS "B6"
LIMIT 100
WITH "item_2" AS (
  SELECT
    "item"."i_item_sk" AS "i_item_sk",
    "item"."i_brand_id" AS "i_brand_id",
    "item"."i_class_id" AS "i_class_id",
    "item"."i_category_id" AS "i_category_id"
  FROM "item" AS "item"
), "d1" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_year" AS "d_year"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_year" BETWEEN 1999 AND 2001
), "cte_4" AS (
  SELECT
    "ics"."i_brand_id" AS "i_brand_id",
    "ics"."i_class_id" AS "i_class_id",
    "ics"."i_category_id" AS "i_category_id"
  FROM "catalog_sales" AS "catalog_sales"
  CROSS JOIN "item_2" AS "ics"
  CROSS JOIN "d1" AS "d2"
  WHERE
    "catalog_sales"."cs_item_sk" = "ics"."i_item_sk"
    AND "catalog_sales"."cs_sold_date_sk" = "d2"."d_date_sk"
  INTERSECT
  SELECT
    "iws"."i_brand_id" AS "i_brand_id",
    "iws"."i_class_id" AS "i_class_id",
    "iws"."i_category_id" AS "i_category_id"
  FROM "web_sales" AS "web_sales"
  CROSS JOIN "item_2" AS "iws"
  CROSS JOIN "d1" AS "d3"
  WHERE
    "web_sales"."ws_item_sk" = "iws"."i_item_sk"
    AND "web_sales"."ws_sold_date_sk" = "d3"."d_date_sk"
), "_q_0" AS (
  SELECT
    "iss"."i_brand_id" AS "brand_id",
    "iss"."i_class_id" AS "class_id",
    "iss"."i_category_id" AS "category_id"
  FROM "store_sales" AS "store_sales"
  CROSS JOIN "item_2" AS "iss"
  CROSS JOIN "d1" AS "d1"
  WHERE
    "store_sales"."ss_item_sk" = "iss"."i_item_sk"
    AND "store_sales"."ss_sold_date_sk" = "d1"."d_date_sk"
  INTERSECT
  SELECT
  FROM "cte_4" AS "cte_4"
), "cte_8" AS (
  SELECT
    "catalog_sales"."cs_quantity" AS "quantity",
    "catalog_sales"."cs_list_price" AS "list_price"
  FROM "catalog_sales" AS "catalog_sales"
  JOIN "d1" AS "date_dim"
    ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  UNION ALL
  SELECT
    "web_sales"."ws_quantity" AS "quantity",
    "web_sales"."ws_list_price" AS "list_price"
  FROM "web_sales" AS "web_sales"
  JOIN "d1" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
), "x" AS (
  SELECT
    "store_sales"."ss_quantity" AS "quantity",
    "store_sales"."ss_list_price" AS "list_price"
  FROM "store_sales" AS "store_sales"
  JOIN "d1" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  UNION ALL
  SELECT
  FROM "cte_8" AS "cte_8"
), "avg_sales" AS (
  SELECT
    AVG("x"."quantity" * "x"."list_price") AS "average_sales"
  FROM "x" AS "x"
), "cte_9" AS (
  SELECT
    "avg_sales"."average_sales" AS "average_sales"
  FROM "avg_sales"
), "_u_2" AS (
  SELECT
    "item"."i_item_sk" AS "ss_item_sk"
  FROM "item_2" AS "item"
  JOIN "_q_0" AS "_q_0"
    ON "item"."i_brand_id" = "_q_0"."brand_id"
    AND "item"."i_category_id" = "_q_0"."category_id"
    AND "item"."i_class_id" = "_q_0"."class_id"
  GROUP BY
    "item"."i_item_sk"
), "date_dim_2" AS (
  SELECT
    "date_dim"."d_date_sk" AS "d_date_sk",
    "date_dim"."d_year" AS "d_year",
    "date_dim"."d_moy" AS "d_moy"
  FROM "date_dim" AS "date_dim"
  WHERE
    "date_dim"."d_moy" = 11
    AND "date_dim"."d_year" = 2001
), "cte_10" AS (
  SELECT
    'web' AS "channel",
    "item"."i_brand_id" AS "i_brand_id",
    "item"."i_class_id" AS "i_class_id",
    "item"."i_category_id" AS "i_category_id",
    SUM("web_sales"."ws_quantity" * "web_sales"."ws_list_price") AS "sales",
    COUNT(*) AS "number_sales"
  FROM "web_sales" AS "web_sales"
  LEFT JOIN "_u_2" AS "_u_2"
    ON "web_sales"."ws_item_sk" = "_u_2"."ss_item_sk"
  JOIN "item_2" AS "item"
    ON "web_sales"."ws_item_sk" = "item"."i_item_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "web_sales"."ws_sold_date_sk" = "date_dim"."d_date_sk"
  WHERE
    NOT "_u_2"."ss_item_sk" IS NULL
  GROUP BY
    "item"."i_brand_id",
    "item"."i_class_id",
    "item"."i_category_id"
  HAVING
    SUM("web_sales"."ws_quantity" * "web_sales"."ws_list_price") > (
      SELECT
        "avg_sales"."average_sales" AS "average_sales"
      FROM "avg_sales"
    )
), "cte_11" AS (
  SELECT
    'catalog' AS "channel",
    "item"."i_brand_id" AS "i_brand_id",
    "item"."i_class_id" AS "i_class_id",
    "item"."i_category_id" AS "i_category_id",
    SUM("catalog_sales"."cs_quantity" * "catalog_sales"."cs_list_price") AS "sales",
    COUNT(*) AS "number_sales"
  FROM "catalog_sales" AS "catalog_sales"
  LEFT JOIN "_u_2" AS "_u_1"
    ON "catalog_sales"."cs_item_sk" = "_u_1"."ss_item_sk"
  JOIN "item_2" AS "item"
    ON "catalog_sales"."cs_item_sk" = "item"."i_item_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "catalog_sales"."cs_sold_date_sk" = "date_dim"."d_date_sk"
  WHERE
    NOT "_u_1"."ss_item_sk" IS NULL
  GROUP BY
    "item"."i_brand_id",
    "item"."i_class_id",
    "item"."i_category_id"
  HAVING
    SUM("catalog_sales"."cs_quantity" * "catalog_sales"."cs_list_price") > (
      SELECT
        "cte_9"."average_sales" AS "average_sales"
      FROM "cte_9" AS "cte_9"
    )
    UNION ALL
    SELECT
      "cte_10"."channel" AS "channel",
      "cte_10"."i_brand_id" AS "i_brand_id",
      "cte_10"."i_class_id" AS "i_class_id",
      "cte_10"."i_category_id" AS "i_category_id",
      "cte_10"."sales" AS "sales",
      "cte_10"."number_sales" AS "number_sales"
    FROM "cte_10" AS "cte_10"
), "y" AS (
  SELECT
    'store' AS "channel",
    "item"."i_brand_id" AS "i_brand_id",
    "item"."i_class_id" AS "i_class_id",
    "item"."i_category_id" AS "i_category_id",
    SUM("store_sales"."ss_quantity" * "store_sales"."ss_list_price") AS "sales",
    COUNT(*) AS "number_sales"
  FROM "store_sales" AS "store_sales"
  LEFT JOIN "_u_2" AS "_u_0"
    ON "store_sales"."ss_item_sk" = "_u_0"."ss_item_sk"
  JOIN "item_2" AS "item"
    ON "store_sales"."ss_item_sk" = "item"."i_item_sk"
  JOIN "date_dim_2" AS "date_dim"
    ON "store_sales"."ss_sold_date_sk" = "date_dim"."d_date_sk"
  WHERE
    NOT "_u_0"."ss_item_sk" IS NULL
  GROUP BY
    "item"."i_brand_id",
    "item"."i_class_id",
    "item"."i_category_id"
  HAVING
    SUM("store_sales"."ss_quantity" * "store_sales"."ss_list_price") > (
      SELECT
        "cte_9"."average_sales" AS "average_sales"
      FROM "cte_9" AS "cte_9"
    )
    UNION ALL
    SELECT
      "cte_11"."channel" AS "channel",
      "cte_11"."i_brand_id" AS "i_brand_id",
      "cte_11"."i_class_id" AS "i_class_id",
      "cte_11"."i_category_id" AS "i_category_id",
      "cte_11"."sales" AS "sales",
      "cte_11"."number_sales" AS "number_sales"
    FROM "cte_11" AS "cte_11"
)
SELECT
  "y"."channel" AS "channel",
  "y"."i_brand_id" AS "i_brand_id",
  "y"."i_class_id" AS "i_class_id",
  "y"."i_category_id" AS "i_category_id",
  SUM("y"."sales") AS "_col_4",
  SUM("y"."number_sales") AS "_col_5"
FROM "y" AS "y"
GROUP BY
ROLLUP (
  "channel",
  "i_brand_id",
  "i_class_id",
  "i_category_id"
)
ORDER BY
  "channel",
  "i_brand_id",
  "i_class_id",
  "i_category_id"
LIMIT 100
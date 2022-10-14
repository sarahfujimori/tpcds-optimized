SELECT DISTINCT
  "i1"."i_product_name" AS "_col_0"
FROM "item" AS "i1"
WHERE
  "i1"."i_manufact_id" BETWEEN 765 AND 805
  AND (
    SELECT
      COUNT(*) AS "item_cnt"
    FROM "item" AS "item"
    WHERE
      (
        "item"."i_manufact" = "i1"."i_manufact"
        AND (
          (
            "item"."i_category" = 'Men'
            AND (
              "item"."i_color" = 'antique'
              OR "item"."i_color" = 'chocolate'
            )
            AND (
              "item"."i_size" = 'economy'
              OR "item"."i_size" = 'petite'
            )
            AND (
              "item"."i_units" = 'Dram'
              OR "item"."i_units" = 'Gram'
            )
          )
          OR (
            "item"."i_category" = 'Men'
            AND (
              "item"."i_color" = 'drab'
              OR "item"."i_color" = 'grey'
            )
            AND (
              "item"."i_size" = 'extra large'
              OR "item"."i_size" = 'small'
            )
            AND (
              "item"."i_units" = 'Each'
              OR "item"."i_units" = 'N/A'
            )
          )
          OR (
            "item"."i_category" = 'Women'
            AND (
              "item"."i_color" = 'orchid'
              OR "item"."i_color" = 'peru'
            )
            AND (
              "item"."i_size" = 'economy'
              OR "item"."i_size" = 'petite'
            )
            AND (
              "item"."i_units" = 'Carton'
              OR "item"."i_units" = 'Cup'
            )
          )
          OR (
            "item"."i_category" = 'Women'
            AND (
              "item"."i_color" = 'papaya'
              OR "item"."i_color" = 'violet'
            )
            AND (
              "item"."i_size" = 'N/A'
              OR "item"."i_size" = 'large'
            )
            AND (
              "item"."i_units" = 'Box'
              OR "item"."i_units" = 'Ounce'
            )
          )
        )
      )
      OR (
        "item"."i_manufact" = "i1"."i_manufact"
        AND (
          (
            "item"."i_category" = 'Men'
            AND (
              "item"."i_color" = 'dark'
              OR "item"."i_color" = 'indian'
            )
            AND (
              "item"."i_size" = 'extra large'
              OR "item"."i_size" = 'small'
            )
            AND (
              "item"."i_units" = 'Lb'
              OR "item"."i_units" = 'Oz'
            )
          )
          OR (
            "item"."i_category" = 'Men'
            AND (
              "item"."i_color" = 'peach'
              OR "item"."i_color" = 'purple'
            )
            AND (
              "item"."i_size" = 'economy'
              OR "item"."i_size" = 'petite'
            )
            AND (
              "item"."i_units" = 'Bunch'
              OR "item"."i_units" = 'Tbl'
            )
          )
          OR (
            "item"."i_category" = 'Women'
            AND (
              "item"."i_color" = 'aquamarine'
              OR "item"."i_color" = 'navajo'
            )
            AND (
              "item"."i_size" = 'N/A'
              OR "item"."i_size" = 'large'
            )
            AND (
              "item"."i_units" = 'Case'
              OR "item"."i_units" = 'Unknown'
            )
          )
          OR (
            "item"."i_category" = 'Women'
            AND (
              "item"."i_color" = 'dim'
              OR "item"."i_color" = 'green'
            )
            AND (
              "item"."i_size" = 'economy'
              OR "item"."i_size" = 'petite'
            )
            AND (
              "item"."i_units" = 'Dozen'
              OR "item"."i_units" = 'Gross'
            )
          )
        )
      )
  ) > 0
ORDER BY
  "i1"."i_product_name"
LIMIT 100
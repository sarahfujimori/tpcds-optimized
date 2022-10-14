SELECT
  "store_sales"."ss_customer_sk" AS "ss_customer_sk",
  SUM(CASE
      WHEN NOT "store_returns"."sr_return_quantity" IS NULL
      THEN (
          "store_sales"."ss_quantity" - "store_returns"."sr_return_quantity"
        ) * "store_sales"."ss_sales_price"
      ELSE (
          "store_sales"."ss_quantity" * "store_sales"."ss_sales_price"
        )
  END) AS "sumsales"
FROM "store_sales" AS "store_sales"
LEFT JOIN "store_returns" AS "store_returns"
  ON "store_returns"."sr_item_sk" = "store_sales"."ss_item_sk"
  AND "store_returns"."sr_ticket_number" = "store_sales"."ss_ticket_number"
JOIN "reason" AS "reason"
  ON "reason"."r_reason_desc" = 'reason 38'
WHERE
  "store_returns"."sr_reason_sk" = "reason"."r_reason_sk"
GROUP BY
  "store_sales"."ss_customer_sk"
ORDER BY
  "sumsales",
  "ss_customer_sk"
LIMIT 100
WITH "customer_total_return" AS (
  SELECT
    "catalog_returns"."cr_returning_customer_sk" AS "ctr_customer_sk",
    "customer_address"."ca_state" AS "ctr_state",
    SUM("catalog_returns"."cr_return_amt_inc_tax") AS "ctr_total_return"
  FROM "catalog_returns" AS "catalog_returns"
  JOIN "date_dim" AS "date_dim"
    ON "catalog_returns"."cr_returned_date_sk" = "date_dim"."d_date_sk"
    AND "date_dim"."d_year" = 1999
  JOIN "customer_address" AS "customer_address"
    ON "catalog_returns"."cr_returning_addr_sk" = "customer_address"."ca_address_sk"
  GROUP BY
    "catalog_returns"."cr_returning_customer_sk",
    "customer_address"."ca_state"
), "_u_0" AS (
  SELECT
    AVG("ctr2"."ctr_total_return") * 1.2 AS "_col_0",
    "ctr2"."ctr_state" AS "_u_1"
  FROM "customer_total_return" AS "ctr2"
  GROUP BY
    "ctr2"."ctr_state"
)
SELECT
  "customer"."c_customer_id" AS "c_customer_id",
  "customer"."c_salutation" AS "c_salutation",
  "customer"."c_first_name" AS "c_first_name",
  "customer"."c_last_name" AS "c_last_name",
  "customer_address"."ca_street_number" AS "ca_street_number",
  "customer_address"."ca_street_name" AS "ca_street_name",
  "customer_address"."ca_street_type" AS "ca_street_type",
  "customer_address"."ca_suite_number" AS "ca_suite_number",
  "customer_address"."ca_city" AS "ca_city",
  "customer_address"."ca_county" AS "ca_county",
  "customer_address"."ca_state" AS "ca_state",
  "customer_address"."ca_zip" AS "ca_zip",
  "customer_address"."ca_country" AS "ca_country",
  "customer_address"."ca_gmt_offset" AS "ca_gmt_offset",
  "customer_address"."ca_location_type" AS "ca_location_type",
  "ctr1"."ctr_total_return" AS "ctr_total_return"
FROM "customer_total_return" AS "ctr1"
LEFT JOIN "_u_0" AS "_u_0"
  ON "ctr1"."ctr_state" = "_u_0"."_u_1"
JOIN "customer" AS "customer"
  ON "ctr1"."ctr_customer_sk" = "customer"."c_customer_sk"
JOIN "customer_address" AS "customer_address"
  ON "customer_address"."ca_address_sk" = "customer"."c_current_addr_sk"
  AND "customer_address"."ca_state" = 'TX'
WHERE
  "ctr1"."ctr_total_return" > "_u_0"."_col_0"
  AND NOT "_u_0"."_u_1" IS NULL
ORDER BY
  "c_customer_id",
  "c_salutation",
  "c_first_name",
  "c_last_name",
  "ca_street_number",
  "ca_street_name",
  "ca_street_type",
  "ca_suite_number",
  "ca_city",
  "ca_county",
  "ca_state",
  "ca_zip",
  "ca_country",
  "ca_gmt_offset",
  "ca_location_type",
  "ctr_total_return"
LIMIT 100
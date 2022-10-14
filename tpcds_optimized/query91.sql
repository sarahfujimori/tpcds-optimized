SELECT
  "call_center"."cc_call_center_id" AS "Call_Center",
  "call_center"."cc_name" AS "Call_Center_Name",
  "call_center"."cc_manager" AS "Manager",
  SUM("catalog_returns"."cr_net_loss") AS "Returns_Loss"
FROM "call_center" AS "call_center"
JOIN "catalog_returns" AS "catalog_returns"
  ON "catalog_returns"."cr_call_center_sk" = "call_center"."cc_call_center_sk"
JOIN "date_dim" AS "date_dim"
  ON "catalog_returns"."cr_returned_date_sk" = "date_dim"."d_date_sk"
  AND "date_dim"."d_moy" = 12
  AND "date_dim"."d_year" = 1999
JOIN "customer" AS "customer"
  ON "catalog_returns"."cr_returning_customer_sk" = "customer"."c_customer_sk"
JOIN "customer_address" AS "customer_address"
  ON "customer_address"."ca_address_sk" = "customer"."c_current_addr_sk"
  AND "customer_address"."ca_gmt_offset" = -7
JOIN "customer_demographics" AS "customer_demographics"
  ON "customer_demographics"."cd_demo_sk" = "customer"."c_current_cdemo_sk"
  AND (
    "customer_demographics"."cd_education_status" = 'Advanced Degree'
    OR "customer_demographics"."cd_education_status" = 'Unknown'
  )
  AND (
    "customer_demographics"."cd_education_status" = 'Advanced Degree'
    OR "customer_demographics"."cd_marital_status" = 'M'
  )
  AND (
    "customer_demographics"."cd_education_status" = 'Unknown'
    OR "customer_demographics"."cd_marital_status" = 'W'
  )
  AND (
    "customer_demographics"."cd_marital_status" = 'M'
    OR "customer_demographics"."cd_marital_status" = 'W'
  )
JOIN "household_demographics" AS "household_demographics"
  ON "household_demographics"."hd_buy_potential" LIKE 'Unknown%'
  AND "household_demographics"."hd_demo_sk" = "customer"."c_current_hdemo_sk"
GROUP BY
  "call_center"."cc_call_center_id",
  "call_center"."cc_name",
  "call_center"."cc_manager",
  "customer_demographics"."cd_marital_status",
  "customer_demographics"."cd_education_status"
ORDER BY
  SUM("catalog_returns"."cr_net_loss") DESC
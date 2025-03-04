CREATE OR REPLACE TABLE
  ibm.cubo
PARTITION BY
  dim_mes
CLUSTER BY
  (dim_user) AS
SELECT
  CAST(DATETIME_TRUNC(dt_timestamp,month) AS date) AS dim_mes,
  d_merchant_state AS dim_state,
  d_use_chip AS dim_txn_type,
  id_user AS dim_user,
  mcc_description AS dim_mcc,
  COUNT(*) AS mt_num_txn,
  SUM(c_amt) AS mt_amount,
  SUM(CASE
      WHEN b_fraud THEN 1
      ELSE 0
  END
    ) AS mt_num_fraud,
  SUM(CASE
      WHEN has_errors THEN 1
      ELSE 0
  END
    ) AS mt_num_errors
  # Count txn
  # sum mnt
  # count fraude
  # count rechazos
FROM
  ibm.part_txn
WHERE
  dt_timestamp>='2017-01-01'
  AND d_merchant_state IN ("AL",
    "AK",
    "AZ",
    "AR",
    "CA",
    "CO",
    "CT",
    "DE",
    "FL",
    "GA",
    "HI",
    "ID",
    "IL",
    "IN",
    "IA",
    "KS",
    "KY",
    "LA",
    "ME",
    "MD",
    "MA",
    "MI",
    "MN",
    "MS",
    "MO",
    "MT",
    "NE",
    "NV",
    "NH",
    "NJ",
    "NM",
    "NY",
    "NC",
    "ND",
    "OH",
    "OK",
    "OR",
    "PA",
    "RI",
    "SC",
    "SD",
    "TN",
    "TX",
    "UT",
    "VT",
    "VA",
    "WA",
    "WV",
    "WI",
    "WY")
GROUP BY
  ALL
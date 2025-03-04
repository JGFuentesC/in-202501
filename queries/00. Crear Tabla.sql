CREATE OR REPLACE TABLE
  ibm.part_txn
PARTITION BY
  DATETIME_TRUNC(dt_timestamp,MONTH) AS
SELECT
  id_user, 
  dt_timestamp,
  c_amt,
  d_merchant_state,
  b_fraud,
  CASE
    WHEN d_errors IS NOT NULL THEN TRUE
    ELSE FALSE
END
  AS has_errors,
  B.mcc_description,
  d_use_chip
FROM
  `bi-2025-01.ibm.txn_data` A
INNER JOIN
  `bi-2025-01.ibm.catalog_mcc` B
ON
  A.id_mcc = CAST(B.id_mcc AS int64)
  
  # ¿En qué mes se hacen más transacciones?
  # Gasto total por cliente histórico
  # Estado donde más fraudes se han hecho (relativo)
  # Tasa de rechazo por tipo de transacción
  # Monto de compras por giro
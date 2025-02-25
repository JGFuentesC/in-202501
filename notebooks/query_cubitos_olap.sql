# MOLAP

use oltp;

SELECT 
    error_desc AS d_error,
    merchant_state AS d_estado,
    txn_type AS d_tipo,
    COUNT(*) AS mt_conteo,
    SUM(c_amt) AS mt_monto
FROM
    tbl_txn
        LEFT JOIN
    tbl_error_txn ON tbl_txn.uuid = tbl_error_txn.uuid_txn
        LEFT JOIN
    tbl_error ON tbl_error_txn.uuid_error = tbl_error.uuid
        INNER JOIN
    tbl_state ON tbl_txn.uuid_state = tbl_state.uuid
        INNER JOIN
    tbl_txn_type ON tbl_txn.uuid_txn_type = tbl_txn_type.uuid
GROUP BY error_desc , merchant_state , txn_type;

# Molap 2 
with paso1 as (
select DATE_FORMAT(dt_timestamp, '%Y-%m') as d_mes,uuid_user,count(*) mt_txn
from tbl_txn 
group by 1, 2 )
select d_mes,avg(mt_txn) as mt_avg_txn from paso1
group by d_mes ;
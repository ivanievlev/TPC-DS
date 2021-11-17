TRUNCATE table tpcds.warehouse;
INSERT INTO tpcds.warehouse SELECT * FROM ext_tpcds.warehouse;
insert into tpcds.warehouse select
777 as w_warehouse_sk
,'LUKAAAAAAAAAAAAA' as w_warehouse_id
,'Luka WH' as w_warehouse_name
,w_warehouse_sq_ft
,w_street_number
,w_street_name
,w_street_type
,w_suite_number	
,w_city 	
,w_county
,w_state
,w_zip
,w_country
,w_gmt_offset
from tpcds.warehouse where w_warehouse_sk = 1;
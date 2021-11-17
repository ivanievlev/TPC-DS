TRUNCATE table tpcds.inventory;
INSERT INTO tpcds.inventory SELECT * FROM ext_tpcds.inventory;
update tpcds.inventory set inv_warehouse_sk = 777 where inv_warehouse_sk < 10;
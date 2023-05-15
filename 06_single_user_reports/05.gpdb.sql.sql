CREATE TABLE tpcds_reports.sql
(timing varchar, id int, description varchar, tuples bigint, duration time) 
DISTRIBUTED BY (id);

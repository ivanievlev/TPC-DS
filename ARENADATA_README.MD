# Arenadata version of TPC-DS
## Changes:

- Added support for Greenplum 7.x 
- Changed compression options from quicklz to zstd
- Added new paramaters

## Basic parameters

- REPO="TPC-DS"
- REPO_URL="https://github.com/ivanievlev/TPC-DS"
- REPO_BRANCH="master"
- ADMIN_USER="gpadmin"
- INSTALL_DIR="/arenadata"
- EXPLAIN_ANALYZE="false"
- RANDOM_DISTRIBUTION="false"
- MULTI_USER_COUNT="10"
- GEN_DATA_SCALE="3000"
- SINGLE_USER_ITERATIONS="1"
- RUN_COMPILE_TPCDS="true"
- RUN_GEN_DATA="false"
- RUN_INIT="false"
- RUN_DDL="false"
- RUN_LOAD="false"
- RUN_SQL="true"
- RUN_SINGLE_USER_REPORT="true"
- RUN_MULTI_USER="true"
- RUN_MULTI_USER_REPORT="true"
- RUN_SCORE="true"

## New parameters

- PARTITION_EVERY_FACTOR="1"
    
	``It is used in DDL step for tables with PARTITION BY <...> EVERY <...> to specify how much partitions will be used. 
	Specify default value = 1 for optimal number of partitions (693 in total in pg_partitions for db gpadmin), >= 180 to define maximum number of partitions (15337 in total in pg_partitions for db gpadmin) or value in between as you wish.``  
	
- EXCLUDE_HEAVY_QUERIES="true"

	``It is used to run only 51 simplified out of 99 queries to make test shorter. Specify true to exclude heavy queries.``

- EXTRA_TPCDS_SCHEMAS="0"

	``It is used to create similar schemas with *blank* objects to test great data catalog. Specify number of such extra schemas.`` 
	
- TRUNCATE_BEFORE_LOAD="true"

	``It is used to make purge faster with TRUNCATE commands instead of DELETE FROM.``
	
- SQL_ON_ERROR_STOP="true"

	``It is used to stop in case of every error. Essentially, errors shouldn't coour in stable environment. But for massive workload in unstable network you may specify "false" to skip trivial errors and make sure your test will complete.``

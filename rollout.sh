#!/bin/bash

set -e
PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/functions.sh
source_bashrc

GEN_DATA_SCALE="$1"
EXPLAIN_ANALYZE="$2"
RANDOM_DISTRIBUTION="$3"
MULTI_USER_COUNT="$4"
RUN_COMPILE_TPCDS="$5"
RUN_GEN_DATA="$6"
RUN_INIT="$7"
RUN_DDL="$8"
RUN_LOAD="$9"
RUN_SQL="${10}"
RUN_SINGLE_USER_REPORT="${11}"
RUN_MULTI_USER="${12}"
RUN_MULTI_USER_REPORT="${13}"
RUN_SCORE="${14}"
SINGLE_USER_ITERATIONS="${15}"
PARTITION_EVERY_FACTOR="${16}"
EXCLUDE_HEAVY_QUERIES="${17}"
EXTRA_TPCDS_SCHEMAS="${18}"
TRUNCATE_BEFORE_LOAD="${19}"
SQL_ON_ERROR_STOP="${20}"
net_core_rmem="${21}"
net_core_wmem="${22}"
rg6_memory_limit="${23}"
rg6_memory_shared_quota="${24}"
rg6_concurrency="${25}"
rg6_cpu_rate_limit="${26}"
rg7_cpu_hard_quota_limit="${27}"
DELETE_DAT_FILES_BEFORE_SQL="${28}"
RUN_SQL_FROM_ROLE="${29}"
REFERENCE_TABLE_TYPE="${30}"
DROP_CACHE_BEFORE_EACH_SINGLE_QUERY="${31}"
HEAP_ONLY="${32}"
ADMIN_USER="${33}"
MAKE_PREREQUISITES="${34}"
NETWORK_INTERFACE_JUMBOFRAME="${35}"
SET_ORCA_OPTIMIZER="${36}"
DBNAME="${37}"


if [[ "$GEN_DATA_SCALE" == "" || "$EXPLAIN_ANALYZE" == "" || "$RANDOM_DISTRIBUTION" == "" || "$MULTI_USER_COUNT" == "" || "$RUN_COMPILE_TPCDS" == "" || "$RUN_GEN_DATA" == "" || "$RUN_INIT" == "" || "$RUN_DDL" == "" || "$RUN_LOAD" == "" || "$RUN_SQL" == "" || "$RUN_SINGLE_USER_REPORT" == "" || "$RUN_MULTI_USER" == "" || "$RUN_MULTI_USER_REPORT" == "" || "$RUN_SCORE" == "" || "$SINGLE_USER_ITERATIONS" == "" || "$DBNAME" == "" ]]; then
	echo "Please run this script from tpcds.sh so the correct parameters are passed to it."
	exit 1
fi

QUIET=$5

create_directories()
{
	if [ ! -d $LOCAL_PWD/log ]; then
		echo "Creating log directory"
		mkdir $LOCAL_PWD/log
	fi
}

create_directories
echo "############################################################################"
echo "TPC-DS Script for Pivotal Greenplum Database."
echo "############################################################################"
echo ""
echo "############################################################################"
echo "GEN_DATA_SCALE: $GEN_DATA_SCALE"
echo "EXPLAIN_ANALYZE: $EXPLAIN_ANALYZE"
echo "RANDOM_DISTRIBUTION: $RANDOM_DISTRIBUTION"
echo "MULTI_USER_COUNT: $MULTI_USER_COUNT"
echo "RUN_COMPILE_TPCDS: $RUN_COMPILE_TPCDS"
echo "RUN_GEN_DATA: $RUN_GEN_DATA"
echo "RUN_INIT: $RUN_INIT"
echo "RUN_DDL: $RUN_DDL"
echo "RUN_LOAD: $RUN_LOAD"
echo "RUN_SQL: $RUN_SQL"
echo "SINGLE_USER_ITERATIONS: $SINGLE_USER_ITERATIONS"
echo "RUN_SINGLE_USER_REPORT: $RUN_SINGLE_USER_REPORT"
echo "RUN_MULTI_USER: $RUN_MULTI_USER"
echo "RUN_MULTI_USER_REPORT: $RUN_MULTI_USER_REPORT"
echo "PARTITION_EVERY_FACTOR: $PARTITION_EVERY_FACTOR"
echo "EXCLUDE_HEAVY_QUERIES: $EXCLUDE_HEAVY_QUERIES"
echo "EXTRA_TPCDS_SCHEMAS: $EXTRA_TPCDS_SCHEMAS"
echo "TRUNCATE_BEFORE_LOAD: $TRUNCATE_BEFORE_LOAD"
echo "SQL_ON_ERROR_STOP: $SQL_ON_ERROR_STOP"
echo "net_core_rmem: $net_core_rmem"
echo "net_core_wmem: $net_core_wmem"
echo "rg6_memory_limit: $rg6_memory_limit"
echo "rg6_memory_shared_quota: $rg6_memory_shared_quota"
echo "rg6_concurrency: $rg6_concurrency"
echo "rg6_cpu_rate_limit: $rg6_cpu_rate_limit"
echo "rg7_cpu_hard_quota_limit: $rg7_cpu_hard_quota_limit"
echo "DELETE_DAT_FILES_BEFORE_SQL: $DELETE_DAT_FILES_BEFORE_SQL"
echo "RUN_SQL_FROM_ROLE: $RUN_SQL_FROM_ROLE"
echo "REFERENCE_TABLE_TYPE: $REFERENCE_TABLE_TYPE"
echo "DROP_CACHE_BEFORE_EACH_SINGLE_QUERY: $DROP_CACHE_BEFORE_EACH_SINGLE_QUERY"
echo "HEAP_ONLY: $HEAP_ONLY"
echo "ADMIN_USER: $ADMIN_USER"
echo "DBNAME: $DBNAME"
echo "MAKE_PREREQUISITES: $MAKE_PREREQUISITES"
echo "NETWORK_INTERFACE_JUMBOFRAME: $NETWORK_INTERFACE_JUMBOFRAME"
echo "SET_ORCA_OPTIMIZER: $SET_ORCA_OPTIMIZER"

echo "############################################################################"
echo ""
if [ "$RUN_COMPILE_TPCDS" == "true" ]; then
	rm -f $PWD/log/end_compile_tpcds.log
fi
if [ "$RUN_GEN_DATA" == "true" ]; then
	rm -f $PWD/log/end_gen_data.log
fi
if [ "$RUN_INIT" == "true" ]; then
	rm -f $PWD/log/end_init.log
fi
if [ "$RUN_DDL" == "true" ]; then
	rm -f $PWD/log/end_ddl.log
fi
if [ "$RUN_LOAD" == "true" ]; then
	rm -f $PWD/log/end_load.log
fi
if [ "$RUN_SQL" == "true" ]; then
	rm -f $PWD/log/end_sql.log
fi
if [ "$RUN_SINGLE_USER_REPORT" == "true" ]; then
	rm -f $PWD/log/end_single_user_reports.log
fi
if [ "$RUN_MULTI_USER" == "true" ]; then
	rm -f $PWD/log/end_testing_*.log
fi
if [ "$RUN_MULTI_USER_REPORT" == "true" ]; then
	rm -f $PWD/log/end_multi_user_reports.log
fi
if [ "$RUN_SCORE" == "true" ]; then
	rm -f $PWD/log/end_score.log
fi


# false steps are skipped during $i/rollout.sh when $PWD/log/end*.log files are checked in init_log
# If you have trouble with skipping steps make sure that corresponding $PWD/log/end*.log exists! 

for i in $(ls -d $PWD/0*); do
	echo "$i/rollout.sh"
	$i/rollout.sh $GEN_DATA_SCALE $EXPLAIN_ANALYZE $RANDOM_DISTRIBUTION $MULTI_USER_COUNT $SINGLE_USER_ITERATIONS $PARTITION_EVERY_FACTOR $EXCLUDE_HEAVY_QUERIES $EXTRA_TPCDS_SCHEMAS $TRUNCATE_BEFORE_LOAD $SQL_ON_ERROR_STOP $net_core_rmem $net_core_wmem $rg6_memory_limit $rg6_memory_shared_quota $rg6_concurrency $rg6_cpu_rate_limit $rg7_cpu_hard_quota_limit $DELETE_DAT_FILES_BEFORE_SQL $RUN_SQL_FROM_ROLE $DROP_CACHE_BEFORE_EACH_SINGLE_QUERY $HEAP_ONLY $ADMIN_USER $MAKE_PREREQUISITES $NETWORK_INTERFACE_JUMBOFRAME $SET_ORCA_OPTIMIZER $REFERENCE_TABLE_TYPE $DBNAME
done

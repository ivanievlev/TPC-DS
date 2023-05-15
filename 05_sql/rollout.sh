#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/../functions.sh
source_bashrc

GEN_DATA_SCALE=$1
EXPLAIN_ANALYZE=$2
RANDOM_DISTRIBUTION=$3
MULTI_USER_COUNT=$4
SINGLE_USER_ITERATIONS=$5
EXCLUDE_HEAVY_QUERIES=$7

if [[ "$GEN_DATA_SCALE" == "" || "$EXPLAIN_ANALYZE" == "" || "$RANDOM_DISTRIBUTION" == "" || "$MULTI_USER_COUNT" == "" || "$SINGLE_USER_ITERATIONS" == "" ]]; then
	echo "You must provide the scale as a parameter in terms of Gigabytes, true/false to run queries with EXPLAIN ANALYZE option, true/false to use random distrbution, multi-user count, and the number of sql iterations."
	echo "Example: ./rollout.sh 100 false false 5 1"
	exit 1
fi

step=sql
init_log $step

rm -f $PWD/../log/*single.explain_analyze.log
for i in $(ls $PWD/*.tpcds.*.sql); do
	qnum=`echo $i | awk -F '.' '{print $3}'`
	if [ "$EXCLUDE_HEAVY_QUERIES" == "true" ]; then

		if [[ 
		"$qnum" == "02" ||
		"$qnum" == "04" ||
		"$qnum" == "05" ||
		"$qnum" == "09" ||
		"$qnum" == "10" ||
		"$qnum" == "11" ||
		"$qnum" == "14" ||
		"$qnum" == "16" ||
		"$qnum" == "17" ||
		"$qnum" == "18" ||
		"$qnum" == "22" ||
		"$qnum" == "23" ||
		"$qnum" == "24" ||
		"$qnum" == "25" ||
		"$qnum" == "28" ||
		"$qnum" == "29" ||
		"$qnum" == "31" ||
		"$qnum" == "35" ||
		"$qnum" == "36" ||
		"$qnum" == "38" ||
		"$qnum" == "39" ||
		"$qnum" == "44" ||
		"$qnum" == "46" ||
		"$qnum" == "47" ||
		"$qnum" == "50" ||
		"$qnum" == "51" ||
		"$qnum" == "57" ||
		"$qnum" == "59" ||
		"$qnum" == "64" ||
		"$qnum" == "65" ||
		"$qnum" == "67" ||
		"$qnum" == "70" ||
		"$qnum" == "72" ||
		"$qnum" == "74" ||
		"$qnum" == "75" ||
		"$qnum" == "76" ||
		"$qnum" == "78" ||
		"$qnum" == "79" ||
		"$qnum" == "80" ||
		"$qnum" == "82" ||
		"$qnum" == "87" ||
		"$qnum" == "88" ||
		"$qnum" == "93" ||
		"$qnum" == "94" ||
		"$qnum" == "95" ||
		"$qnum" == "96" ||
		"$qnum" == "97" ||
		"$qnum" == "99" ]]; then

			echo "Skipping $qnum due to EXCLUDE_HEAVY_QUERIES=true."
		continue
		fi
	fi
	for x in $(seq 1 $SINGLE_USER_ITERATIONS); do
		id=`echo $i | awk -F '.' '{print $1}'`
		schema_name=`echo $i | awk -F '.' '{print $2}'`
		table_name=`echo $i | awk -F '.' '{print $3}'`
		start_log
		if [ "$EXPLAIN_ANALYZE" == "false" ]; then
			echo "psql -v ON_ERROR_STOP=1 -A -q -t -P pager=off -v EXPLAIN_ANALYZE=\"\" -f $i | wc -l"
			tuples=$(psql -v ON_ERROR_STOP=1 -A -q -t -P pager=off -v EXPLAIN_ANALYZE="" -f $i | wc -l; exit ${PIPESTATUS[0]})
		else
			myfilename=$(basename $i)
			mylogfile=$PWD/../log/$myfilename.single.explain_analyze.log
			echo "psql -v ON_ERROR_STOP=1 -A -q -t -P pager=off -v EXPLAIN_ANALYZE=\"EXPLAIN ANALYZE\" -f $i > $mylogfile"
			psql -v ON_ERROR_STOP=1 -A -q -t -P pager=off -v EXPLAIN_ANALYZE="EXPLAIN ANALYZE" -f $i > $mylogfile
			tuples="0"
		fi
		log $tuples
	done
done

end_step $step

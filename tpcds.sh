#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

MYCMD="tpcds.sh"
MYVAR="tpcds_variables.sh"
##################################################################################################################################################
# Functions
##################################################################################################################################################
check_variables()
{
	new_variable="0"

	### Make sure variables file is available
	if [ ! -f "$PWD/$MYVAR" ]; then
		touch $PWD/$MYVAR
		new_variable=$(($new_variable + 1))
	fi
	local count=$(grep "REPO=" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "REPO=\"TPC-DS\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	local count=$(grep "REPO_URL=" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "REPO_URL=\"https://github.com/ivanievlev/TPC-DS\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	local count=$(grep "REPO_BRANCH=" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "REPO_BRANCH=\"master\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	local count=$(grep "ADMIN_USER=" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "ADMIN_USER=\"gpadmin\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	local count=$(grep "INSTALL_DIR=" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "INSTALL_DIR=\"/arenadata\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	local count=$(grep "EXPLAIN_ANALYZE=" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "EXPLAIN_ANALYZE=\"false\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	local count=$(grep "RANDOM_DISTRIBUTION=" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "RANDOM_DISTRIBUTION=\"false\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	local count=$(grep "MULTI_USER_COUNT" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "MULTI_USER_COUNT=\"5\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	local count=$(grep "GEN_DATA_SCALE" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "GEN_DATA_SCALE=\"3000\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	local count=$(grep "SINGLE_USER_ITERATIONS" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "SINGLE_USER_ITERATIONS=\"1\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
        local count=$(grep "PARTITION_EVERY_FACTOR" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "PARTITION_EVERY_FACTOR=\"1\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi
        local count=$(grep "EXCLUDE_HEAVY_QUERIES" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "EXCLUDE_HEAVY_QUERIES=\"false\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi
        local count=$(grep "EXTRA_TPCDS_SCHEMAS" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "EXTRA_TPCDS_SCHEMAS=\"0\"" >> $MYVAR
                new_variable=$(($new_variable + 1))

        fi
        local count=$(grep "TRUNCATE_BEFORE_LOAD" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "TRUNCATE_BEFORE_LOAD=\"true\"" >> $MYVAR
                new_variable=$(($new_variable + 1))

        fi
        local count=$(grep "SQL_ON_ERROR_STOP" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "SQL_ON_ERROR_STOP=\"true\"" >> $MYVAR
                new_variable=$(($new_variable + 1))

        fi

	#00
	local count=$(grep "RUN_COMPILE_TPCDS" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "RUN_COMPILE_TPCDS=\"false\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	#01
	local count=$(grep "RUN_GEN_DATA" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "RUN_GEN_DATA=\"false\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	#02
	local count=$(grep "RUN_INIT" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "RUN_INIT=\"true\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	#03
	local count=$(grep "RUN_DDL" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "RUN_DDL=\"true\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	#04
	local count=$(grep "RUN_LOAD" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "RUN_LOAD=\"true\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	#05
	local count=$(grep "RUN_SQL" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "RUN_SQL=\"true\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	#06
	local count=$(grep "RUN_SINGLE_USER_REPORT" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "RUN_SINGLE_USER_REPORT=\"true\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	#07
	local count=$(grep "RUN_MULTI_USER" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "RUN_MULTI_USER=\"true\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	#08
	local count=$(grep "RUN_MULTI_USER_REPORT" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "RUN_MULTI_USER_REPORT=\"true\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi
	#09
	local count=$(grep "RUN_SCORE" $MYVAR | wc -l)
	if [ "$count" -eq "0" ]; then
		echo "RUN_SCORE=\"true\"" >> $MYVAR
		new_variable=$(($new_variable + 1))
	fi

	local count=$(grep "net_core_rmem" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "net_core_rmem=\"26214400\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi

		local count=$(grep "net_core_wmem" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "net_core_wmem=\"26214400\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi

		local count=$(grep "rg6_memory_limit" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "rg6_memory_limit=\"80\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi

		local count=$(grep "rg6_memory_shared_quota" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "rg6_memory_shared_quota=\"80\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi

		local count=$(grep "rg6_concurrency" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "rg6_concurrency=\"100\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi
		
		local count=$(grep "rg6_cpu_rate_limit" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "rg6_cpu_rate_limit=\"70\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi
		
		local count=$(grep "rg7_cpu_hard_quota_limit" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "rg7_cpu_hard_quota_limit=\"100\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi

        local count=$(grep "DELETE_DAT_FILES_BEFORE_SQL" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "DELETE_DAT_FILES_BEFORE_SQL=\"false\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi

        local count=$(grep "ANALYZEDB_BEFORE_SQL" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "ANALYZEDB_BEFORE_SQL=\"false\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi

        local count=$(grep "REFERENCE_TABLE_TYPE" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "REFERENCE_TABLE_TYPE=\"aoco\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi

	local count=$(grep "DROP_CACHE_BEFORE_EACH_SINGLE_QUERY" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "DROP_CACHE_BEFORE_EACH_SINGLE_QUERY=\"false\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi

        local count=$(grep "USE_VMWARE_RECOMMENDED_SYSCTL_CONF" $MYVAR | wc -l)
        if [ "$count" -eq "0" ]; then
                echo "USE_VMWARE_RECOMMENDED_SYSCTL_CONF=\"false\"" >> $MYVAR
                new_variable=$(($new_variable + 1))
        fi
        

	if [ "$new_variable" -gt "0" ]; then
		echo "There are new variables in the tpcds_variables.sh file.  Please review to ensure the values are correct and then re-run this script."
		exit 1
	fi
	echo "############################################################################"
	echo "Sourcing $MYVAR"
	echo "############################################################################"
	echo ""
	source $MYVAR
}

check_user()
{
	### Make sure root is executing the script. ###
	echo "############################################################################"
	echo "Make sure root is executing this script."
	echo "############################################################################"
	echo ""
	local WHOAMI=`whoami`
	if [ "$WHOAMI" != "root" ]; then
		echo "Script must be executed as root!"
		exit 1
	fi
}

yum_installs()
{
	### Install and Update Demos ###
	echo "############################################################################"
	echo "Install git, gcc, and bc with yum."
	echo "############################################################################"
	echo ""
	# Install git and gcc if not found
	local YUM_INSTALLED=$(yum --help 2> /dev/null | wc -l)
	local CURL_INSTALLED=$(gcc --help 2> /dev/null | wc -l)
	local GIT_INSTALLED=$(git --help 2> /dev/null | wc -l)
	local BC_INSTALLED=$(bc --help 2> /dev/null | wc -l)

	if [ "$YUM_INSTALLED" -gt "0" ]; then
		if [ "$CURL_INSTALLED" -eq "0" ]; then
			yum -y install gcc
		fi
		if [ "$GIT_INSTALLED" -eq "0" ]; then
			yum -y install git
		fi
		if [ "$BC_INSTALLED" -eq "0" ]; then
			yum -y install bc
		fi
	else
		if [ "$CURL_INSTALLED" -eq "0" ]; then
			echo "gcc not installed and yum not found to install it."
			echo "Please install gcc and try again."
			exit 1
		fi
		if [ "$GIT_INSTALLED" -eq "0" ]; then
			echo "git not installed and yum not found to install it."
			echo "Please install git and try again."
			exit 1
		fi
		if [ "$BC_INSTALLED" -eq "0" ]; then
			echo "bc not installed and yum not found to install it."
			echo "Please install bc and try again."
			exit 1
		fi
	fi
	echo ""
}

repo_init()
{
	### Install repo ###
	echo "############################################################################"
	echo "Install the github repository."
	echo "############################################################################"
	echo ""

	internet_down="0"
	for j in $(curl google.com 2>&1 | grep "Couldn't resolve host"); do
		internet_down="1"
	done

	if [ ! -d $INSTALL_DIR ]; then
		if [ "$internet_down" -eq "1" ]; then
			echo "Unable to continue because repo hasn't been downloaded and Internet is not available."
			exit 1
		else
			echo ""
			echo "Creating install dir"
			echo "-------------------------------------------------------------------------"
			mkdir $INSTALL_DIR
			chown $ADMIN_USER $INSTALL_DIR
		fi
	fi

	if [ ! -d $INSTALL_DIR/$REPO ]; then
		if [ "$internet_down" -eq "1" ]; then
			echo "Unable to continue because repo hasn't been downloaded and Internet is not available."
			exit 1
		else
			echo ""
			echo "Creating $REPO directory"
			echo "-------------------------------------------------------------------------"
			mkdir $INSTALL_DIR/$REPO
			chown $ADMIN_USER $INSTALL_DIR/$REPO
			su -c "cd $INSTALL_DIR; GIT_SSL_NO_VERIFY=true; git clone $REPO_URL; cd $INSTALL_DIR/$REPO; git checkout $REPO_BRANCH" $ADMIN_USER
		fi
	else
		if [ "$internet_down" -eq "0" ]; then
			git config --global user.email "$ADMIN_USER@$HOSTNAME"
			git config --global user.name "$ADMIN_USER"
			su -c "cd $INSTALL_DIR/$REPO; GIT_SSL_NO_VERIFY=true; git checkout $REPO_BRANCH; git fetch --all; git reset --hard" $ADMIN_USER
		fi
	fi
}

script_check()
{
	### Make sure the repo doesn't have a newer version of this script. ###
	echo "############################################################################"
	echo "Make sure this script is up to date."
	echo "############################################################################"
	echo ""
	# Must be executed after the repo has been pulled
	local d=`diff $PWD/$MYCMD $INSTALL_DIR/$REPO/$MYCMD | wc -l`

	if [ "$d" -eq "0" ]; then
		echo "$MYCMD script is up to date so continuing to TPC-DS."
		echo ""
	else
		echo "$MYCMD script is NOT up to date."
		echo ""
		cp $INSTALL_DIR/$REPO/$MYCMD $PWD/$MYCMD
		echo "After this script completes, restart the $MYCMD with this command:"
		echo "./$MYCMD"
		exit 1
	fi

}

echo_variables()
{
	echo "############################################################################"
	echo "REPO: $REPO"
	echo "REPO_URL: $REPO_URL"
	echo "ADMIN_USER: $ADMIN_USER"
	echo "INSTALL_DIR: $INSTALL_DIR"
	echo "MULTI_USER_COUNT: $MULTI_USER_COUNT"
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
	echo "ANALYZEDB_BEFORE_SQL: $ANALYZEDB_BEFORE_SQL"
	echo "REFERENCE_TABLE_TYPE: $REFERENCE_TABLE_TYPE"
	echo "DROP_CACHE_BEFORE_EACH_SINGLE_QUERY: $DROP_CACHE_BEFORE_EACH_SINGLE_QUERY"
	echo "USE_VMWARE_RECOMMENDED_SYSCTL_CONF: $USE_VMWARE_RECOMMENDED_SYSCTL_CONF"
	echo "############################################################################"
	echo ""
}

##################################################################################################################################################
# Body
##################################################################################################################################################

check_user
check_variables
yum_installs
#repo_init
script_check
echo_variables

su -l $ADMIN_USER -c "cd \"$INSTALL_DIR/$REPO\"; ./rollout.sh $GEN_DATA_SCALE $EXPLAIN_ANALYZE $RANDOM_DISTRIBUTION $MULTI_USER_COUNT $RUN_COMPILE_TPCDS $RUN_GEN_DATA $RUN_INIT $RUN_DDL $RUN_LOAD $RUN_SQL $RUN_SINGLE_USER_REPORT $RUN_MULTI_USER $RUN_MULTI_USER_REPORT $RUN_SCORE $SINGLE_USER_ITERATIONS $PARTITION_EVERY_FACTOR $EXCLUDE_HEAVY_QUERIES $EXTRA_TPCDS_SCHEMAS $TRUNCATE_BEFORE_LOAD $SQL_ON_ERROR_STOP $net_core_rmem $net_core_wmem $rg6_memory_limit $rg6_memory_shared_quota $rg6_concurrency $rg6_cpu_rate_limit $rg7_cpu_hard_quota_limit $DELETE_DAT_FILES_BEFORE_SQL $ANALYZEDB_BEFORE_SQL $REFERENCE_TABLE_TYPE $DROP_CACHE_BEFORE_EACH_SINGLE_QUERY $USE_VMWARE_RECOMMENDED_SYSCTL_CONF"

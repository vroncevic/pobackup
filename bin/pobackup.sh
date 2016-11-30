#!/bin/bash
#
# @brief   Backup mechanism for Postgres databases
# @version ver.1.0
# @date    Mon Apr 25 14:55:20 CEST 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=$UTIL_ROOT/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/sendmail.sh
. $UTIL/bin/loadconf.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/progressbar.sh

POBACKUP_TOOL=pobackup
POBACKUP_VERSION=ver.1.0
POBACKUP_HOME=$UTIL_ROOT/$POBACKUP_TOOL/$POBACKUP_VERSION
POBACKUP_CFG=$POBACKUP_HOME/conf/$POBACKUP_TOOL.cfg
POBACKUP_UTIL_CFG=$POBACKUP_HOME/conf/${POBACKUP_TOOL}_util.cfg
POBACKUP_LOG=$POBACKUP_HOME/log

declare -A POBACKUP_USAGE=(
	[USAGE_TOOL]="$POBACKUP_TOOL"
	[USAGE_ARG2]="[OPTION] help (optional)"
	[USAGE_EX_PRE]="# Postgres backup mechanism"
	[USAGE_EX]="$POBACKUP_TOOL restart"	
)

declare -A POBACKUP_LOG=(
	[LOG_TOOL]="$POBACKUP_TOOL"
	[LOG_FLAG]="info"
	[LOG_PATH]="$POBACKUP_LOG"
	[LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
	[BAR_WIDTH]=50
	[MAX_PERCENT]=100
	[SLEEP]=0.01
)

TOOL_DEBUG="false"

#
# @brief   Main entry point
# @param   Value optional help
# @retval  Function __pobackup exit with integer value
#			0   - tool finished with success operation 
#			128 - failed to load tool script configuration from file 
#			129 - failed to load tool script utilities configuration from file
#			130 - missing external tool pgdump
#
function __pobackup() {
	local HELP=$1
	if [ "$HELP" == "help" ]; then
		__usage POBACKUP_USAGE
	fi
	local FUNC=${FUNCNAME[0]}
	local MSG="Loading basic and util configuration"
	printf "$SEND" "$POBACKUP_TOOL" "$MSG"
	__progressbar PB_STRUCTURE
	printf "%s\n\n" ""
	declare -A configpobackup=()
	__loadconf $POBACKUP_CFG configpobackup
	local STATUS=$?
	if [ $STATUS -eq $NOT_SUCCESS ]; then
		MSG="Failed to load configuration [$POBACKUP_CFG]"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DSTA" "$POBACKUP_TOOL" "$FUNC" "$MSG"
		else
			printf "$SEND" "$POBACKUP_TOOL" "$MSG"
		fi
		exit 128
	fi
	declare -A configpobackuputil=()
	__loadutilconf "$POBACKUP_UTIL_CFG" configpobackuputil
	STATUS=$?
	if [ $STATUS -eq $NOT_SUCCESS ]; then
		MSG="Failed to load utilities configuration [$POBACKUP_UTIL_CFG]"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DSTA" "$POBACKUP_TOOL" "$FUNC" "$MSG"
		else
			printf "$SEND" "$POBACKUP_TOOL" "$MSG"
		fi
		exit 129
	fi
    __checktool "$configpobackuputil{PGDUMP}"
    STATUS=$?
    if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
		MSG="Missing external tool $configpobackuputil{PGDUMP}"
		if [ "${configpobackup[LOGGING]}" == "true" ]; then
			POBACKUP_LOG[LOG_MSGE]=$MSG
			POBACKUP_LOG[LOG_FLAG]="error"
			__logging POBACKUP_LOG
		fi
		MSG="Missing external tool ${configpobackuputil[PGDUMP]}"
		if [ "${configpobackup[EMAILING]}" == "true" ]; then
			__sendmail "$MSG" "${configpobackup[ADMIN_EMAIL]}"
		fi
        exit 130
    fi
    local FILE=$configpobackuputil{COMPANY}.postgres.`date +"%Y%m%d"`
    local DATABASE=$configpobackuputil{DATABASE}
    local -a databases=( po_test )
    for i in "${databases[@]}"
    do
        DATABASE=$i
		local CHECK_DB="psql -tAc \"$configpobackuputil{PG_CMD}='$DATABASE'\" > $DATABASE.rpt; exit 0"
		su - postgres -c "$CHECK_DB"
        local RESULT=$(cat "$PGSQL/$DATABASE.rpt")
        if [ "$RESULT" == "1" ]; then
			local SQL="$configpobackuputil{PGDUMP} $configpobackuputil{UNAME} $DATABASE > ${FILE}_${DATABASE}; exit 0"
			su - postgres -c "$SQL"
			mv "$configpobackuputil{PGSQL}/${FILE}_${DATABASE}" "$configpobackuputil{PGDUMP_ROOT_LOCATION}/"
			rm "$configpobackuputil{PGSQL}/$DATABASE.rpt"
			local PG_BACKUP="$configpobackuputil{PGDUMP_ROOT_LOCATION}/${FILE}_${DATABASE}"
            if [ -e "$PG_BACKUP" ]; then
				gzip "$PG_BACKUP"
				MSG="Backup [$PG_BACKUP.gz] was created"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$POBACKUP_TOOL" "$FUNC" "$MSG"
				else
					printf "$SEND" "$POBACKUP_TOOL" "$MSG"
				fi
                ls -l "${PG_BACKUP}.gz"
				MSG="Backup [$PG_BACKUP.gz] was created"
				if [ "${configpobackup[LOGGING]}" == "true" ]; then
					POBACKUP_LOG[LOG_MSGE]=$MSG
					POBACKUP_LOG[LOG_FLAG]="info"
					__logging POBACKUP_LOG
				fi
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$POBACKUP_TOOL" "$FUNC" "$MSG"
				else
					printf "$SEND" "$POBACKUP_TOOL" "$MSG"
				fi
            fi
			MSG="Check file [$PG_BACKUP]"
			if [ "${configpobackup[LOGGING]}" == "true" ]; then
				POBACKUP_LOG[LOG_MSGE]=$MSG
				POBACKUP_LOG[LOG_FLAG]="error"
				__logging POBACKUP_LOG
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$POBACKUP_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$POBACKUP_TOOL" "$MSG"
			fi
        else
			MSG="Database [$DATABASE] does not exist"
			if [ "${configpobackup[LOGGING]}" == "true" ]; then
				POBACKUP_LOG[LOG_MSGE]=$MSG
				POBACKUP_LOG[LOG_FLAG]="error"
				__logging POBACKUP_LOG
			fi
			if [ "${configpobackup[EMAILING]}" == "true" ]; then
				__sendmail "$MSG" "${configpobackup[ADMIN_EMAIL]}"
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$POBACKUP_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$POBACKUP_TOOL" "$MSG"
			fi
        fi
    done
	MSG="Done"
	if [ "${configpobackup[LOGGING]}" == "true" ]; then
		POBACKUP_LOG[LOG_MSGE]=$MSG
		POBACKUP_LOG[LOG_FLAG]="info"
		__logging POBACKUP_LOG
	fi
	if [ "$TOOL_DBG" == "true" ]; then
		printf "$DSTA" "$POBACKUP_TOOL" "$FUNC" "$MSG"
	else
		printf "$SEND" "$POBACKUP_TOOL" "$MSG"
	fi
	exit 0
}

#
# @brief   Main entry point
# @param   Value optional help
# @exitval Script tool pobackup exit with integer value
#			0   - tool finished with success operation 
# 			127 - run tool script as root user from cli
#			128 - failed to load tool script configuration from file 
#			129 - failed to load tool script utilities configuration from file
#			130 - missing external tool pgdump
#
printf "\n%s\n%s\n\n" "$POBACKUP_TOOL $POBACKUP_VERSION" "`date`"
__checkroot
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
	__pobackup $1
fi

exit 127


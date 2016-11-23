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

. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/checkcfg.sh
. $UTIL/bin/loadconf.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/sendmail.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

POBACKUP_TOOL=pobackup
POBACKUP_VERSION=ver.1.0
POBACKUP_HOME=$UTIL_ROOT/$POBACKUP_TOOL/$POBACKUP_VERSION
POBACKUP_CFG=$POBACKUP_HOME/conf/$POBACKUP_TOOL.cfg
POBACKUP_UTIL_CFG=$POBACKUP_HOME/conf/${POBACKUP_TOOL}_util.cfg
POBACKUP_LOG=$POBACKUP_HOME/log

declare -A POBACKUP_USAGE=(
	[TOOL_NAME]="__$POBACKUP_TOOL"
	[ARG2]="[OPTION] help (optional)"
	[EX-PRE]="# Postgres backup mechanism"
	[EX]="__$POBACKUP_TOOL restart"	
)

declare -A LOG=(
	[TOOL]="$POBACKUP_TOOL"
	[FLAG]="info"
	[PATH]="$POBACKUP_LOG"
	[MSG]=""
)

TOOL_DEBUG="false"

#
# @brief   Main entry point
# @param   Value optional help
# @exitval Script tool pobackup exit with integer value
#			0   - tool finished with success operation 
# 			127 - run tool script as root user from cli
#			128 - missing external tool pg_dump
#			129 - missing argument(s) from cli 
#			130 - wrong argument (operation)
#
printf "\n%s\n%s\n\n" "$POBACKUP_TOOL $POBACKUP_VERSION" "`date`"
HELP=$1
__checkroot
STATUS=$?
if [ "$STATUS" -eq "$SUCCESS" ]; then
	declare -A configossl=()
	__loadconf $POBACKUP_CFG cfgpobackup
	STATUS=$?
	if [ $STATUS -eq $NOT_SUCCESS ]; then
		MSG="Failed to load configuration [$POBACKUP_CFG]"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DSTA" "$POBACKUP_TOOL" "$FUNC" "$MSG"
		else
			printf "$SEND" "[$POBACKUP_TOOL]" "$MSG"
		fi
		exit 128
	fi
	declare -A cfgutilpobackup=()
	__loadutilconf "$POBACKUP_UTIL_CFG" cfgutilpobackup
	STATUS=$?
	if [ $STATUS -eq $NOT_SUCCESS ]; then
		MSG="Failed to load utilities configuration [$POBACKUP_UTIL_CFG]"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DSTA" "$POBACKUP_TOOL" "$FUNC" "$MSG"
		else
			printf "$SEND" "[$POBACKUP_TOOL]" "$MSG"
		fi
		exit 129
	fi
    if [ "$HELP" == "help" ]; then
        __usage $POBACKUP_USAGE
		exit 0
    else
        __checktool "$cfgutilpobackup{PGDUMP}"
        STATUS=$?
        if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
			MSG="Missing external tool $cfgutilpobackup{PGDUMP}"
			if [ "${cfgpobackup[LOGGING]}" == "true" ]; then
				LOG[MSG]=$MSG
				LOG[FLAG]="error"
				__logging $LOG
			fi
			MSG="Missing external tool ${cfgosslutil[OSSL]}"
			if [ "${cfgpobackup[EMAILING]}" == "true" ]; then
				__sendmail "$MSG" "${configossl[ADMIN_EMAIL]}"
			fi
            exit 130
        fi
        FILE=$cfgutilpobackup{COMPANY}.postgres.`date +"%Y%m%d"`
        DATABASE=$cfgutilpobackup{DATABASE}
        databases=( po_test )
        for i in "${databases[@]}"
        do
            DATABASE=$i
			CHECK_DB="psql -tAc \"$cfgutilpobackup{PG_CMD}='$DATABASE'\" > $DATABASE.rpt; exit 0"
			su - postgres -c "$CHECK_DB"
            RESULT=$(cat "$PGSQL/$DATABASE.rpt")
            if [ "$RESULT" == "1" ]; then
				SQL="$cfgutilpobackup{PGDUMP} $cfgutilpobackup{UNAME} $DATABASE > ${FILE}_${DATABASE}; exit 0"
				su - postgres -c "$SQL"
				mv "$cfgutilpobackup{PGSQL}/${FILE}_${DATABASE}" "$cfgutilpobackup{PGDUMP_ROOT_LOCATION}/"
				rm "$cfgutilpobackup{PGSQL}/$DATABASE.rpt"
				PG_BACKUP="$cfgutilpobackup{PGDUMP_ROOT_LOCATION}/${FILE}_${DATABASE}"
                if [ -e "$PG_BACKUP" ]; then
					gzip "$PG_BACKUP"
					if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%s\n" "Backup [$PG_BACKUP.gz] was created"
					fi
                    ls -l "${PG_BACKUP}.gz"
					MSG="Backup [$PG_BACKUP.gz] was created"
					if [ "${cfgpobackup[LOGGING]}" == "true" ]; then
						LOG[MSG]=$MSG
						LOG[FLAG]="info"
						__logging $LOG
					fi
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "%s\n" "$MSG"
					fi
                fi
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n\n" "Check file [$PG_BACKUP]"
				fi
            else
				MSG="Database [$DATABASE] does not exist"
				if [ "${cfgpobackup[LOGGING]}" == "true" ]; then
					LOG[MSG]=$MSG
					LOG[FLAG]="error"
					__logging $LOG
				fi
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "[Error] $MSG"
				fi
            fi
        done
		MSG="Done"
		if [ "${cfgpobackup[LOGGING]}" == "true" ]; then
			LOG[MSG]=$MSG
			LOG[FLAG]="info"
			__logging $LOG
		fi
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[$MSG]"
		fi
		exit 0
    fi
fi

exit 127


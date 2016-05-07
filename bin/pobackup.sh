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
. $UTIL/bin/logging.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

TOOL_NAME=pobackup
TOOL_VERSION=ver.1.0
TOOL_HOME=$UTIL_ROOT/$TOOL_NAME/$TOOL_VERSION
TOOL_CFG=$TOOL_HOME/conf/$TOOL_NAME.cfg
TOOL_LOG=$TOOL_HOME/log

declare -A POBACKUP_USAGE=(
	[TOOL_NAME]="__$TOOL_NAME"
	[ARG2]="[OPTION] help (optional)"
	[EX-PRE]="# Postgres backup mechanism"
	[EX]="__$TOOL_NAME restart"	
)

declare -A LOG=(
	[TOOL]="$TOOL_NAME"
	[FLAG]="info"
	[PATH]="$TOOL_LOG"
	[MSG]=""
)

TOOL_DEBUG="false"

PGDUMP="/usr/bin/pg_dump"
PGDUMP_ROOT_LOCATION="/PATH_TO_BACKUP_FOLDER/postgres"
PGSQL="/var/lib/pgsql"
PG_CMD="SELECT 1 FROM pg_database WHERE datname"
UNAME="--username postgres"

#
# @brief   Main entry point
# @param   Value optional help
# @exitval Script tool pobackup exit with integer value
#			0   - success operation 
# 			127 - run as root user
#			128 - missing pg_dump tool
#			129 - missing argument
#			130 - wrong argument (operation)
#
printf "\n%s\n%s\n\n" "$TOOL_NAME $TOOL_VERSION" "`date`"
HELP=$1
__checkroot
STATUS=$?
if [ "$STATUS" -eq "$SUCCESS" ]; then
    if [ "$HELP" == "help" ]; then
        __usage $POBACKUP_USAGE
		exit 0
    else
        __checktool "$PGDUMP"
        STATUS=$?
        if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
            exit 128
        fi
        FILE=company.postgres.`date +"%Y%m%d"`
        DATABASE=XXX
        databases=( po_test )
        for i in "${databases[@]}"
        do
            DATABASE=$i
			CHECK_DB="psql -tAc \"$PG_CMD='$DATABASE'\" > $DATABASE.rpt; exit 0"
			su - postgres -c "$CHECK_DB"
            RESULT=$(cat "$PGSQL/$DATABASE.rpt")
            if [ "$RESULT" == "1" ]; then
				SQL="$PGDUMP $UNAME $DATABASE > ${FILE}_${DATABASE}; exit 0"
				su - postgres -c "$SQL"
				mv "$PGSQL/${FILE}_${DATABASE}" "$PGDUMP_ROOT_LOCATION/"
				rm "$PGSQL/$DATABASE.rpt"
				PG_BACKUP="$PGDUMP_ROOT_LOCATION/${FILE}_${DATABASE}"
                if [ -e "$PG_BACKUP" ]; then
					gzip "$PG_BACKUP"
					if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%s\n" "Backup [$PG_BACKUP.gz] was created"
					fi
                    ls -l "${PG_BACKUP}.gz"
                    LOG[FLAG]="info"
                    LOG[PATH]="$TOOL_LOG"
                    LOG[MSG]="Backup [$PG_BACKUP.gz] was created"
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "%s\n" "${LOG[MSG]}"
					fi
                    __logging $LOG
                fi
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n\n" "Check file [$PG_BACKUP]"
				fi
            else
				LOG[FLAG]="error"
                LOG[PATH]="$TOOL_LOG"
                LOG[MSG]="Database [$DATABASE] does not exist"
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "[Error] ${LOG[MSG]}"
				fi
                __logging $LOG
            fi
        done
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
		exit 0
    fi
fi

exit 127


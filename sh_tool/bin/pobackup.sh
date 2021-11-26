#!/bin/bash
#
# @brief   PostgreSQL backup manager
# @version ver.2.0
# @date    Fri 26 Nov 2021 07:34:17 PM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_root.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/logging.sh
.    ${UTIL}/bin/load_conf.sh
.    ${UTIL}/bin/load_util_conf.sh
.    ${UTIL}/bin/progress_bar.sh

POBACKUP_TOOL=pobackup
POBACKUP_VERSION=ver.2.0
POBACKUP_HOME=${UTIL_ROOT}/${POBACKUP_TOOL}/${POBACKUP_VERSION}
POBACKUP_CFG=${POBACKUP_HOME}/conf/${POBACKUP_TOOL}.cfg
POBACKUP_UTIL_CFG=${POBACKUP_HOME}/conf/${POBACKUP_TOOL}_util.cfg
POBACKUP_LOGO=${POBACKUP_HOME}/conf/${POBACKUP_TOOL}.logo
POBACKUP_LOG=${POBACKUP_HOME}/log

tabs 4
CONSOLE_WIDTH=$(stty size | awk '{print $2}')

.    ${POBACKUP_HOME}/bin/center.sh
.    ${POBACKUP_HOME}/bin/display_logo.sh

declare -A POBACKUP_USAGE=(
    [USAGE_TOOL]="${POBACKUP_TOOL}"
    [USAGE_ARG1]="[OPTION] help (optional)"
    [USAGE_EX_PRE]="# Postgres backup mechanism"
    [USAGE_EX]="${POBACKUP_TOOL} help"
)

declare -A POBACKUP_LOGGING=(
    [LOG_TOOL]="${POBACKUP_TOOL}"
    [LOG_FLAG]="info"
    [LOG_PATH]="${POBACKUP_LOG}"
    [LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
    [BW]=50
    [MP]=100
    [SLEEP]=0.01
)

TOOL_DBG="false"
TOOL_LOG="false"
TOOL_NOTIFY="false"

#
# @brief   Main entry point
# @param   Value optional help
# @retval  Function __pobackup exit with integer value
#            0   - tool finished with success operation
#            128 - failed to load tool script configuration from files
#            129 - missing external tool pgdump
#
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
function __pobackup {
    local HELP=$1
    display_logo
    if [ "${HELP}" == "help" ]; then
        usage POBACKUP_USAGE
    fi
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS_CONF STATUS_CONF_UTIL STATUS
    MSG="Loading basic and util configuration!"
    info_debug_message "$MSG" "$FUNC" "$POBACKUP_TOOL"
    progress_bar PB_STRUCTURE
    declare -A config_pobackup=()
    load_conf "$POBACKUP_CFG" config_pobackup
    STATUS_CONF=$?
    declare -A config_pobackup_util=()
    load_util_conf "$POBACKUP_UTIL_CFG" config_pobackup_util
    STATUS_CONF_UTIL=$?
    declare -A STATUS_STRUCTURE=([1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL)
    check_status STATUS_STRUCTURE
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$POBACKUP_TOOL"
        exit 128
    fi
    TOOL_DBG=${config_pobackup[DEBUGGING]}
    TOOL_LOG=${config_pobackup[LOGGING]}
    TOOL_NOTIFY=${config_pobackup[EMAILING]}
    local PGDUMP=${config_pobackup_util[PGDUMP]}
    check_tool "${PGDUMP}"
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        MSG="Install tool ${PGDUMP}"
        info_debug_message "$MSG" "$FUNC" "$POBACKUP_TOOL"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$POBACKUP_TOOL"
        exit 129
    fi
    local COMPANY=${config_pobackup_util[COMPANY]} I
    local FILE=${COMPANY}.postgres.`date +"%Y%m%d"`
    local DB=${config_pobackup_util[DB]} UN=${config_pobackup_util[UNAME]}
    local PGCMD=${config_pobackup_util[PG_CMD]}
    local PGSQL=${config_pobackup_util[PGSQL]}
    local PGDIR=${config_pobackup_util[PGDUMP_ROOT_LOCATION]}
    local DATABASES=${config_atmanager_util[POSTGRES_DATABASES]}
    IFS=' ' read -ra databases <<< "${DATABASES}"
    for I in "${databases[@]}"
    do
        DB=${I}
        local CHECKDB="psql -tAc \"${PGCMD}='${DB}'\" > ${DB}.rpt; exit 0"
        su - postgres -c "${CHECKDB}"
        local RESULT=$(cat "${PGSQL}/${DB}.rpt")
        if [ "${RESULT}" == "1" ]; then
            local SQL="${PGDUMP} ${UN} ${DB} > ${FILE}_${DB}; exit 0"
            su - postgres -c "$SQL"
            mv "${PGSQL}/${FILE}_${DB}" "${PGDIR}/"
            rm "${PGSQL}/${DB}.rpt"
            local PG_BACKUP="${PGDIR}/${FILE}_${DB}"
            if [ -e "${PG_BACKUP}" ]; then
                gzip "${PG_BACKUP}"
                MSG="Backup [${PG_BACKUP}.gz] was created"
                info_debug_message "$MSG" "$FUNC" "$POBACKUP_TOOL"
                ls -l "${PG_BACKUP}.gz"
                POBACKUP_LOGGING[LOG_FLAG]="info"
                POBACKUP_LOGGING[LOG_MSGE]=$MSG
                logging POBACKUP_LOGGING
            fi
            MSG="Check file [${PG_BACKUP}]"
            info_debug_message "$MSG" "$FUNC" "$POBACKUP_TOOL"
        else
            MSG="Database [${DB}] does not exist"
            info_debug_message "$MSG" "$FUNC" "$POBACKUP_TOOL"
        fi
        done
    info_debug_message_end "Done" "$FUNC" "$POBACKUP_TOOL"
    exit 0
}

#
# @brief   Main entry point
# @param   Value optional help
# @exitval Script tool pobackup exit with integer value
#            0   - tool finished with success operation
#            127 - run tool script as root user from cli
#            128 - failed to load tool script configuration from files
#            129 - missing external tool pgdump
#
printf "\n%s\n%s\n\n" "${POBACKUP_TOOL} ${POBACKUP_VERSION}" "`date`"
check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
    __pobackup $1
fi

exit 127

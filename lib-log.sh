# vim: expandtab softtabstop=4 tabstop=4 shiftwidth=4 autoindent

function realrelpath {
    local L_PATH=""
    local L_DIR=""

    if [ $# -ne 0 ]; then
        L_PATH="$1"
    else
        L_PATH="${BASH_SOURCE[0]}"
    fi

    while [ -h "$L_PATH" ]; do
        L_DIR="$(cd -P "$(dirname "$L_PATH")" > /dev/null 2>&1 && pwd)"
        L_PATH="$(readlink "$L_PATH")"
        [[ "$L_PATH" != /* ]] && L_PATH="${L_DIR}/${L_PATH}"
    done

    echo "$L_PATH"
}

function get_scriptpath_rel {
    local SCRIPTRELDIR="$(dirname "$(realrelpath ${BASH_SOURCE[0]})")"
    local SCRIPTABSDIR="$(readlink -f ${SCRIPTRELDIR})"
    echo "$SCRIPTRELDIR"
}

function get_scriptpath_abs {
    local SCRIPTRELDIR="$(dirname "$(realrelpath ${BASH_SOURCE[0]})")"
    local SCRIPTABSDIR="$(readlink -f ${SCRIPTRELDIR})"
    echo "$SCRIPTABSDIR"
}

source "$(get_scriptpath_rel)/lib-color.sh"

### Setup LOG-Level
LOGEMERG=6
LOGERROR=5
LOGWARN=4
LOGINFO=3
LOGDEBUG=2
LOGDEBUG0=1
LOGALL=0
LOGMAX=$LOGEMERG

# overwrite if necessary
DEFAULT_LOGLEVEL=$LOGWARN
DEFAULT_VERBOSE=0

function log {
	local L_MSG="$2"
	local L_LEVEL="$1"

	if [ -z "$L_LEVEL" ]; then
		L_LEVEL=$LOGWARN
		L_MSG="$1"
	fi

	if [ $L_LEVEL -ge $LOGLEVEL ]; then
        case $L_LEVEL in
            $LOGDEBUG0) co 256f 243; ;;
            $LOGDEBUG) co 256f 220; ;;
            $LOGINFO) co 256f 255; ;;
            $LOGWARN) co 256f 208; ;;
            $LOGERROR) co 256f 196; ;;
            $LOGEMERG) co 256f 200; ;;
            *) co rst; ;;
        esac
		echo $L_MSG
        co rst
	fi
}

function checklog {
	local L_LEVEL="$1"

	if [ $L_LEVEL -ge $LOGLEVEL ]; then
        return 0
    fi
    return 1
}

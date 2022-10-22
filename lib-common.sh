# vim: expandtab softtabstop=4 tabstop=4 shiftwidth=4 autoindent

DATETIME="$(date --rfc-3339=seconds)"

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

SCRIPTRELDIR="$(dirname "$(realrelpath ${BASH_SOURCE[0]})")"
SCRIPTABSDIR="$(readlink -f ${SCRIPTRELDIR})"
SCRIPTDIR="$SCRIPTABSDIR"

### Functions use for libs
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

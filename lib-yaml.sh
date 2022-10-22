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

source "$(get_scriptpath_rel)/lib-log.sh"

function yaml_value {
    local L_YAMLPATH="$1"
    local L_YAMLFILE="${2:-$OPT_MASTER_CONFIG_PATH}"
    local L_YAMLTAG=""
    local L_YAMLVALUE=""

    L_YAMLTAG="$(cat "${L_YAMLFILE}" | yq "$L_YAMLPATH"' | explode(.) | tag')"
    if [ $? -ne 0 ]; then
        echo "$L_YAMLTAG"
        echo "ERROR: Could not resolve Yaml-Path: $L_YAMLPATH"
        return 1
    fi

    L_YAMLVALUE="$(cat "${L_YAMLFILE}" | yq "$L_YAMLPATH"' | explode(.)')"
    if [ $? -ne 0 ]; then
        echo "$L_YAMLVALUE"
        echo "ERROR: Could not resolve Yaml-Path: $L_YAMLPATH"
        return 1
    fi

    if [ "$L_YAMLTAG" == "!!ref" ]; then
        if [[ "$L_YAMLVALUE" =~ \[(.*)\](:(.*))? ]]; then
            local L_REFPATH="${BASH_REMATCH[1]}"
            local L_FILE="${BASH_REMATCH[3]}"

            if [ "${L_FILE,,}" != "self" ] && [ -n "$L_FILE" ]; then
                echo "ERROR: reference to other files not supported yet!; File: '$L_YAMLFILE' reference to file: '$L_FILE'; Refpath: '$L_YAMLPATH'"
                return 1
            fi

            L_YAMLTAG="$(cat "${L_YAMLFILE}" | yq "$L_REFPATH"' | explode(.) | tag')"
            if [ $? -ne 0 ]; then
                echo "$L_YAMLTAG"
                echo "ERROR: Could not resolve Yaml-Path: $L_REFPATH"
                return 1
            fi

            if [ "$L_YAMLTAG" == "!!ref" ]; then
                L_YAMLVALUE=$(yaml_value "$L_REFPATH" "$L_YAMLFILE")
                if [ $? -ne 0 ]; then
                    echo "$L_YAMLVALUE"
                    echo "ERROR: Could not resolve Yaml-Path: $L_REFPATH"
                    return 1
                fi
            else
                L_YAMLVALUE="$(cat "${L_YAMLFILE}" | yq "$L_REFPATH"' | explode(.)')"
            fi
        fi
    fi

    echo "$L_YAMLVALUE"
    return 0
}

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

# overwrite if necessary
CO_DISABLED=0

# color output
function co {
    # Global variable
    CO_DISABLED=${CO_DISABLED:-0}
    [ $CO_DISABLED -ne 0 ] && return 0

    # General
    local L_C_ESC="\e["
    local L_C_RESET="0"

    # Foreground - normal
    # Format: ESC[0;${X}m
    local L_C_FBLACK="30"
    local L_C_FRED="31"
    local L_C_FGREEN="32"
    local L_C_FYELLOW="33"
    local L_C_FBLUE="34"
    local L_C_FMAGENTA="35"
    local L_C_FCYAN="36"
    local L_C_FCWHITE="37"
    local L_C_FDEFAULT="39"

    # Foreground - bright
    # Format: ESC[0;${X}m
    local L_C_FBBLACK="90"
    local L_C_FBRED="91"
    local L_C_FBGREEN="92"
    local L_C_FBYELLOW="93"
    local L_C_FBBLUE="94"
    local L_C_FBMAGENTA="95"
    local L_C_FBCYAN="96"
    local L_C_FBCWHITE="97"

    # Background - normal
    # Format: ESC[0;${X}m
    local L_C_BBLACK="40"
    local L_C_BRED="41"
    local L_C_BGREEN="42"
    local L_C_BYELLOW="43"
    local L_C_BBLUE="44"
    local L_C_BMAGENTA="45"
    local L_C_BCYAN="46"
    local L_C_BWHITE="47"
    local L_C_BDEFAULT="49"

    # Background - bright
    # Format: ESC[0;${X}m
    local L_C_BBBLACK="100"
    local L_C_BBRED="101"
    local L_C_BBGREEN="102"
    local L_C_BBYELLOW="103"
    local L_C_BBBLUE="104"
    local L_C_BBMAGENTA="105"
    local L_C_BBCYAN="106"
    local L_C_BBWHITE="107"

    # support for 256 color table
    # Format: ESC[38;5;${X}m
    local L_C_256_F="38;5"
    local L_C_256_B="48;5"

    # support for Truecolor (24bit RGB)
    # Format: ESC[38;2;${R},${G},${B}m
    local L_C_TC_F="38;2"
    local L_C_TC_B="48;2"

    # Options
    local L_C_OPT_BOLD="1"
    local L_C_OPT_NORMAL="0"

    local L_CMD=${1^^}
    local L_VAL=${2:-""}
    L_VAL=${L_VAL^^}
    local L_OPT=${3:-""}
    L_OPT=${L_OPT^^}

    case $L_CMD in
        F)
            local V1="L_C_F$L_VAL"
            local V2="L_C_OPT_$L_OPT"

            [ -z "$L_OPT" ] && V2="L_C_OPT_NORMAL"
            printf "${L_C_ESC}%s;%sm" ${!V2} ${!V1}
            ;;
        B)
            local V1="L_C_B$L_VAL"
            local V2="L_C_OPT_$L_OPT"

            [ -z "$L_OPT" ] && V2="L_C_OPT_NORMAL"
            printf "${L_C_ESC}%s;%sm" ${!V2} ${!V1}
            ;;
        256F)
            printf "${L_C_ESC}${L_C_256_F};%sm" $L_VAL
            ;;
        256B)
            printf "${L_C_ESC}${L_C_256_B};%sm" $L_VAL
            ;;
        RGBF)
            local L_R=${2:-0}
            local L_G=${3:-$L_R}
            local L_B=${4:-$L_G}
            printf "${L_C_ESC}${L_C_TC_F};%s;%s;%sm" $L_R $L_G $L_B
            ;;
        RST)
            printf "${L_C_ESC}${L_C_RESET}m"
            ;;
        *)
            printf "<?color?cmd?>"
            ;;
    esac
}

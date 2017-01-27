# escape colors
ec() {
    echo "\[${1}\]";
}

# colors
COLOR_OFF='\033[00m'
COLOR_RED='\033[01;31m'
COLOR_GREEN='\033[01;32m'
COLOR_BLUE='\033[01;34m'
COLOR_YELLOW='\033[00;33m'
COLOR_GRAY='\033[30;1m'
COLOR_PURPLE='\033[00;35m'
COLOR_CYAN='\033[00;36m'

COLOR_BORDER=${COLOR_BORDER:-$COLOR_GRAY}
COLOR_CHROOT=${COLOR_CHROOT:-$COLOR_YELLOW}
COLOR_GIT=${COLOR_GIT:-$COLOR_BLUE}
COLOR_VENV=${COLOR_VENV:-$COLOR_CYAN}
COLOR_PATH=${COLOR_PATH:-$COLOR_BLUE}
COLOR_DIR_STAT=${COLOR_DIR_STAT:-$COLOR_YELLOW}
COLOR_TIME=${COLOR_TIME:-$COLOR_PURPLE}
COLOR_USER=${COLOR_USER:-$COLOR_GREEN}
COLOR_ROOT=${COLOR_ROOT:-$COLOR_RED}
COLOR_HOST=${COLOR_HOST:-$COLOR_GREEN}


# lines
BL_ANGLE="\342\224\224"
TL_ANGLE="\342\224\214"
HORIZ_LINE="─" # "\342\224\200"

# debian chroot
if [ -n "${debian_chroot}" ]; then
    DEBIAN_CHROOT="`ec ${COLOR_BORDER}`${HORIZ_LINE}(`ec ${COLOR_CHROOT}`"
    DEBIAN_CHROOT="${DEBIAN_CHROOT}${debian_chroot:+($debian_chroot)}"
    DEBIAN_CHROOT="${DEBIAN_CHROOT}`ec ${COLOR_BORDER}`)${HORIZ_LINE}"
fi


# GIT_PS1 config
GIT_PS1_SHOWDIRTYSTATE=1;
GIT_PS1_SHOWCOLORHINTS=1;
GIT_PS1_SHOWUNTRACKEDFILES=1;

GIT_PS1='$(__git_ps1 "${COLOR_BORDER}${HORIZ_LINE}(${COLOR_GIT}%s${COLOR_BORDER})")'

# python's virtualenv
VIRTUAL_ENV_DISABLE_PROMPT="y"
py_virtualenv(){
    if [ -z "${VIRTUAL_ENV}" ]; then
        return;
    fi

    if [ -z "${_OLD_VIRTUAL_PS1}" ]; then
        _OLD_VIRTUAL_PS1="${PS1}"
    fi

    if [ "`basename \"$VIRTUAL_ENV\"`" = "__" ] ; then
        # special case for Aspen magic directories
        # see http://www.zetadev.com/software/aspen/
        echo -e "${COLOR_BORDER}[${COLOR_VENV}`basename \`dirname \"$VIRTUAL_ENV\"\``${COLOR_BORDER}]${HORIZ_LINE}"
    else
        echo -e "${COLOR_BORDER}(${COLOR_VENV}`basename \"$VIRTUAL_ENV\"`${COLOR_BORDER})${HORIZ_LINE}"
    fi
}

# directory statistics
FILES_STAT="\$(ls -1 | wc -l | sed 's: ::g')"
FILES_SIZE="\$(LC_ALL=C ls -lah | grep -m 1 total | sed 's/1:total //')b"

CWD="`ec ${COLOR_PATH}`\w`ec ${COLOR_BORDER}`)"
DIR_STAT="`ec ${COLOR_DIR_STAT}`${FILES_STAT} files, ${FILES_SIZE}"
DIR_DATA="(${CWD}${HORIZ_LINE}(${DIR_STAT}`ec ${COLOR_BORDER}`)"


# current time
PS1_TIME="`ec ${COLOR_BORDER}`(`ec ${COLOR_TIME}`\t`ec ${COLOR_BORDER}`)"


_OLD_PS1="${PS1}"

ps1_restore() {
    if [ -n "${_OLD_PS1}" ]; then
        PS1="${_OLD_PS1}"
        unset _OLD_PS1
    fi
}

ps1_beautify() {
    LINE_0="\n`ec ${COLOR_BORDER}`${TL_ANGLE}\$(py_virtualenv)${DIR_DATA}${GIT_PS1}"
    LINE_1="`ec ${COLOR_BORDER}`${BL_ANGLE}${DEBIAN_CHROOT}${PS1_TIME}${HORIZ_LINE}("

    if [[ ${EUID} == 0 ]] ; then
        LINE_1="${LINE_1}`ec ${COLOR_ROOT}`\h"
    else
        LINE_1="${LINE_1}`ec ${COLOR_USER}`\u`ec ${COLOR_HOST}`@\h"
    fi

    LINE_1="${LINE_1}`ec ${COLOR_BORDER}`) `ec ${COLOR_OFF}`\\\$ "

    PS1="${LINE_0}\n${LINE_1}"
}

ps1_beautify

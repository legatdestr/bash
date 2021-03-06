#!/usr/bin/env bash

### Functions
#####################################################################

function _fmt ()      {
  local color_debug="\x1b[35m"
  local color_info="\x1b[32m"
  local color_notice="\x1b[34m"
  local color_warning="\x1b[33m"
  local color_error="\x1b[31m"
  local color_critical="\x1b[1;31m"
  local color_alert="\x1b[1;33;41m"
  local color_emergency="\x1b[1;4;5;33;41m"
  local colorvar=color_$1

  local color="${!colorvar:-$color_error}"
  local color_reset="\x1b[0m"
  if [ "${NO_COLOR}" = "true" ] || [[ "${TERM:-}" != "xterm"* ]] || [ -t 1 ]; then
    # Don't use colors on pipes or non-recognized terminals
    color=""; color_reset=""
  fi
  echo -e "$(date -u +"%Y-%m-%d %H:%M:%S UTC") ${color}$(printf "[%9s]" ${1})${color_reset}";
}
function emergency () {                             echo "$(_fmt emergency) ${@}" 1>&2 || true; exit 1; }
function alert ()     { [ "${LOG_LEVEL}" -ge 1 ] && echo "$(_fmt alert) ${@}" 1>&2 || true; }
function critical ()  { [ "${LOG_LEVEL}" -ge 2 ] && echo "$(_fmt critical) ${@}" 1>&2 || true; }
function error ()     { [ "${LOG_LEVEL}" -ge 3 ] && echo "$(_fmt error) ${@}" 1>&2 || true; }
function warning ()   { [ "${LOG_LEVEL}" -ge 4 ] && echo "$(_fmt warning) ${@}" 1>&2 || true; }
function notice ()    { [ "${LOG_LEVEL}" -ge 5 ] && echo "$(_fmt notice) ${@}" 1>&2 || true; }
function info ()      { [ "${LOG_LEVEL}" -ge 6 ] && echo "$(_fmt info) ${@}" 1>&2 || true; }
function debug ()     { [ "${LOG_LEVEL}" -ge 7 ] && echo "$(_fmt debug) ${@}" 1>&2 || true; }

function help () {
  echo "" 1>&2
  echo " ${@}" 1>&2
  echo "" 1>&2
  echo "  ${usage}" 1>&2
  echo "" 1>&2
  exit 1
}


# All of these go to STDERR, so you can use STDOUT for piping machine readable information to other software
#debug "Info useful to developers for debugging the application, not useful during operations."
#info "Normal operational messages - may be harvested for reporting, measuring throughput, etc. - no action required."
#notice "Events that are unusual but not error conditions - might be summarized in an email to developers or admins to spot potential problems - no immediate action required."
#warning "Warning messages, not an error, but indication that an error will occur if action is not taken, e.g. file system 85% full - each item must be resolved within a given time. This is a debug message"
#error "Non-urgent failures, these should be relayed to developers or admins; each item must be resolved within a given time."
#critical "Should be corrected immediately, but indicates failure in a primary system, an example is a loss of a backup ISP connection."
#alert "Should be corrected immediately, therefore notify staff who can fix the problem. An example would be the loss of a primary ISP connection."
#emergency "A \"panic\" condition usually affecting multiple apps/servers/sites. At this level it would usually notify all tech staff on call."

VAR_LAST_RESULT=0;

function process_step () {
  if [[ $? -ne 0  ]] ; then
    alert "${1}";
    exit 1;
  else
    info "${1}"
  fi;
}

# Проверяет доступна ди директория
function isDirectory() {
  if [ -d "${1}" ]
  then
    # 0 = true
    return 0
  else
    # 1 = false
    return 1
  fi
}

# Требует права администратора, если нет, выводит сообщение и exit
function regectIfNoRights (){
  if [[ $UID != 0 ]]; then
      critical "Пожалуйста, запустите этот скрипт с правами администратора: sudo $0 $*";
      exit 1;
  fi;
}




function isPackageInstalled {
  if yum list installed "$@" >/dev/null 2>&1; then
    true;
  else
    false;
  fi;
}

# проверка доступна ли команда:
# command -v foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
# type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
# hash foo 2>/dev/null || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }


function PrintPackageInstalled () {
  info "Пакет ${1} уже установлен. Установка не требуется.";
}

function PrintPackageNotInstalled () {
  warning "Пакет ${1} не установлен. Будет произведена попытка его установить...";
}


function isUserGroupExists () {
  if egrep -i "^$1" /etc/group >/dev/null 2>&1; then
    true;
  else
    false;
  fi;
}


function isUserExists () {
  if id "$1" >/dev/null 2>&1; then
      true;
  else
      false;
  fi;
}

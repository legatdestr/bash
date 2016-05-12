#!/usr/bin/env bash

TIME=$(date +%s);

C_CONFIG_FILE_PATH='../config.cfg';
C_LIB_DIR="../lib";
C_INSTALLATION_DIR='installAllEnvironment';


# Файл конфигурации
source "${C_CONFIG_FILE_PATH}";
if [[ $? -ne 0  ]]; then
  echo "Ошибка подключения файла конфигурации: ${C_CONFIG_FILE_PATH}";
  exit 1;
fi;

# Общие функции
source "${C_LIB_DIR}"/"common.sh";
if [[ $? -ne 0  ]] ; then
   echo "Ошибка подключения библиотеки: ${C_LIB_DIR}/common.sh";
   exit 1;
fi;
process_step 'Подключение библиотеки функций - common.sh';

# Вызывается при завершении работы скрипта.
# Здесь можно гарантированно удалить временные директории к примеру
function cleanup_before_exit () {
  if [[ $? -ne 0  ]] ; then
    alert "ОШИБКА. Что-то пошло не так.  Время выполнения: $(($(date +%s)-${TIME})) сек.";
    exit 1;
  else
    notice $(echo -e "Работа скрипта завершена. Время выполнения: $(($(date +%s)-${TIME})) сек.");
  fi;

}
trap cleanup_before_exit EXIT;
trap exit ERR;


# ==================================MAIN========================================
# параметр --init-db=true/false. false by default
initDbFlag=false;

while [ "$#" -gt 0 ]; do
  case "$1" in
     --init-db=*) initDbFlag="${1#*=}"; shift 1;;
    
   # -n) name="$2"; shift 2;;
   # -p) pidfile="$2"; shift 2;;
   # -l) logfile="$2"; shift 2;;

   # --name=*) name="${1#*=}"; shift 1;;
   # --pidfile=*) pidfile="${1#*=}"; shift 1;;
   # --logfile=*) logfile="${1#*=}"; shift 1;;
   # --name|--pidfile|--logfile) echo "$1 requires an argument" >&2; exit 1;;

   # -*) echo "unknown option: $1" >&2; exit 1;;
    *) handle_argument "$1"; shift 1;;
  esac;
done;


source "${C_LIB_DIR}/proxyUser.sh";
source "${__dir}/deploy/repository.sh" && runRepositoryModule;

var_refresh_spa=true;
var_refresh_api=true;
var_refresh_migration_setup=true;
var_apply_migrations=true;
if [ -f  "${C_GIT_REVISION_FILE}" ]; then
  var_last_revision=$(<${C_GIT_REVISION_FILE});  
  if [ -d "${C_GIT_CLONE_DIR}" ]; then
    cd "${C_GIT_CLONE_DIR}";
    var_cur_git_revision=$(git rev-parse HEAD);
     
    if  $(git diff  --name-only --quiet --exit-code "${var_last_revision}" "${var_cur_git_revision}" "${C_GIT_SPA_DIR}" ) ; then
      var_refresh_spa=false;
      else
      var_refresh_spa=true;
    fi;     
    
    if  $(git diff  --name-only --quiet --exit-code "${var_last_revision}" "${var_cur_git_revision}" "${C_GIT_API_DIR}" ) ; then
      var_refresh_api=false;
      else
      var_refresh_api=true;
    fi;     
    
    if  $(git diff  --name-only --quiet --exit-code "${var_last_revision}" "${var_cur_git_revision}" "${C_GIT_MIGRATION_TOOL_DIR}" ) ; then
      var_refresh_migration_setup=false;
      else
      var_refresh_migration_setup=true;
    fi;     
    
    if  $(git diff  --name-only --quiet --exit-code "${var_last_revision}" "${var_cur_git_revision}" "${C_GIT_APPLY_MIGRATION_DIR}" ) ; then
      var_apply_migrations=false;
      else
      var_apply_migrations=true;
    fi;     
           
  fi;
fi;



if [ ${var_refresh_spa} = "true" ]; then 
  source "${__dir}/deploy/spa.sh" && runSpaModule;
fi; 

if [ ${var_refresh_api} = "true" ]; then 
  source "${__dir}/deploy/api.sh" && runApiModule;
fi; 

if [ ${var_refresh_migration_setup} = "true" ]; then 
  source "${__dir}/deploy/migration_setup.sh" && runMigrationModule;
fi; 

if [ "${initDbFlag}" = "true" ]; then
   source "${__dir}/deploy/initDb.sh" && initDb;   
fi;

if [ ${var_apply_migrations} = "true" ]; then 
  source "${__dir}/deploy/migration_apply.sh" && applyMigrations;
fi;

updateGitRevisionFile ;

# ================================END MAIN======================================
#!/bin/bash


function runSpaModule(){
  if ! hash ember 2>/dev/null ; then
    PrintPackageNotInstalled 'ember-cli';
  else
     if [ ! -d "${C_GIT_SPA_DIR}" ]; then
       process_step 'Директория SPA указана неверно: '"${C_GIT_SPA_DIR}";
     else
       # Директория существует
       cd "${C_GIT_SPA_DIR}";
       process_step 'Смена директории SPA';
       npm install;
       process_step 'Подтягивание npm зависимостей для SPA';
       bower install;
       process_step 'Подтягивание bower зависимостей для SPA';
       info 'Запуск построения SPA';
       ember build --environment=test;
       process_step 'Построение SPA';

       if [[ ! -z "${C_SPA_DEPLOY_URL// }" ]]; then
         sed -i "s#<base href=".*">#<base href='${C_SPA_DEPLOY_URL}' />#g" "${C_GIT_SPA_DIR}"/dist/index.html;
         process_step 'Задаем base_href';
       else
         notice 'base_href не был изменен - C_SPA_DEPLOY_URL не задан';
       fi;

       rm -rf "${C_SPA_DEPLOY_DIR}/*" > /dev/null;
       cp -vr dist/* "${C_SPA_DEPLOY_DIR}/" > /dev/null;
     fi;
  fi;
}

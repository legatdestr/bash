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
       bower install;
       ember build --environment=production;
       process_step 'Построение SPA';
       rm -rf "${C_SPA_DEPLOY_DIR}/*";
       cp -vr dist/* "${C_SPA_DEPLOY_DIR}/";
     fi;
  fi;
}

runSpaModule;

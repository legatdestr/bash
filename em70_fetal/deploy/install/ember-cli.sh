#!/bin/bash

function installEmberCli () {
  info 'Установка ember-cli';
  npm install -g ember-cli;
  touch ~/.bowerrc
  if [ -n "${C_PROXY_URI}" ]; then
      echo {"proxy': '${C_PROXY_URI}', 'https-proxy':'${C_PROXY_URI}' }" >> ~/.bowerrc;
  fi;  
}

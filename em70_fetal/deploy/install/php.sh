#!/bin/bash

function installPhp5 () {
  if ! isPackageInstalled 'epel-release-7-6*'; then
    PrintPackageNotInstalled 'epel-release-7-6*';
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;
  else
    PrintPackageInstalled 'epel-release-7-6*';
  fi;

  if ! isPackageInstalled 'webtatic-release'; then
    PrintPackageNotInstalled 'webtatic-release';
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm;
  else
    PrintPackageInstalled 'webtatic-release';
  fi;

  yum install php56w php56w-opcache php56w-common php56w-mbstring php56w-pdo php56w-pgsql php56w-pecl-memcache -y -y;
  service httpd restart;
}

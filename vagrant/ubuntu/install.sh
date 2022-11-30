#!/bin/bash
apt update
SCRIPTS="/vagrant/ubuntu/scripts"

#[ "$1" ] && cd "$1"
cd $SCRIPTS

[ "$?" -ne 0 ] && echo 'Sem arquivos sh nesse diretório' && exit 0
find . -name "*.sh" | sort | while read -r ARQUIVO; do
  echo -e "========= Executando $ARQUIVO ==========="
  sh $ARQUIVO
  
done
#!/bin/bash

updateSystem () {
    echo -e "\n\n========= Executando # Instalando ferramentas ==========="
    sudo apt install ansible \
                     unzip \
                     git -y
}

updateSystem
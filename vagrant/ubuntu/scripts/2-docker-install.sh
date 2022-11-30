#!/bin/bash

install_gCloud () {
    echo -e "\n\n========= Executando # Instalando DOCKER ==========="
    curl -fsSl https://get.docker.com | bash
    sudo usermod -aG docker usuario
    sudo usermod -aG docker vagrant

    echo -e "\n\n========= Executando # Instalando DOCKER BUILD X ==========="

    curl -JLO https://github.com/docker/buildx/releases/download/v0.9.1/buildx-v0.9.1.linux-amd64
    mkdir -p ~/.docker/cli-plugins
    mv buildx-v0.9.1.linux-amd64 ~/.docker/cli-plugins/docker-buildx
    chmod a+rx ~/.docker/cli-plugins/docker-buildx
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --use --name crossx

}

install_gCloud
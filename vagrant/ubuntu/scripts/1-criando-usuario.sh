#!/bin/bash
### vars.sh ####
USER='usuario'
PASS='usuario01'

addUsers () {
    #criando o usuário suporte
    useradd -m -d "/home/${USER}" -p $(openssl passwd -1 ${PASS}) -s /bin/bash ${USER} -G sudo

    # aqui a chave compartilhada atraves do vagrantfile é adicionado ao authorized_keys do user usuario
    #config.vm.provision :shell, :inline => "cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys", run: "always"
    mkdir -p /home/usuario/.ssh/
    cat /home/vagrant/.ssh/id_rsa.pub.usuario >> /home/usuario/.ssh/authorized_keys

    #alterando a senha do usuario vagrant
    sudo usermod -p $(openssl passwd -1 ${PASS}) vagrant

    #alterando a senha do root
    sudo usermod -p $(openssl passwd -1 ${PASS}) root
}

addUsers
#!/bin/bash

list_todas_running () {
    cod='1'
    LIST_TODAS=$(docker run --rm -v $(pwd)/.aws:/root/.aws amazon/aws-cli ec2 \
                                describe-instances \
                                --region $region \
                                --filters "Name=instance-state-name,Values=running" \
                                --query "Reservations[*].Instances[*]. \
                                {PublicIP:PublicIpAddress, \
                                Name:Tags[?Key=='Name']|[0].Value, \
                                Status:State.Name, \
                                Chavepem: KeyName}" \
                                --output table > servidores-table.txt)
}
createDotEnv () {

    ## RECUPERA AS CREDENCIAIS CONFORME PREENCHIMENTO DAS VARIÁVEIS
    #  -----x------x-----x------x-----x------x-----x------x-----x--

    ### Alterar:
    # credFile o nome usuario para o nome do seu usuario da maquina
    credFile="${fileCredentials}";
    # PROFILE alterar para no profile do seu acesso a AWS - se for padrão usar default
    # PROFILE=

    # if [ -z "$1" ] 
    # then
    #     profileName="ramper"
    # fi

    folderFileExit=$(pwd)"/";
    # rm -Rf *.txt

    while IFS= read -r line || [[ -n "$line" ]]; 
        do 
            subStr=$(echo $line| cut -c1);
            if [[ $subStr == "[" ]]
            then
                fileExit=$(echo $line | sed 's/[][]//g')
                fileNew="$folderFileExit$fileExit".txt
            fi
            if [[ $fileExit == $profileName ]]
            then
                fileNew="$folderFileExit$fileExit".txt
                if [[ $subStr == "[" ]]
                then
                    echo "[default]" > $fileNew;
                else
                    echo "$line" >> $fileNew;
                fi
                mkdir -p .aws
                cp $fileNew .aws/credentials
                # rm $fileNew
            fi
    done < "$credFile"
}
createFileServers () {
    linha=$(echo -e "$linha[all]\n")
    while IFS= read -r line || [[ -n "$line" ]]; 
        do 
            subStr=$(echo $line| cut -c1);
            if [[ ! $line =~ '---' && ! $line =~ 'Chavepem' && ! $line =~ 'DescribeInstances' ]]
            then
                keyPair=$(echo $line | sed 's/ //g' | cut -f2 -d"|")
                ipServer=$(echo $line | sed 's/ //g' | cut -f4 -d"|")
                nameServer=$(echo $line | sed 's/ //g' | cut -f3 -d"|")
                nameServer2=$(echo $nameServer | sed 's/\[Ramper\]//g')
                linha=$(echo -e "$linha\n${ipServer}   meu_hostname=${nameServer2} ansible_ssh_private_key_file=${folderKeyPair}${keyPair}.pem  \n")
                # linha=$(echo -e "$linha\n${profileName} -> ${nameServer} -> ${nameServer2}\nssh -o StrictHostKeyChecking=no -i ${folderKeyPair}${keyPair}.pem ${userServer}@${ipServer}\033[0;30m\n")
            fi
    done < "servidores-table.txt"

}

#cd /home/usuario/ramper/util/lista_instancias

# carrega o arquivo com as variáveis
#  nao usar agora --- source dados.txt
##------------- Inicio Variáveis
# DECLARAÇÃO DE VARIÁVEIS
# -> Daqui pra baixo precisa ser atualizado conforme sua necessidade

#variaveis comums
fileCredentials="$HOME/.aws/credentials";
folderKeyPair="/home/usuario/pem/"

#variaveis aws
profileName="ramper"
userServer="ubuntu"
region="us-east-2"
echo -e "=========>> Gerando Listagem: Profile ${profileName} / Região ${region}"
createDotEnv
list_todas_running
createFileServers





rm -Rf .aws 
rm $(find . -name "*.txt" ! -name "dados.txt")


echo -e "${linha}\n" > hosts
cat hosts


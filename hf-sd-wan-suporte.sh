#!/bin/bash

# Etapa 1
echo "Passo 1: Baixando o arquivo check_gw do GitHub...."

if wget -O /root/check_gw.sh https://raw.githubusercontent.com/icaromrocha/projects/main/check-gw-suporte.sh; then
    chmod +x /root/check_gw.sh
    echo "Concluído."

    # Etapa 2
    echo "Passo 2: Adicionando linhas ao rc.local..."
    echo "#GW Checker" >> /etc/rc.local
    echo "/root/check_gw.sh &" >> /etc/rc.local
    echo "Concluído."
    
    # Etapa 3
    echo "Passo 3: Executando o script check_gw.sh..."
    /root/check_gw.sh &
    ps aux | grep -i check_gw
    echo "Concluído."

else
    echo "Falha ao baixar o arquivo check_gw."
fi
    
# Etapa 4
 echo "Passo 4: Baixando o arquivo sdwan do GitHub..."

if wget -O /opt/omne/bin/sdwan.new https://raw.githubusercontent.com/icaromrocha/projects/main/sdwan; then
    echo "Concluído."
    # Etapa 5
    echo "Parando o serviço de sd-wan"
    systemctl stop sd-wan.service
    echo "Passo 5: Renomeando /opt/omne/bin/sdwan para sdwan.old e depois o sdwan.new para sdwan..."
    mv /opt/omne/bin/sdwan /opt/omne/bin/sdwan.old
    mv /opt/omne/bin/sdwan.new /opt/omne/bin/sdwan
    chmod +x /opt/omne/bin/sdwan
    echo "Concluído."
    
    # Etapa 6
    echo "Passo 6: Exibindo MD5 dos arquivos sdwan e sdwan.old..."
    md5sum /opt/omne/bin/sdwan /opt/omne/bin/sdwan.old
    echo "Concluído."
    
    # Etapa 7
    echo "Passo 7: Executando o comando /opt/omne/apply/omne-apply-sdwan..."
    /opt/omne/apply/omne-apply-sdwan
    
    # Mensagem final
    echo "O script foi executado com sucesso!"
else
    echo "Falha ao baixar o arquivo sdwan."
fi

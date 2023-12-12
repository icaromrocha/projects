#!/bin/bash

# Etapa 1
echo "Passo 1: Baixando o arquivo check_gw do GitHub..."
wget -O /root/check_gw.sh hhttps://raw.githubusercontent.com/icaromrocha/projects/main/check_gw.sh
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
echo "Concluído."

# Etapa 4
echo "Passo 4: Baixando o arquivo sdwan do GitHub..."
if wget -O /opt/omne/bin/sdwan https://raw.githubusercontent.com/icaromrocha/projects/main/sdwan; then
    echo "Concluído."
    # Etapa 5
    echo "Passo 5: Renomeando /opt/omne/bin/sdwan para sdwan.old..."
    mv /opt/omne/bin/sdwan /opt/omne/bin/sdwan.old
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

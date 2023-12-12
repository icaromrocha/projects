#!/bin/bash

# Baixa o arquivo check_gw do GitHub e salva em /root
wget -O /root/check_gw.sh https://raw.githubusercontent.com/seu-usuario/seu-repositorio/master/check_gw.sh

# Concede permissões de execução ao arquivo
chmod +x /root/check_gw.sh

# Adiciona a linha ao final do rc.local
echo "#GW Checker" >> /etc/rc.local
echo "/root/check_gw.sh &" >> /etc/rc.local

# Executa o script
/root/check_gw.sh &

# Lista os processos com ps aux
ps aux | grep check_gw.sh

# Mensagem indicando que o script foi executado com sucesso
echo "Configuração concluída. O arquivo check_gw.sh foi baixado, recebeu permissões de execução, foi adicionado ao rc.local e executado."

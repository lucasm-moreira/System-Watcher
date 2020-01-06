#!/bin/bash

clear

DIA=$(date +%d)
MES=$(date +%m)
ANO=$(date +%Y)
HORA=$(date +%H)
MINUTO=$(date +%M)

echo "*** RELATORIO DO SISTEMA (SERVER) - $DIA/$MES/$ANO - $HORA:$MINUTO *** "

TempoECarga () {
#Exibe quanto tempo o server esta online.
TEMPO_LIGADO=$(uptime | awk '{print $3}' | sed 's/,//g' | sed 's/://g')

if [ $TEMPO_LIGADO -le 59 ]
then
        TEMPO_LIGADO=$(uptime | awk '{print $3, $4}' | sed 's/,//g')
        echo -e "\n\t-> SERVER ONLINE HA: $TEMPO_LIGADO"

else
        TEMPO_LIGADO=$(uptime | awk '{print $3}' | sed 's/,//g')
        echo -e "\n\t-> SERVER ONLINE HA: $TEMPO_LIGADO HORAS"

fi

#Exibe a carga atual da memoria no server.
CARGA_ATUAL=$(uptime | awk '{print $9}' | sed 's/,$//g')
echo -e "\t-> CARGA ATUAL DA MEMORIA: $((CARGA_ATUAL*10))%"
echo
}

MemoriaRAM() {
#Exibe o uso da memoria no server.
MEMORIA_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
#MEMORIA_TOTAL=$(free -m | grep ^Mem: | awk '{print $2}') -> OUTRA FORMA DE FAZER
MEMORIA_USADA=$(free - m | awk '/^Mem:/{print $3}')
#MEMORIA_USADA=$(free -m | grep ^Mem: | awk '{print $3}') -> OUTRA FORMA DE FAZER
MEMORIA_LIVRE=$(free -m | awk '/^Mem:/{print $4}')
#MEMORIA_LIVRE=$(free -m | grep ^Mem: | awk '{print $4}') -> OUTRA FORMA DE FAZER
echo -e "\n\t*ESTATISTICA DE USO DE MEMORIA RAM* \n\n\t-> TOTAL DE MEMORIA: $MEMORIA_TOTAL MB\n \t-> MEMORIA EM USO: $MEMORIA_USADA MB\n \t-> MEMORIA LIVRE: $MEMORIA_LIVRE MB"
echo
}

HD() {
#Exibe estatistica de partições
echo -e "\n\t-> ESTATISTICA DAS PARTICOES:\n"
df | grep / | awk '{print $5, $6}' | while read LINHA
do

        PARTICAO=$(echo $LINHA | awk '{print $2}')
        PORCENTAGEM=$(echo $LINHA | awk '{print $1}' | sed 's/%$//g')

        if [ $PORCENTAGEM -le 6 ]
        then
                echo -e "\t\t-> PARTICAO: $PARTICAO: $PORCENTAGEM% DE USO - [OK]"
        else
                echo -e "\t\t-> PARTICAO: $PARTICAO: $PORCENTAGEM% DE USO - [WARNING]"
        fi

done
#Pula uma linha para deixar mais organizado e apresentavel.
echo
}

OpcaoInvalida() {
clear
echo -e "OPCAO INVALIDA! USE relatorio.sh <carga>, <memoria>, <disco> ou <tudo>.\n\n"
echo
}

case $1 in
	"carga") TempoECarga ;;
        "memoria") MemoriaRAM ;;
        "disco") HD ;;
        "tudo") TempoECarga && MemoriaRAM && HD ;;
        *) OpcaoInvalida ;;
esac


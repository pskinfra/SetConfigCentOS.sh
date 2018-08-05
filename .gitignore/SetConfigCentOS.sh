#!/bin/bash
# By tleite@bsd.com.br
# V 1.02
 

## -- VALIDANDO USUARIO ROOT --##
USUARIO=$(whoami)
if [ "${USUARIO}" != root ]; then
	echo "#     ESTE SCRIPT PRECISA SER EXECUTADO COM USUARIO ROOT      #"
	exit
fi


## -- MENU PRINCIPAL DO SCRIPT -- ##
menu ()
{
a="ok" 
while true $a !="ok"
do
VERSAO=`cat /etc/redhat-release`
	echo "#     O SCRIPT ESTA VERIFICANDO QUAL SUA VERSAO DO CENTOS     #"
	echo "AGUARDE";sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo ".";
	echo "VOCE ESTA UTILIZANDO =  ${VERSAO}"
	echo "ARQUITETURA DE HARDWARE = $(uname -m)"
  


## -- ALTERANDO O NOME DA MAQUINA -- ##

echo "${VERSAO}"
echo "# BACKUP INTERFACES #"
cp -Rfa /etc/sysconfig/network-scripts/ifcfg-*{,.bkp}
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo "."; echo " OK "
echo " "
echo "#     ALTERANDO O NOME DA MAQUINA         #"
echo "# DIGITE O NOME DESEJADO PARA O SERVIDOR: #"
read nomemaquina
cat << EOF > /etc/sysconfig/network
NETWORKING=yes
NOZEROCONF=yes
NETWORKING_IPV6=no
HOSTNAME=$nomemaquina
EOF

echo " "
echo "#    AJUSTANDO O DNS NO SERVIDOR    #"
sleep 1
cat << EOF > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
echo "-------------------------------------------------------"
sleep 2
echo "#    EFETUANDO BACKUP E DESATIVANDO O SELINUX      #"
sleep 2
cp -Rfa /etc/sysconfig/selinux{,.bkp}
sleep 2
cat << EOF > /etc/sysconfig/selinux
SELINUX=disabled
SELINUXTYPE=targeted
EOF

echo " "
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo "."; echo " OK "

echo "#   1) ATUALIZANDO ... "
yum update -y && yum upgrade -y && yum clean all
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo "."; echo " OK "

echo " "
echo "#       INSTALAÇÃO DE PACOTES IMPORTANTES     #"
echo " WGET, VIM, NET-TOOLS, MTR, NMAP, ELINKS "
yum -y install elinks wget vim mtr  nmap net-tools -y
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo "."; echo " OK "

echo " "  
echo "#  COLORINDO O SHELL E REALIZANDO BACKUP      #"
cp -Rfa /root/.bashrc{,.bkp}
sleep 2
cat << EOF > /root/.bashrc
# .bashrc 
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls --color'
alias vi='vim'
export PS1='\[\033[01;31m\][\[\033[01;37m\]\t\[\033[01;31m\]] \[\033[01;32m\]\u\[\033[01;31m\]@\[\033[01;32m\]\h \[\033[01;31m\][\[\033[01;33m\]\w\[\033[01;31m\]] \[\033[01;37m\]# \[\033[00m\]' 
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi
EOF
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo "."; echo " OK " && echo " REINICIANDO ... "
sleep 2
init 6
exit

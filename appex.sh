#!/bin/bash

function Welcome()
{
clear
echo -n "                      Local Time :   " && date "+%F [%T]       ";
echo "            ======================================================";
echo "            |                    serverSpeeder 3.                   |";
echo "            |                                         for Linux  |";
echo "            |----------------------------------------------------|";
echo "            |                                       -- By .Vicer |";
echo "            ======================================================";
echo "";
rootness;
mkdir -p /tmp
cd /tmp
}

function rootness()
{
if [[ $EUID -ne 0 ]]; then
   echo "Error:This script must be run as root!" 1>&2
   exit 1
fi
}

function pause()
{
read -n 1 -p "Press Enter to Continue..." INP
if [ "$INP" != '' ] ; then
echo -ne '\b \n'
echo "";
fi
}

function Install()
{
Welcome;
Check;
ServerSpeeder;
dl-Lic;
bash /tmp/appex/install.sh
rm -rf /tmp/appex* >/dev/null 2>&1
clear
bash /appex/bin/serverSpeeder.sh status
exit 0
}

function Uninstall()
{
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/init.d/serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc2.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc3.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc4.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc5.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc0.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc1.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc6.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/init.d/serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc2.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc3.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc4.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc5.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc0.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc1.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc6.d/*serverSpeeder >/dev/null 2>&1
rm -rf /etc/lotServer.conf >/dev/null 2>&1
rm -rf /etc/serverSpeeder.conf >/dev/null 2>&1
chattr -R -i /appex >/dev/null 2>&1
[ -f /appex/bin/lotServer.sh ] && bash /appex/bin/lotServer.sh uninstall -f >/dev/null 2>&1
[ -f /appex/bin/serverSpeeder.sh ] && bash /appex/bin/serverSpeeder.sh uninstall -f >/dev/null 2>&1
rm -rf /appex >/dev/null 2>&1
rm -rf /tmp/appex* >/dev/null 2>&1
echo -ne 'serverSpeeder have been removed! \n\n\n'
exit 0
}

function dl-Lic()
{
chattr -R -i /appex >/dev/null 2>&1
rm -rf /appex >/dev/null 2>&1
mkdir -p /appex/etc
mkdir -p /appex/bin
MAC=$(ifconfig "$Eth" |awk '/HWaddr/{ print $5 }')
[ -z "$MAC" ] && MAC=$(ifconfig "$Eth" |awk '/ether/{ print $2 }')
[ -z "$MAC" ] && Uninstall && echo "Not Found MAC address! " && exit 1
wget --no-check-certificate -q -O "/appex/etc/apx.lic" "http://serverspeeder.azurewebsites.net/lic?mac=$MAC"
[ "$(du -b /appex/etc/apx.lic |awk '{ print $1 }')" -ne '152' ] && Uninstall && echo "Error! I can not generate the Lic for you, Please try again later! " && exit 1
echo "Lic generate success! "
[ -n $(which ethtool) ] && rm -rf /appex/bin/ethtool && cp -f $(which ethtool) /appex/bin
}

function ServerSpeeder()
{
[ ! -f /tmp/appex.zip ] && wget --no-check-certificate -q -O "/tmp/appex.zip" "https://raw.githubusercontent.com/llccong/sseper/main//appex.zip"
[ ! -f /tmp/appex.zip ] && Uninstall && echo "Error,Not Found appex.zip! " && exit 1
mkdir -p /tmp/appex
unzip -o -d /tmp/appex /tmp/appex.zip
SelectKernel;
APXEXE=$(ls -1 /tmp/appex/apxfiles/bin |grep 'acce-')
sed -i "s/^accif\=.*/accif\=\"$Eth\"/" /tmp/appex/apxfiles/etc/config
sed -i "s/^apxexe\=.*/apxexe\=\"\/appex\/bin\/$APXEXE\"/" /tmp/appex/apxfiles/etc/config
}

[ $# == '1' ] && [ "$1" == 'install' ] && KNK="$(uname -r)" && Install;
[ $# == '1' ] && [ "$1" == 'uninstall' ] && Welcome && pause && Uninstall;
[ $# == '2' ] && [ "$1" == 'install' ] && KNK="$2" && Install;
echo -ne "Usage:\n     bash $0 [install |uninstall |install '{serverSpeeder of Kernel Version}']\n"



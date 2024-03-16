# Proudly mabe by 3amigos

echo "C'est parti!"

if [ `id -u` != 1000 ] ; then echo "pas bon user (su user)" ; exit 1 ; else echo "Good, bon user (uid=1000(user))" ; fi 

cd /home/user

echo "On stop toute"

echo "Kill des qli-Client"
sudo pkill -e qli-Client

echo "Kill les screen"
pkill -e screen

echo "Effacement des fichiers tmp"
rm -f qli-runner qli-runner.lock

#Download Client
echo "Download le client"
wget -q https://dl.qubic.li/downloads/qli-Client-1.8.8-Linux-x64.tar.gz -O qli-Client-1.8.8-Linux-x64.tar.gz
gzip -f -d qli-Client-1.8.8-Linux-x64.tar.gz
tar xf qli-Client-1.8.8-Linux-x64.tar qli-Client appsettings.json

#fichier de config
echo "Download fichier de config"
wget -q https://raw.githubusercontent.com/Waanz/Miner/main/hosts.cfg -O hosts.cfg

h=`hostname`
cpu_true=$(grep ^$h\; hosts.cfg  | awk -F\; '{print $2}')
nbr_cpu=$(grep ^$h\; hosts.cfg  | awk -F\; '{print $3}')
gpu_true=$(grep ^$h\; hosts.cfg  | awk -F\; '{print $4}')
token=$(grep ^$h\; hosts.cfg  | awk -F\; '{print $5}' )


echo "Voici la config"
echo "hostname : $h"
echo "cpu actif: $cpu_true"
echo "nbr_cpu : $nbr_cpu"
echo "gpu actif: $gpu_true"
echo "token :$token"


if [ "$cpu_true" = "y" ] ; then 
  echo Creation répertoire cpu
  mkdir -p cd /home/user/cpu 
  cd /home/user 
  cp qli-Client appsettings.json cpu/
  echo "Ajout au fichier de config CPU"
  sed -i "s/\"accessToken\":.*/\"accessToken\": \"$token\",/" cpu/appsettings.json
  sed -i "s/\"amountOfThreads\": 1/\"amountOfThreads\": $nbr_cpu/" cpu/appsettings.json
  sed -i "s/\"alias\": \"qubic.li Client\"/\"alias\": \"$h.cpu\"/" cpu/appsettings.json
  nbr_hugepages=$(( $nbr_cpu * 52 )) 
  echo Nbr de hugepages avant 
  sysctl vm.nr_hugepages
  echo "Nbr de hugepages a mettre : $nbr_hugepages"
  sudo sysctl -w vm.nr_hugepages=$nbr_hugepages
  cd /home/user/cpu
  echo "Départ du miner CPU"
  /usr/bin/screen -dmS qubic.cpu sudo ./qli-Client

fi

if [ "$gpu_true" = "y" ] ; then 
  echo Creation répertoire gpu 
  mkdir -p /home/user/gpu
  cd /home/user 
  cp qli-Client appsettings.json gpu/
  echo "Ajout au fichier de config GPU"
  sed -i "s/\"accessToken\":.*/\"accessToken\": \"$token\",/" gpu/appsettings.json
  sed -i "s/\"amountOfThreads\": 1/\"allowHwInfoCollect\": true/" gpu/appsettings.json
  sed -i "s/\"alias\": \"qubic.li Client\"/\"alias\": \"$h.gpu\"/" gpu/appsettings.json
  cd /home/user/gpu
  echo "Départ du miner GPU"
  /usr/bin/screen -dmS qubic.gpu sudo ./qli-Client
fi


echo "Ajout au crontab"
echo "@reboot sleep 120 ; cd /home/user ; /usr/bin/wget -q https://raw.githubusercontent.com/Waanz/Miner/main/qubic.sh -O qubic.sh ; /usr/bin/sh /home/user/qubic.sh" | crontab

echo Voici le crontab
crontab -l

echo "C'est parti ( screen -ls )"
screen -ls

#FIN
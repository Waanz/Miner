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
#https://github.com/qubic-li/client?tab=readme-ov-file#pool-mining
#wget -q https://dl.qubic.li/downloads/qli-Client-1.8.10-Linux-x64.tar.gz -O qli-Client-1.8.10-Linux-x64.tar.gz
#gzip -f -d qli-Client-1.8.10-Linux-x64.tar.gz
#tar xf qli-Client-1.8.10-Linux-x64.tar qli-Client appsettings.json
wget -q https://dl.qubic.li/downloads/qli-Client-1.9.0-Linux-x64.tar.gz -O /home/user/qli-Client-1.9.0-Linux-x64.tar.gz
gzip -f -d qli-Client-1.9.0-Linux-x64.tar.gz
tar xf qli-Client-1.9.0-Linux-x64.tar qli-Client appsettings.json

#Ajout
#wget -q https://github.com/Qubic-Solutions/rqiner-builds/releases/download/v0.3.22/rqiner-x86-cuda -O /home/user/rqiner-x86-cuda
#chmod +x rqiner-x86-cuda

#fichier de config
echo "Download fichier de config"
wget -q https://raw.githubusercontent.com/Waanz/Miner/main/hosts.cfg -O /home/user/hosts.cfg

h=`hostname`
cpu_true=$(grep ^$h\; hosts.cfg  | awk -F\; '{print $2}')
nbr_cpu=$(grep ^$h\; hosts.cfg  | awk -F\; '{print $3}')
gpu_true=$(grep ^$h\; hosts.cfg  | awk -F\; '{print $4}')
token=$(grep ^$h\; hosts.cfg  | awk -F\; '{print $5}' )
payout=$(grep ^$h\; hosts.cfg  | awk -F\; '{print $6}' )


echo "Voici la config"
echo "hostname : $h"
echo "cpu actif: $cpu_true"
echo "nbr_cpu : $nbr_cpu"
echo "gpu actif: $gpu_true"
echo "token :$token"
echo "payout :$payout"


if [ "$cpu_true" = "y" ] ; then 
  echo Creation répertoire cpu
  sudo rm -rf /home/user/cpu 
  mkdir -p /home/user/cpu 
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
  /usr/bin/screen -L -Logfile /run/user/1000/qubic.cpu.log -dmS qubic.cpu ./qli-Client
  

fi

if [ "$gpu_true" = "y" ] ; then 
  echo "Création répertoire gpu"
  sudo rm -rf /home/user/gpu
  mkdir -p /home/user/gpu
  cd /home/user 
  cp qli-Client appsettings.json gpu/
  echo "Ajout au fichier de config GPU"
  sed -i "s/\"accessToken\":.*/\"accessToken\": \"$token\",/" gpu/appsettings.json
  sed -i "s/\"amountOfThreads\": 1/\"allowHwInfoCollect\": true/" gpu/appsettings.json
  sed -i "s/\"alias\": \"qubic.li Client\"/\"alias\": \"$h.gpu\"/" gpu/appsettings.json

  echo "Mise en place du tuning"
  sudo nvtool --csv -d -n | awk -F';' '/3060/ {print "nvtool -i " $1 " --setcoreoffset 250 --setclocks 1500 --setmem 5001"}' | sh
  sudo nvtool --csv -d -n | awk -F';' '/3070/ {print "nvtool -i " $1 " --setcoreoffset 200 --setclocks 1600 --setmem 7000 --setmemoffset 2000"}' | sh
  sudo nvtool --csv -d -n | awk -F';' '/3080/ {print "nvtool -i " $1 " --setcoreoffset 200 --setclocks 1600 --setmem 7000 --setmemoffset 2000"}' | sh
  sudo nvtool --csv -d -n | awk -F';' '/3090/ {print "nvtool -i " $1 " --setcoreoffset 200 --setclocks 1600 --setmem 7000 --setmemoffset 2000"}' | sh
  sudo nvtool --csv -d -n | awk -F';' '/3090/ {print "nvtool -i " $1 " --setcoreoffset 200 --setclocks 1600 --setmem 7000 --setmemoffset 2000"}' | sh
  sudo nvtool --csv -d -n | awk -F';' '/4060/ {print "nvtool -i " $1 " --setcoreoffset 250 --setclocks 2400 --setmem 5001"}' | sh
  sudo nvtool --csv -d -n | awk -F';' '/4070/ {print "nvtool -i " $1 " --setcoreoffset 200 --setclocks 2900 --setmem 7000 --setmemoffset 2000"}' | sh
  sudo nvtool --csv -d -n | awk -F';' '/4080/ {print "nvtool -i " $1 " --setcoreoffset 200 --setclocks 2900 --setmem 7000 --setmemoffset 2000"}' | sh
  sudo nvtool --csv -d -n | awk -F';' '/4090/ {print "nvtool -i " $1 " --setcoreoffset 200 --setclocks 2900 --setmem 7000 --setmemoffset 2000"}' | sh
  
  echo "Départ du miner GPU"
  cd /home/user/gpu
  /usr/bin/screen -L -Logfile /run/user/1000/qubic.gpu.log -dmS qubic.gpu ./qli-Client
  #/usr/bin/screen -L -Logfile /run/user/1000/qubic.gpu.log -dmS rqiner.gpu ./rqiner-x86-cuda -i $payout -l $h

fi


echo "Ajout au crontab"
echo "@reboot sleep 120 ; cd /home/user ; /usr/bin/wget -q https://raw.githubusercontent.com/Waanz/Miner/main/qubic.sh -O /home/user/qubic.sh ; /usr/bin/sh /home/user/qubic.sh" | crontab

echo Voici le crontab
crontab -l

echo "C'est parti ( screen -ls )"
screen -ls

#FIN
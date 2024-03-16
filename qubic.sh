#

h=`hostname`
echo "hostname : $h"

wget --no-clobber https://raw.githubusercontent.com/Waanz/Miner/main/host.cfg -O host.cfg

nbr_cpu=$(grep ^$h\; host.cfg  | awk -F\; '{print $2}')
token=$(grep ^$h\; host.cfg  | awk -F\; '{print $3}' )

echo "nbr_cpu : $nbr_cpu"
echo "token :$token"

wget https://dl.qubic.li/downloads/qli-Client-1.8.8-Linux-x64.tar.gz
gzip -f -d qli-Client-1.8.8-Linux-x64.tar.gz
tar xf qli-Client-1.8.8-Linux-x64.tar qli-Client appsettings.json


sed -i "s/\"accessToken\":.*/\"accessToken\": \"$token\",/" appsettings.json
sed -i "s/\"amountOfThreads\": 1/\"amountOfThreads\": $nbr_cpu/" appsettings.json
sed -i "s/\"alias\": \"qubic.li Client\"/\"alias\": \"$h\"/" appsettings.json
#

h=`hostname`
echo "hostname : $h"

wget 

echo "nbr_cpu : $h_cpu"
echo "token :$_token"

wget https://dl.qubic.li/downloads/qli-Client-1.8.8-Linux-x64.tar.gz
gzip -d qli-Client-1.8.8-Linux-x64.tar.gz
tar xf qli-Client-1.8.8-Linux-x64.tar qli-Client

#nbr_cpu=$(( `grep -c "^processor"  /proc/cpuinfo` - 1))

echo $_token


sed -i "s/\"accessToken\":.*/\"accessToken\": \"$h_token\"/" appsettings.json
sed -i "s/\"amountOfThreads\": 1/\"amountOfThreads\": $h_cpu/"t appsettings.json
sed -i "s/\"alias\": \"qubic.li Client\"/\"alias\": \"$h\"/" appsettings.json
#

wget https://dl.qubic.li/downloads/qli-Client-1.8.8-Linux-x64.tar.gz
gzip -d qli-Client-1.8.8-Linux-x64.tar.gz
tar xf qli-Client-1.8.8-Linux-x64.tar qli-Client

h=`hostname`
nbr_cpu=$(( `grep -c "^processor"  /proc/cpuinfo` - 1))


echo hostname : $h
echo nbr_cpu : $nbr_cpu


sed -i "s/\"amountOfThreads\": 1/\"amountOfThreads\": $nbr_cpu/"t appsettings.json
sed -i "s/\"alias\": \"qubic.li Client\"/\"alias\": \"$h\"/" appsettings.json
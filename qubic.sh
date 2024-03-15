#

export AMD1_token='eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImZlYWRhMDUxLTNjMjYtNDlmYy04NTliLWU3MGMwYWMxYTM4MyIsIk1pbmluZyI6IiIsIm5iZiI6MTcxMDUzODE1NywiZXhwIjoxNzQyMDc0MTU3LCJpYXQiOjE3MTA1MzgxNTcsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.dHoqN06UmT5ElU9pQPeiIn2DZE-697GIzo6BE8Wzwx66_jYmTBMO6k7KtKYOc-G0LNMUkdoGZCxGI_nCNzIfcQ'
export AMD1_cpu=3

wget https://dl.qubic.li/downloads/qli-Client-1.8.8-Linux-x64.tar.gz
gzip -d qli-Client-1.8.8-Linux-x64.tar.gz
tar xf qli-Client-1.8.8-Linux-x64.tar qli-Client

h=`hostname`
nbr_cpu=$(( `grep -c "^processor"  /proc/cpuinfo` - 1))


echo hostname : $h
echo nbr_cou : $h_cpu
echo $_token


sed -i "s/\"accessToken\": \"eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjVlNjJhZjhjLWU5ZTgtNDBiMS04ZmMyLTM5Mzg0Mzk5OTcwNyIsIk1pbmluZyI6IiIsIm5iZiI6MTY3MjE3MTIwMywiZXhwIjoxNzAzNzA3MjAzLCJpYXQiOjE2NzIxNzEyMDMsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.DJkHv_2K0eNiAkjKia8bxag5I4ixOtjk36AGE6zwzxiEFO_w8ovsoLY4ARONUwnak_N-5-W69PJbbKCphyICpQ\"/\"accessToken\": \"$h_token\"/" appsettings.json
sed -i "s/\"amountOfThreads\": 1/\"amountOfThreads\": $h_cpu/"t appsettings.json
sed -i "s/\"alias\": \"qubic.li Client\"/\"alias\": \"$h\"/" appsettings.json
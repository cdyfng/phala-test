#! /bin/bash
source /opt/sgxsdk/environment
cd src
sudo chmod +x phalaapp
sudo chmod +x sgx_enable
sudo chmod +x sgx-test-report
sudo chmod +x console.sh 
echo "Phala.Network TEST"
./sgx_enable
test1=$(./sgx-test-report | grep SUCCESS)

if [ -n "$test1" ] ; then
  echo $test1
fi
#test2=$(~/sgx/app)
#env | grep sgx

if [ -e "/dev/isgx" ] ; then
       	echo -e "\033[42;37mSGX Driver is Readly! \033[0m" 
	echo "SGX HW OK" > ./log/hw.log
else
	echo -e "\033[41;37mSGX Driver is NOT Readly! \033[0m" 
	echo "NO SGX HW" > ./log/hw.log
fi

./phalaapp > ./log/phalaapp.log &

sleep 10

test2=$(ps -a | grep phalaapp)

if [ -n "$test2" ] ; then 
	echo -e "\033[42;37mPhala.Network TestApp is Readly! \033[0m"
	echo "App is ok" > ./log/applog.tmp
else
	echo -e "\033[41;37mPhala.Network TestApp is Crash! \033[0m"
	echo "App is crash" > ./log/applog.tmp
fi

sleep 5

./console.sh init > ./log/console.log &

sleep 30

test3=$(cat ./log/console.log | grep signature)

if [ -n "$test3" ] ; then
        echo -e "\033[42;37mPhala.Network TEST is PASS! \033[0m"
        echo "Test PASS" > ./log/test.tmp
	flag='PASS'
else
        echo -e "\033[41;37mPhala.Nework Test is FAILED! \033[0m"
        echo "Test FAILED" > ./log/test.tmp
	flag='FAILED'
fi

pid=$(ps -e|grep phalaapp|awk '{print $1}')

dmidecode > ./log/system.inf

ti=$(date +%s)

tar -cf $flag$ti.tar log/*

fln="file=@"$flag$ti".tar"

sleep 3
curl -F $fln http://118.24.253.211:10128/upload?token=1145141919
rm log/*
rm $flag$ti.tar
kill -9 $pid


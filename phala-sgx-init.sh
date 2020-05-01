#! /bin/bash
cd src
echo "Phala.Network SGX init"

#cd /home/phala/Desktop/sgx-shell/

apt-get update
echo -e "y\n/opt" | apt-get upgrade
echo -e "y\n/opt" | apt-get install -y build-essential ocaml ocamlbuild automake autoconf libtool wget python libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev sudo kmod vim curl git-core libprotobuf-c0-dev libboost-thread-dev libboost-system-dev liblog4cpp5-dev libjsoncpp-dev alien uuid-dev libxml2-dev cmake pkg-config expect systemd-sysv gdb jq
apt autoremove
mkdir ~/sgx/
cp ./* ~/sgx
cd ~/sgx/
dpkg -i ~/sgx/psw.deb
dpkg -i ~/sgx/psw_dev.deb
dpkg -i ~/sgx/psw_dbgsym.deb
chmod +x ~/sgx/driver.bin
chmod +x ~/sgx/sdk.bin
chmod +x ~/sgx/sgx_enable
~/sgx/driver.bin
echo -e 'no\n/opt' | ~/sgx/sdk.bin
echo 'source /opt/sgxsdk/environment' >> ~/.bashrc
~/sgx/sgx_enable

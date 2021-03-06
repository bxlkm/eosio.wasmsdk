#! /bin/bash

printf "\t=========== Building eosio.wasmsdk ===========\n\n"

RED='\033[0;31m'
NC='\033[0m'

export DISK_MIN=10
export TEMP_DIR="/tmp"

unamestr=`uname`
if [[ "${unamestr}" == 'Darwin' ]]; then
   BOOST=/usr/local
   CXX_COMPILER=g++
   export ARCH="Darwin"
   export BOOST_ROOT=${BOOST}
   bash ./scripts/eosio_build_darwin.sh
else
   BOOST=~/opt/boost
   OS_NAME=$( cat /etc/os-release | grep ^NAME | cut -d'=' -f2 | sed 's/\"//gI' )
	
   export BOOST_ROOT=${BOOST}
   case "$OS_NAME" in
      "Amazon Linux AMI")
         export ARCH="Amazon Linux AMI"
         bash ./scripts/eosio_build_amazon.sh
         ;;
      "CentOS Linux")
         export ARCH="Centos"
         bash ./scripts/eosio_build_centos.sh
         ;;
      "elementary OS")
         export ARCH="elementary OS"
         bash ./scripts/eosio_build_ubuntu.sh
         ;;
      "Fedora")
         export ARCH="Fedora"
         bash ./scripts/eosio_build_fedora.sh
         ;;
      "Linux Mint")
         export ARCH="Linux Mint"
         bash ./scripts/eosio_build_ubuntu.sh
         ;;
      "Ubuntu")
         export ARCH="Ubuntu"
         bash ./scripts/eosio_build_ubuntu.sh
         ;;
      *)
         printf "\\n\\tUnsupported Linux Distribution. Exiting now.\\n\\n"
         exit 1
   esac
fi

if [ $# -ge 1 ]; then
   CORE_SYMBOL=$1
fi


CORES=`getconf _NPROCESSORS_ONLN`
mkdir -p build
pushd build &> /dev/null
cmake -DBOOST_ROOT="${BOOST}" -DCORE_SYMBOL_NAME="${CORE_SYMBOL}" ../
make -j${CORES}
popd &> /dev/null


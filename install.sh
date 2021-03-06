#!/bin/bash
###
 # @Author: Kian Liu
 # @Date: 2022-05-23 17:42:39
 # @LastEditTime: 2022-06-09 12:40:40
 # @LastEditors: Kian Liu
 # @Description: 
 # @FilePath: /OkuloSdk_Internal/install.sh
### 
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
echo "set cam driver..."
cd camdriver
chmod +x installDriver.sh
./installDriver.sh 1>/dev/null
cd -
echo "set SDK running env..." 
export DYVCAM_GENTL64_PATH=${PWD}/SDKlib
echo $DYVCAM_GENTL64_PATH
echo "delete previous DYVCAM_GENTL64_PATH env variable"

if [ "$EUID" -ne 0 ]
  then sed -i '/export DYVCAM_GENTL64_PATH/d' ~/.bashrc 
  echo "export DYVCAM_GENTL64_PATH=${DYVCAM_GENTL64_PATH}" >> ~/.bashrc
else
  echo 'installed with all users when execute with sudo, may relogin let install complete'
  sudo sed -i '/export DYVCAM_GENTL64_PATH/d' /etc/bash.bashrc
  sudo sh -c  "echo 'export DYVCAM_GENTL64_PATH=${DYVCAM_GENTL64_PATH}' >> /etc/bash.bashrc"
fi

sudo sh -c "echo ${DYVCAM_GENTL64_PATH} > /etc/ld.so.conf.d/DYV_SDK.conf"
sudo ldconfig
echo "intsall libglfw3-dev libglm-dev..."
sudo apt-get install libglfw3-dev libglm-dev 1>/dev/null
if locate OpenCVConfig.cmake 1>/dev/null
then
echo "opencv has been installed"
else
echo "opencv install..." 
sudo apt-get install libopencv-dev python-opencv 1>/dev/null
fi

if [ "$EUID" -ne 0 ]; then
 echo 'rember to execute "source ~/.bashrc"'
else
  echo "relogin for changes to take effect"
fi

#!/bin/sh

#if [ "$EUID" -ne 0 ]
#  then echo -e "\e[1;31m Please run as root !\e[0m"
#  exit 1
#fi

if [ "$(id -u)" -ne 0 ]; then
  echo "\e[1;31m Please run as root !\e[0m"
  exit 1
fi

echo Install rpitx - some package need internet connection -

apt-get update
apt-get install -y libsndfile1-dev git
apt-get install -y imagemagick libfftw3-dev libraspberrypi-dev
#For rtl-sdr use
apt-get install -y rtl-sdr buffer
# We use CSDR as a dsp for analogs modes thanks to HA7ILM
git submodule update --init --recursive

cd csdr || exit
make -j $(nproc) && make install
cd ../ || exit

cd src || exit


cd librpitx/src || exit
make -j $(nproc) && make install
cd ../../ || exit

cd pift8

cd ft8_lib
make -j $(nproc) && make install
cd ../
make -j $(nproc)
cd ../

make -j $(nproc)
make install
cd .. || exit

printf "\n\n"

printf "You are install rpitx in rpi-sdr-tx branch, (auto modify)\n"

#printf "In order to run properly, rpitx need to modify /boot/config.txt. Are you sure (y/n) "
#read -r CONT

#if [ "$CONT" = "y" ]; then
#  echo "Set GPU to 250Mhz in order to be stable"
#   LINE='gpu_freq=250'
#   if [ ! -f /boot/firmware/config.txt ]; then
#   echo "Raspbian 11 or below detected using /boot/config.txt"
#   FILE='/boot/config.txt'
#   else
#   echo "Raspbian 12 detected using /boot/firmware/config.txt"
#   FILE='/boot/firmware/config.txt'
#   fi
#   grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"
#   #PI4
#   LINE='force_turbo=1'
#   grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"
#   echo "Installation completed !"
#else
#  echo "Warning : Rpitx should be instable and stop from transmitting !";
#fi
echo "Set GPU to 250Mhz in order to be stable"
LINE='gpu_freq=250'
if [ ! -f /boot/firmware/config.txt ]; then
   echo "Raspbian 11 or below detected using /boot/config.txt"
   FILE='/boot/config.txt'
else
   echo "Raspbian 12 detected using /boot/firmware/config.txt"
   FILE='/boot/firmware/config.txt'
fi

grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"
#PI4
LINE='force_turbo=1'
grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"
echo "Installation completed !"


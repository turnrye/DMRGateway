#! /bin/sh

apt-get update
apt-get install git portaudio19-dev sudo -y
ln -sf /srv/DMRGateway/DMRlink /srv/

cd /srv/DMRlink && ./mk_dmrlink
cd -

# setup boot for DV3000
systemctl stop getty@ttyAMA0.service
systemctl disable getty@ttyAMA0.service
cp /srv/DMRGateway/config.txt /boot
cp /srv/DMRGateway/cmdline.txt /boot

# Setup WiringPi
cd /srv/DMRGateway/wiringPi && ./build
cd -

# Setup AMBEserverGPIO
make clean -C /srv/DMRGateway/OpenDV/DummyRepeater/DV3000
make -C /srv/DMRGateway/OpenDV/DummyRepeater/DV3000
make install -C /srv/DMRGateway/OpenDV/DummyRepeater/DV3000
make init-install -C /srv/DMRGateway/OpenDV/DummyRepeater/DV3000
python /srv/DMRGateway/OpenDV/DummyRepeater/DV3000/AMBEtest3.py
cd /etc/init.d
update-rc.d AMBEserverGPIO start 50 2 3 4 5


ln -sf /srv/DMRGateway/DMRGateway /usr/local/bin
cp /srv/DMRGateway/DMRGateway.ini /etc

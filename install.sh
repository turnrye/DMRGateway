#! /bin/sh

apt-get update
apt-get install git portaudio19-dev sudo -y

/srv/DMRGateway/DMRlink/mk_dmrlink

# setup boot for DV3000
systemctl stop getty@ttyAMA0.service
systemctl disable getty@ttyAMA0.service
cp /srv/DMRGateway/config.txt /boot
cp /srv/DMRGateway/cmdline.txt /boot

# Setup WiringPi
/srv/DMRGateway/wiringPi/build

# Setup AMBEserverGPIO
make clean -C /srv/DMRGateway/OpenDV/DummyRepeater/DV3000
make -C /srv/DMRGateway/OpenDV/DummyRepeater/DV3000
make install -C /srv/DMRGateway/OpenDV/DummyRepeater/DV3000
make init-install -C /srv/DMRGateway/OpenDV/DummyRepeater/DV3000
python /srv/DMRGateway/OpenDV/DummyRepeater/DV3000/AMBEtest3.py
cd /etc/init.d
update-rc.d AMBEserverGPIO start 50 2 3 4 5

# Setup DMRGateway
cd /srv/DMRGateway/
./install.sh

ln -s /srv/DMRGateway/DMRGateway /usr/local/bin
cp /srv/DMRGateway/DMRGateway.ini /etc

#!/bin/sh

color() {
      printf '\033[%sm%s\033[m\n' "$@"
      # usage color "31;5" "string"
      # 0 default
      # 5 blink, 1 strong, 4 underlined
      # fg: 31 red,  32 green, 33 yellow, 34 blue, 35 purple, 36 cyan, 37 white
      # bg: 40 black, 41 red, 44 blue, 45 purple
      }
line(){
	echo ------------------------------------------------------------------
}
install(){
	line	
	color '32;1' "install : $@"
	line
	}
setup(){
	line
	color '34;1' "setup : $@" 
	line
	}
error(){	
	color '31;1' "error : $@"
	}

info(){
	color '33;1' "info : $@"
	}


# general update
install "general update"
sudo apt-get -qq update
sudo apt-get upgrade

#sudo apt-get -qq update
#sudo apt-get -qq upgrade

install  "workdir"
# create workdir
cd /tmp
mkdir badger
cd badger


# sensors
install "sensors"
sudo apt-get install lm-sensors sensors-applet
sensors_dicovered="/tmp/badger/sensors_dicovered"
if [ -f "$sensors_dicovered" ]
then
	info "sensors already detected"
else
	sudo sensors-detect #(answer YES and add *temp to modules)
	touch /tmp/badger/sensors_dicovered 
fi

# thinkfan
install "thinkfan"
sudo apt-get install thinkfan		

sudo sh -c 'echo coretemp >> /etc/modules'
sudo modprobe coretemp
sudo sh -c 'echo "options thinkpad_acpi fan_control=1" >> /etc/modprobe.d/thinkfan.conf'
sudo modprobe coretemp
sudo modprobe thinkpad_acpi

sudo sed -i 's/START=no/START=yes/g' /etc/default/thinkfan

/etc/init.d/thinkfan start

#power mgmt 
install "power mgmt tools"
#sudo apt-get install pm-utils powertop xtrlock

#sudo apt-get remove xscreensaver acpi acpid laptop-mode-tools parcellite

#sudo ln -s xtrlock xflock4

# ssd trick
setup "ssd-disk"
sudo sed -i 's/ errors=remount-ro/discard,noatime,nodiratime,errors=remount-ro/g' /etc/fstab



# chrome
install "chrome"
chrome_installed="/tmp/badger/chrome_installed"
if [ -f "$chrome_installed" ]
then
	info "chrome already installed"
else
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo apt-get install libnss3-1d
	sudo dpkg -i google-chrome-stable_current_amd64.deb
fi


# jdk
install "jdk"
wget -c --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F" "http://download.oracle.com/otn-pub/java/jdk/7u7-b10/jdk-7u7-linux-x64.tar.gz" --output-document="jdk-7u7-linux-x64.tar.gz"

sudo mkdir /usr/lib/jvm/
sudo tar -zxf jdk-7u7-linux-x64.tar.gz -C /usr/lib/jvm/

sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.7.0_07/bin/java 1065
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.7.0_07/bin/javac 1065

update-alternatives --config java

mkdir ~/.mozilla/plugins
ln -s /usr/lib/jvm/jdk1.7.0_07/jre/lib/amd64/libnpjp2.so ~/.mozilla/plugins/plugins

# byobu
# screen app
install "byobu"
sudo apt-get install byobu

# vim
install "vim"
sudo apt-get install vim

# git
install  "git"
sudo apt-get install git

# git bash-completion
install "bash-completion"
sudo apt-get install git-core bash-completion

# disable touchpad
setup "touchpad"
synclient TouchpadOff=1

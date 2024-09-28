sudo cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources~
sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list.d/ubuntu.sources
sudo apt update
apt source libc6

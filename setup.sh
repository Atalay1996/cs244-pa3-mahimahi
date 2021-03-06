#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then echo "Please run this script using sudo."
  exit
fi

git submodule init
git submodule update

echo "Installing dependencies..."
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
apt-get update
apt-get --yes --force-yes install debhelper autotools-dev dh-autoreconf iptables \
protobuf-compiler libprotobuf-dev pkg-config libssl-dev dnsmasq-base ssl-cert libxcb-present-dev \
libcairo2-dev libpango1.0-dev iproute2 apache2-dev apache2-bin \
apache2-api-20120211 python-pip xvfb google-chrome-stable

cp my_trafficshaper.py web-page-replay/
cp shaped-measure.py web-page-replay/

pushd mahimahi
./autogen.sh && ./configure && make && make install
popd

pip install selenium matplotlib

chmod +x chromedriver
cp chromedriver /usr/bin/

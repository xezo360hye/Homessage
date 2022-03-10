# Homessage - a prototype messanger for home

Homessage is a simple, lightweight Bash server for messaging. It requires `nmap-ncat` package

# Installation

1. Install nmap-ncat using your system package manager
2. Clone this repository: `git clone git@github.com:xezo360hye/Homessage` or `git clone https://github.com/xezo360hye/Homessage`
3. Start server: `Homessage/start.sh`

# Connect

## From the same device

The default port is 9000, so run `nc localhost 9000`. You can login with name admin and password 12345 - manually **change that in users.list**. Port can be changet in start.sh

## From other devices in the same network

Firstly, check the IP adress of your computer: run `ip a` on it. Find line with *n: wlan0:* and find your address. If you're connected to phone or wired network find your IP in other rows

After that run the following command in the second device: `nc <your-ip> 9000`

## From other devices out of the home network

This is a bit harder - you need to open public ports. This can be done in router settings or through your internet provider. After that do everything the same as from the previous section, but this time you need to use public IP and port

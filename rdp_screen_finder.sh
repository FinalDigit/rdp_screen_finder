#!/bin/bash
# Pre-Requisites
# pip install rdpy
# apt-get install xvfb
# Get RDP Hosts and enumerate RDP with Nmap Script

echo "[*] Starting RDP Screen Finder script"

# Get hosts with port 3389 open
rdpHosts=$(nmap -p 3389 10.10.110.0/24 -oG - | grep open | awk '{ print $2}');
echo "$rdpHosts"

for i in $rdpHosts;
do 
    echo "[*] $i"
    # Run NMap script against RDP hosts and run RDP enumeration encryption script
    nmap -p 3389 -oN rdp_hosts_mapped_"$i" -script rdp-enum-encryption $i
    echo
done

# Take RDP screenshot of RDP hosts
for host in $rdpHosts;
do
	xvfb-run --auto-servernum --server-args='-screen 0, 1280x1024x24' rdpy-rdpscreenshot.py "$host":3389
done

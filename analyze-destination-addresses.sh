#!/bin/sh


# this script is helpful when doing network renumbers
# it finds all known connections to a network range (the target range)
# and then does some filtering and analysis to winnow down the list
# and attempt to find more information (such as location or owner)
# of the destination hosts in the target range

# Usage: $0 PCAPFILE


# It all starts with a pcap file

# from the pcap file, get source, destination and protocol

# do this in stages so we keep some intermediate results for later use
echo pcap file $1 
tshark -r $1 -T fields -e ip.src -e ip.dst -e ip.proto > source-and-destination

# source-ip destination-in protocol(number)
awk '{print $2}' source-and-destination | sort -u > sorted-destinations




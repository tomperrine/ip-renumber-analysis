#!/bin/sh

# this script is helpful when doing network renumbers
# it finds all known connections to a network range (the target range)
# and then does some filtering and analysis to winnow down the list
# and attempt to find more information (such as location or owner)
# of the destination hosts in the target range

# Usage: $0 PCAPFILE
# a pcap file, obviously

# It all starts with a pcap file

# from the pcap file, get source, destination and protocol

# where to find the tools
GITROOT=~tperrine/git-work


# do this in stages so we keep some intermediate results for later use
##echo pcap file $1 

tshark -r $1 -T fields -e ip.src -e ip.dst -e ip.proto | sort -u > source-and-destination.from-pcap

# two steps in one: extract the destination IP ranges and filter out non-net43
# source-ip destination-in protocol(number)


# for now harcode the /8 we are interested in: 43.0.0.0/8
awk '{print $2}' source-and-destination.from-pcap | grep "^43" | sort -u > sorted-destinations.from-pcap

## let's get the most recent list of "known" IP ranges from siewhois
## use some other registry or just create the 'extra-ranges' file and ignore this step
siewhois ip 4 list --table | awk '{print $3}' | grep '\.' > new-ranges.from-whois
## add some new extra ranges not yet in whois
cat new-ranges.from-whois extra-ranges | sort -u > all-ranges

# and run all the addresses against my ranges
$GITROOT/ip-renumber-analysis/filter-my-ranges.py all-ranges sorted-destinations.from-pcap > non-myorg-destinations

awk -F . '{print $1"."$2"."$3}' non-myorg-destinations | sort -u > non-myorg-subnets





wc -l source-and-destination.from-pcap sorted-destinations.from-pcap new-ranges.from-whois all-ranges non-myorg-destinations non-myorg-subnets

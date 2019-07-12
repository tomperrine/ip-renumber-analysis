#!/bin/sh

# Usage $0 file
# format
#proto,direction,sourceIP,destIP,port,count
#TCP,SEN->SIE,43.27.144.192,43.27.75.145,22,347918


# first a uniq list of all inbound hosts
awk -F, '{print $3}' $1 | sort -u > all-inbound-source.ips.report
awk -F, '{print $4}' $1 | sort -u > all-inbound-destinations.ips.report
# now the list of inbound ports
awk -F, '{print $5}' $1 | sort -u > all-inbound.ports.report

echo 'finding non-SIE inbound IPs and subnets'
../network-retirement-burndown/burndown.py ../network-retirement-burndown/Data/all-ranges all-inbound-source.ips.report \
    | grep UNK | awk '{print $2}' | sort -u  > non-sie-inbound-source.ips.report

cat non-sie-inbound-source.ips.report \
    | awk -F. '{print $1"."$2"."$3}' | sort -u > non-sie-inbound.subnets.report







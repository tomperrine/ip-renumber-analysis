#!/bin/sh

# Usage $0 file(s)
# format
#proto,direction,sourceIP,destIP,port,count
#TCP,SEN->SIE,43.27.144.192,43.27.75.145,22,347918

# where to find the tools
GITROOT=~tperrine/git-work

# since there is no standard for file naming for TCP vs UDP, or inbound/oubound
# cat them all together then slice out based on actual contents
cat $* | sed 's/\"//gp' > all-data.report

# first, all inbound connections, TCP or UDP
grep 'SEN->SIE' all-data.report > all-inbound.report
# now split those into TCP and UDP
grep -i TCP all-inbound.report > all-inbound-tcp.report
grep -i UDP all-inbound.report > all-inbound-udp.report

# now, all outbound connections, TCP or UDP
grep 'SIE->SEN' all-data.report > all-outbound.report
# now split those into TCP and UDP
grep -i TCP all-outbound.report > all-outbound-tcp.report
grep -i UDP all-outbound.report > all-outbound-udp.report

# make a uniq list of all inbound TCP sources and destinations
awk -F, '{print $3}' all-inbound-tcp.report | sort -u > all-inbound-source.tcp.ips.report
awk -F, '{print $4}' all-inbound-tcp.report | sort -u > all-inbound-destinations.tcp.ips.report
# now a list of unique inbound TCP ports
awk -F, '{print $5}' all-inbound-tcp.report | sort -u > all-inbound.tcp.ports.report

echo 'finding non-SIE unique inbound IPs'
$GITROOT/network-retirement-burndown/burndown.py $GITROOT/network-retirement-burndown/Data/all-ranges all-inbound-source.tcp.ips.report \
    | grep UNK | awk '{print $2}' | sort -u  > non-sie-inbound-source.tcp.ips.report

echo 'converting to unique non-SIE inbound subnets (assume /24s)'
cat non-sie-inbound-source.tcp.ips.report \
    | awk -F. '{print $1"."$2"."$3}' | sort -u > non-sie-inbound.tcp.subnets.report

# make a uniq list of all outbound TCP sources and destinations
awk -F, '{print $3}' all-outbound-tcp.report | sort -u > all-outbound-source.tcp.ips.report
awk -F, '{print $4}' all-outbound-tcp.report | sort -u > all-outbound-destinations.tcp.ips.report
# now a list of unique outbound TCP ports
awk -F, '{print $5}' all-outbound-tcp.report | sort -u > all-outbound.tcp.ports.report

echo 'finding non-SIE unique outbound IPs'
$GITROOT/network-retirement-burndown/burndown.py $GITROOT/network-retirement-burndown/Data/all-ranges all-outbound-source.tcp.ips.report \
    | grep UNK | awk '{print $2}' | sort -u  > non-sie-outbound-source.tcp.ips.report

echo 'converting to unique non-SIE outbound subnets (assume /24s)'
cat non-sie-outbound-source.tcp.ips.report \
    | awk -F. '{print $1"."$2"."$3}' | sort -u > non-sie-outbound.tcp.subnets.report


##################

# make a uniq list of all inbound UDP sources and destinations
awk -F, '{print $3}' all-inbound-udp.report | sort -u > all-inbound-source.udp.ips.report
awk -F, '{print $4}' all-inbound-udp.report | sort -u > all-inbound-destinations.udp.ips.report
# now a list of unique inbound UDP ports
awk -F, '{print $5}' all-inbound-udp.report | sort -u > all-inbound.udp.ports.report

echo 'finding non-SIE unique inbound IPs'
$GITROOT/network-retirement-burndown/burndown.py $GITROOT/network-retirement-burndown/Data/all-ranges all-inbound-source.udp.ips.report \
    | grep UNK | awk '{print $2}' | sort -u  > non-sie-inbound-source.udp.ips.report

echo 'converting to unique non-SIE inbound subnets (assume /24s)'
cat non-sie-inbound-source.udp.ips.report \
    | awk -F. '{print $1"."$2"."$3}' | sort -u > non-sie-inbound.udp.subnets.report

# make a uniq list of all outbound UDP sources and destinations
awk -F, '{print $3}' all-outbound-udp.report | sort -u > all-outbound-source.udp.ips.report
awk -F, '{print $4}' all-outbound-udp.report | sort -u > all-outbound-destinations.udp.ips.report
# now a list of unique outbound UDP ports
awk -F, '{print $5}' all-outbound-udp.report | sort -u > all-outbound.udp.ports.report

echo 'finding non-SIE unique outbound IPs'
$GITROOT/network-retirement-burndown/burndown.py $GITROOT/network-retirement-burndown/Data/all-ranges all-outbound-source.udp.ips.report \
    | grep UNK | awk '{print $2}' | sort -u  > non-sie-outbound-source.udp.ips.report

echo 'converting to unique non-SIE outbound subnets (assume /24s)'
cat non-sie-outbound-source.udp.ips.report \
    | awk -F. '{print $1"."$2"."$3}' | sort -u > non-sie-outbound.udp.subnets.report







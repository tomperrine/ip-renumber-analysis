#!/bin/sh

# Usage $0 file(s)
# format

# Note: these records are "directionless" as they don't indicate whether the flow is from or two SEN
# but that's OK, we'll just work from the source and destination addresses
# FORMAT
#TimeStamp,ProtocolID,ApplicationID,ToSID,Netflow Node,Source IP,Destination IP,Protocol Name,Port,Application,DSCP,Bytes Through
#,17,101181,0,siees-sen-link,43.194.208.14,43.195.130.78,UDP,1514,Splunk TCP Syslog,,24.0 GB


# where to find the tools
GITROOT=~tperrine/git-work


#####
##### NOTE removes all *.report files
#####

rm *.report

# put all the files together and pre-process:
#         strip out the headers - ASSUME data lines start with ',' !!!
#         re-arrange and select fields to get:
#protoname,sourceIP,destIP,port
cat $* | grep '^,' | awk -F,  '{print $8","$6","$7","$9}' > all.report


grep -i tcp all.report > all-tcp.report
grep -i udp all.report > all-udp.report

# make a uniq list of all TCP sources and destinations
awk -F, '{print $2}' all-tcp.report | sort -u > all-source.tcp.ips.report
awk -F, '{print $3}' all-tcp.report | sort -u > all-destinations.tcp.ips.report
# now a list of unique TCP ports
awk -F, '{print $4}' all-tcp.report | sort -u > all.tcp.ports.report

echo 'finding non-SIE unique inbound IPs'
$GITROOT/network-retirement-burndown/burndown.py $GITROOT/network-retirement-burndown/Data/all-ranges all-source.tcp.ips.report \
    | grep UNK | awk '{print $2}' | sort -u  > non-sie-source.tcp.ips.report

echo 'finding non-SIE unique outbound IPs'
$GITROOT/network-retirement-burndown/burndown.py $GITROOT/network-retirement-burndown/Data/all-ranges all-destinations.tcp.ips.report \
    | grep UNK | awk '{print $2}' | sort -u  > non-sie-outbound-source.tcp.ips.report




# make a uniq list of all UDP sources and destinations
awk -F, '{print $2}' all-udp.report | sort -u > all-source.udp.ips.report
awk -F, '{print $3}' all-udp.report | sort -u > all-destinations.udp.ips.report
# now a list of unique UDP ports
awk -F, '{print $4}' all-udp.report | sort -u > all.udp.ports.report

echo 'finding non-SIE unique inbound IPs'
$GITROOT/network-retirement-burndown/burndown.py $GITROOT/network-retirement-burndown/Data/all-ranges all-source.udp.ips.report \
    | grep UNK | awk '{print $2}' | sort -u  > non-sie-source.udp.ips.report

echo 'finding non-SIE unique outbound IPs'
$GITROOT/network-retirement-burndown/burndown.py $GITROOT/network-retirement-burndown/Data/all-ranges all-destinations.udp.ips.report \
    | grep UNK | awk '{print $2}' | sort -u  > non-sie-outbound-source.udp.ips.report







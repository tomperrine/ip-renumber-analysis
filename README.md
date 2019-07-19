# ip-renumber-analysis
a set of tools related to preparing for a large network renumber
#

Answer the following questions

* which IPs in the target range are we talking to (connecting to)?
* who on our side is connecting to those target IPs?
* from the list of destination IPs, filter out all that are "ours" AKA in one of our known subranges

We can start from any one of three sources:
* a PCAP file - use analyze-pcap-file.sh
* "standard log records" as defined by Net43 project - analyze-jp-text-files.py (TODO RENAME)
* SolarWinds records - 


PCAP file analysis

* start with a pcap file
* filter out all destination addresses that aren't in the network we are moving away from
* for each address that's left, filter out all addresses that are in our known subnet ranges
* for each address that's left find out some things:
** who on our side is connecting to it?
** does the other side have valid PTR recors?
** what will a traceroute to the other end tell us?

"Standard log records" analysis

proto, direction, sourceIP, destIP, port, count

TCP,SEN->SIE,43.27.144.192,43.27.75.145,22,347918


Solarwinds records

TimeStamp,ProtocolID,ApplicationID,ToSID,Netflow Node,Source IP,Destination IP,Protocol Name,Port,Application,DSCP,Bytes Through
,17,101181,0,siees-sen-link,43.194.208.14,43.195.130.78,UDP,1514,Splunk TCP Syslog,,24.0 GB

# ip-renumber-analysis
a set of tools related to preparing for a large network renumber
#

Answer the following questions

* which IPs in the target range are we talking to (connecting to)?
* who on our side is connecting to those target IPs?
* from the list of destination IPs, filter out all that are "ours" AKA in one of our known subranges


How

* start with a pcap file
* filter out all destination addresses that aren't in the network we are moving away from
* for each address that's left, filter out all addresses that are in our known subnet ranges
* for each address that's left find out some things:
** who on our side is connecting to it?
** does the other side have valid PTR recors?
** what will a traceroute to the other end tell us?


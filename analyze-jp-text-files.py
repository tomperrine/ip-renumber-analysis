#!/usr/bin/env python3

# analyze text files from JP

# format is
# proto, direction, sourceIP, destIP, port, count
# TCP,SEN->SIE,43.27.144.192,43.27.75.145,22,347918

# Usage: $0 file

import csv, sys
from collections import defaultdict

# we want to find the following things:

# a unique list of all the SEN systems that connect to our systems
sen_inbound_ips = []
#           for each of those, a unique list of our systems they are connecting to
sen_inbound_connected_to = defaultdict(list)

# a unique list of all the SEN systems that we connect to from our systems
#           for each of those, a unique list of their systems that ours are connecting to
# a unique list of the ports in use (SSH, AD, web, etc)
#           for each of those, a unique list of the systems that are using that protocol
#                      both in and out
sen_inbound_ports = []
#


def analyze_from_sen(row):
# analyze the inbound connections
    (proto, direction, sourceIP, destIP, port, count) = row
    # add to list of inbound hosts
    if sourceIP not in sen_inbound_ips :
        sen_inbound_ips.append(sourceIP)
    # and to the list of hosts connecting to this specific host
    sen_inbound_connected_to[sourceIP].append(destIP)
    # and to the list of hosts using this port
    if port not in sen_inbound_ports :
        sen_inbound_ports.append(port)

    return

def analyze_ro_sen(row):
    return



with open(sys.argv[1]) as csvfile:
    cvsreader = csv.reader(csvfile)
    for row in cvsreader:
        (proto, direction, sourceIP, destIP, port, count) = row
#        print(f'sourceIP {sourceIP}')
        if direction == 'SEN->SIE':
            analyze_from_sen(row)
        elif direction == 'SIE->SEN' :
            analyze_to_sen(row)
        else:
            print(f'incorrect direction {direction}')

print(sen_inbound_ips)
print(sen_inbound_connected_to)
print(sen_inbound_ports)

#!/usr/local/bin/python3

# given two files - a list of "my" IP ranges and a list of candidate IP addresses:
# filter out all IPs that are in one of "my" ranges


# Usage: $0 range-file candidate-ip-file

import sys
import ipaddress

# the list of "my" ranges
# this is a list of IPv4Network objects
my_ranges = []


# a function to iterate through a list of IPv4Network objects
# to determine if the given IPv4Address is in any
# of those ranges
def in_any_known_subnet(range_list, address):
    for subnet in range_list :
        if address in subnet:
            return True
    return False


if len(sys.argv) < 3 :
    print("Usage: $0 range-file candidate-ip-file")
    sys.exit()

range_file = sys.argv[1]
candidate_ip_file = sys.argv[2]

# let's load all "my" ranges
# this is a list of ranges, CIDR format, one per line
lineList = [line.rstrip('\n') for line in open(range_file)]
for range_cidr in lineList :
    my_ranges.append(ipaddress.IPv4Network(range_cidr))

#print(f'loaded {len(my_ranges)} IP ranges from {range_file}')

#print(my_ranges)

# Now to start filtering the big file
# file format
# destination-address
lineList = [line.rstrip('\n') for line in open(candidate_ip_file)]
for dest_ip in lineList :
    if not in_any_known_subnet(my_ranges, ipaddress.IPv4Address(dest_ip)) :
        print(dest_ip)



#!/usr/bin/env python

# go through a list of short introns produced by agat_sp_list_short_introns.pl
# and find the corresponding mRNA titles

import argparse
import re

def build_regex(input_file):
    regex_list = []
    # open the input file
    with open(input_file, 'r') as f:
        # the first 3 lines are headers
        f.readline()
        f.readline()
        f.readline()
        # read the file line by line
        for line in f:
            # if the line is empty, we have reached the end
            if line == "\n":
                break
            # split the line by tab
            line = line.strip().split('\t')
            _locus, locus_id, position, _intron_length = line

            # build the regex
            regex = re.compile(f"{int(position) - 1}.*{locus_id.upper()}")
            regex_list.append(regex)
    return regex_list


def grep(regex_list, target):
    to_fix = set()
    # grep the target file for the regex
    with open(target, 'r') as f:
        for line in f:
            for regex in regex_list:
                if re.search(regex, line):
                    attributes = line.strip().split('\t')[-1]
                    attr_dict = {}
                    for attr in attributes.split(';'):
                        key, value = attr.split('=')
                        attr_dict[key] = value
                    to_fix.add(attr_dict['Parent'])
    return list(to_fix)

def main(input_file, target):
    short_introns = build_regex(input_file)
    ids = grep(short_introns, target)
    for i in ids:
        print(i)
            

if __name__ == "__main__":
    # argument parser that will receive the input file
    parser = argparse.ArgumentParser(description='Get the mRNA titles of the short introns (agat_sp_list_short_introns.pl output file)')
    parser.add_argument('input_file', type=str, help='The input file containing the short introns')
    parser.add_argument('target_file', type=str, help='The target GFF file.')
    args = parser.parse_args()
    input_file = args.input_file
    target = args.target_file
    main(input_file, target)
#TEanalysis.py
'''
this code is used to count the number of occurences of the repeats iudentified by repeatmodeler on the genome file. 
This searches the TEs on the basis of their types, LINE/SINE/DNA/Unknown
'''
from functools import total_ordering
import sys
import re

inputfile = sys.argv[1] ##-- consensus file from the Repeatmodeler
genomefile = sys.argv[2] ##-- genome file of the species

TE_dict = {}

def count_all_seqs_in_genome(inputfastafile):
    totalseqcount = 0
    value = ''
    fi = open(inputfastafile, 'r')
    for line in fi:
        if line.startswith(">"):
            continue
        else:
            value = len(line.strip())
            totalseqcount += value
    return totalseqcount

totalseqs = count_all_seqs_in_genome(genomefile)
print("Total number of seqs in the genome is: ", totalseqs)

def count_TEcontent_per_TEtype(inputconsensusfile, transposons_dict):
    fi = open(inputconsensusfile, 'r')
    totaldnasequencelength = 0
    key = "" # initialize variable key
    for line in fi:
        if line.startswith(">"):
            pound_index = line.index('#')
            bracket_index = line.index('(')
            marker = line[pound_index+1:bracket_index].strip()
            key = marker
            dnasequence = ''
            if key not in transposons_dict:
                transposons_dict[key] = [0,0]
        else:
            dnasequence = line.strip()
            totaldnasequencelength = transposons_dict[key][0] + len(dnasequence)
            percentcoverage = round((totaldnasequencelength/totalseqs)*100,4)
            transposons_dict[key] = [totaldnasequencelength, percentcoverage]
            
    return transposons_dict

count_TEcontent_per_TEtype(inputfile, TE_dict)

for key, value in TE_dict.items():
    print( key, '\t', value[0],'\t', value[1])
    mylist = value[1]

print(sum(mylist))

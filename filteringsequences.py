# from msilib import sequence
import os
import sys
import re
import gzip
from textwrap import wrap

def convertfastatodict(filename):
    fi = open(filename, 'rt')
    key = ''
    value = ''
    for line in fi:
        line = line.strip()
        if line.startswith(">"): # header with lophiiformes
            #line = re.sub(" ","_", line)
            if key != '':
                fastadict[key] = value
            key = line[1:]
            value = '' #reset value for new header
            continue
        else:
            value += line.strip() # append to dictionary

def getsequenceheaddersfromfile(filename, inputlist):#, outputlist):
    inf = open(filename, 'r')
    for line in inf:
        #print(line)
        sequence = line.split(",")
        for item in sequence:
            sequence_header = item.split("|")[1]
            inputlist.append(sequence_header)
    return inputlist
        
    
def printdicttofile(dictionary, output):
    n=70
    with open(output, 'w') as fo:
        for key, value in fastadict.items():
            key = key.strip()
            value = value.lstrip()
            chunks = [value[i:i+n] for i in range(0, len(value), n)]
            print('>' + key + '\n' + '\n'.join(chunks), file =fo)


if __name__ == '__main__':
    fastadict={}
    fastafile = sys.argv[1]
    sequence_header_list = []
    outputfile = sys.argv[2]
    getsequenceheaddersfromfile("/home/rittika/google_drive_rmallik1/Dornburg lab work/Long-nosed-gar genome announcement/N-sequence-gar.txt", sequence_header_list)
    convertfastatodict(fastafile)
    #print(len(sequence_header_list))
    delete_keys = []
    for item in sequence_header_list:
        for key in fastadict.keys():
            if item == key:
                delete_keys.append(key)
    for delkey in delete_keys:
        del fastadict[delkey]
        
    printdicttofile(fastadict, outputfile)
 
##--how to run
##--python3 filteringproteins.py proteins.faa filtered_proteins.faa
##--python3 scripts/filteringproteinfiles.py dataset/vertebrates_protein.faa dataset/vertebrates_protein_filtered.faa
##--python3 scripts/filteringproteinfiles.py dataset/amphibians_protein.faa dataset/amphibians_protein_filtered.faa

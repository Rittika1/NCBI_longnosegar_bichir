# from msilib import sequence
import os
import sys
import re
import gzip

def convert_fasta_to_dict(filename):
    fastadict = {}
    fi = open(filename, 'rt')
    key = ''
    value = ''
    for line in fi:
        line = line.strip()
        if line.startswith(">"): # header  of the sequence
            #line = re.sub(" ","_", line)
            if key != '':
                fastadict[key] = value
            # key = line.split("|")[1].split(" ")[0]
            key = line[1:]
            value = '' #reset value for new header
            continue
        else:
            value += line.strip() # append to dictionary
    return fastadict

def get_duplicate_seq_headers_from_file(inputDupfile, outputlist, deletelist):
    '''
    the duplicate sequences are in the form of seq1 seq2 seq3, not every line has equal number of column
    to get all the sequence headers, 
    '''
    dupf = open(inputDupfile, 'r')
    for line in dupf:
        # print(line)
        line = line.strip()
        line = re.sub('\)', '', line)
        line = re.sub('RC\(', '', line)
        # print(line)
        sequence_header_to_keep = line.split(" ")[0]
        sequence_header_to_delete = line.split(" ")[1:-2]
        outputlist.append(sequence_header_to_keep)
        for item in sequence_header_to_delete:
            deletelist.append(item)
    return outputlist

def printdicttofile(fastadict:dict, output:str):
    n=7000
    with open(output, 'w') as fo:
        for key, value in fastadict.items():
            key = key.strip()
            value = value.lstrip()
            chunks = [value[i:i+n] for i in range(0, len(value), n)]
            print('>' + key + '\n' + '\n'.join(chunks), file =fo)

def fastadict_extract_positions_from_contaminations(inputfile:str, fastadict:dict):
    """ Creates a new fastadict from contaminated sequences from input fastadict.
    Input:
        inputfile: <str>
        fastadict: <dict> <key: sequence header, val: dna sequence <string>
    Notes:
    1.  Reads the input file to extract the uncontaminated dna sequence indices
    2.  Saves the allowable sequences in var: `refined_position_list`
    3.  Iterates through the list to create new sequence headers and values for 
        corrected_fastadict
    4.  Remove the sequence_header from the fastadict
    """
    print ("Function: fastadict_extract_positions_from_contaminations:: type(fastadict): ",type(fastadict) )
    fi = open(inputfile, 'r')
    corrected_fastadict = {}
    for line in fi:
        sequence_header = line.split("\t")[0] #string
        length_of_sequence = int(line.split("\t")[1]) 
        contamination = line.split("\t")[2]
        position_str_list = contamination.split("..")
        # -- refine the position list
        refined_position_list = refined_list(position_str_list, length_of_sequence)
        print(refined_position_list) 
        # -- create the partitions of the data
        # from it is a huge chunk of string, dividded into chunks based on the positions of the tuples
        # huge chunk of string <-- the value of the dictionary
        # key of the dictionary < -- sequence header
        
        # -- loop through the refined position list
        for idx, refined_position_tuple in enumerate(refined_position_list):
            # -- new key
            new_sequence_header = f"{sequence_header}_{idx+1}"
            # -- old value
            fastadict_val = fastadict[sequence_header]
            # -- new value
            fastadict_new_val = fastadict_val[refined_position_tuple[0]:refined_position_tuple[1]]
            # -- add element to dictionary
            corrected_fastadict[new_sequence_header] = fastadict_new_val
        # -- remove the previous key from the fastadict
        del(fastadict[sequence_header])

    return corrected_fastadict, fastadict

def refined_list(position_str_list, length_of_sequence):
    """ REfines the string list to a list of tuples. 
    create the tuple list, from 0 to the first element-1, in the postion_str_list. 
    """
    zero_pos = 0
    refined_postions_list = []
    # -- handle first and last element
    first_tuple = (zero_pos, int(position_str_list[0])) 
    last_tuple = (int(position_str_list[-1])+1, length_of_sequence)
    # -- add the first tuple to the refined position list
    refined_postions_list.append(first_tuple)
    for idx in range(1, len(position_str_list)-1):
        # range from 2nd element to 2nd last element
        position_str_elem = position_str_list[idx]
        position_list = position_str_elem.split(',')
        first_elem = int(position_list[0])+1
        last_elem = int(position_list[1]) # sublist in python does not consider the last element
        tuple_to_add = (first_elem, last_elem)
        refined_postions_list.append(tuple_to_add)
    # -- add the last element
    refined_postions_list.append(last_tuple)
    # -- return the refined position list
    return refined_postions_list

# def main_trim_adapters(fastafile, fastadict, outputfile, adapters_to_trim_inputfile):
#     # inputfile = 'NCBI_submission_error_reply/adapter_sequences_to_trim.txt'
#     # fastadict = convert_fasta_to_dict(fastafile)

#     corrected_fastadict, fastadict = fastadict_extract_positions_from_contaminations(adapters_to_trim_inputfile, fastadict)
#     # -- merge the dictionaries
#     fastadict.update(corrected_fastadict)
#     # -- print the fastadict and corrected fastadict to outputfile
#     printdicttofile(fastadict, outputfile)
#     return outputfile
    
# def main_duplicate_seq(fastafile, duplicate_seq_file):
#     sequence_header_list = []
#     duplicate_sequence_headers = []
#     keys_to_be_deleted = []
#     get_duplicate_seq_headers_from_file(duplicate_seq_file, sequence_header_list, duplicate_sequence_headers)
#     fastadict = convert_fasta_to_dict(fastafile)
#     for fastakey in fastadict.keys():
#         for search_key in duplicate_sequence_headers:
#             if search_key in fastakey:
#                 keys_to_be_deleted.append(fastakey)
#     for item in keys_to_be_deleted:
#         del fastadict[item]
#     return fastadict

def main_trim_adapters(fastafile, outputfile, adapters_to_trim_inputfile):
    # inputfile = 'NCBI_submission_error_reply/adapter_sequences_to_trim.txt'
    fastadict = convert_fasta_to_dict(fastafile)

    corrected_fastadict, fastadict = fastadict_extract_positions_from_contaminations(adapters_to_trim_inputfile, fastadict)
    # -- merge the dictionaries
    fastadict.update(corrected_fastadict)
    # -- print the fastadict and corrected fastadict to outputfile
    # printdicttofile(fastadict, outputfile)
    return fastadict
    
def main_duplicate_seq(fastafile, outputfile, fastadict, duplicate_seq_file):
    sequence_header_list = []
    duplicate_sequence_headers = []
    keys_to_be_deleted = []
    get_duplicate_seq_headers_from_file(duplicate_seq_file, sequence_header_list, duplicate_sequence_headers)
    fastadict = convert_fasta_to_dict(fastafile)
    for fastakey in fastadict.keys():
        for search_key in duplicate_sequence_headers:
            if search_key in fastakey:
                keys_to_be_deleted.append(fastakey)
    for item in keys_to_be_deleted:
        del fastadict[item]
    # -- print the fastadict and corrected fastadict to outputfile
    printdicttofile(fastadict, outputfile)
    return outputfile

# print("is this working?")
if __name__ == '__main__':
    fastafile = sys.argv[1]   
    duplicate_sequence_file = sys.argv[2]
    outputfile = sys.argv[3] 
    adapterfile = sys.argv[4]   
    finalfiltered_dict = {}
    print("This is running")
    # finalfiltered_dict = main_duplicate_seq(fastafile, duplicate_sequence_file)
    # main_trim_adapters (fastafile, finalfiltered_dict, outputfile, adapterfile)
    # finalfiltered_dict = main_trim_adapters(fastafile, outputfile, adapterfile)
    main_duplicate_seq(fastafile, outputfile, finalfiltered_dict,duplicate_sequence_file)
    # printdicttofile(finalfiltered_dict, outputfile)

##--how to run
##-- python3 remove
##-- python3 remove_adapters_and_duplicate_sequences.py NCBI_submission_error_reply/corrected_files/polypterus_bichir_lapradei_nodups_filtered00000000.fsa NCBI_submission_error_reply/duplicate_sequences.txt testout.fsa
##-- python3 
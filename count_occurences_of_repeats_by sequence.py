import sys
import re

"""
--Steps of countign repeats
--remove the sequence headers and make the genome file into one big string
--make on big file with all the ATGC sequences
-- input the consensi classified file
-- in the input file, which is a fasta file, take each of the sequences and make it a search string
--look for the search string in the big file
--count the number of occurences using finditer
--to find total number of TE sequences, use the count and the sequence length to get the total number of sequences for that superfamily.
"""


# from scripts_for_genome_announcement.TEanalysis import TE_dict

genome_input = sys.argv[1]
repeats_input = sys.argv[2]

def convert_genome_file_to_giant_string(genome_file):
    giant_string=""
    gi = open(genome_file, 'r')
    for line in gi:
        if line.startswith(">"):
            continue
        else:
            line = line.strip()
            giant_string += line
    return giant_string


def search_occurences_of_substring(repeat_file):
    TE_dict = {}  
    ri = open(repeat_file, 'r')
    for line in ri:
        if line.startswith(">"):
            dnasequence = ""
            key = line.split(" ")[0]
            if key not in TE_dict:
                TE_dict[key] = ""
        else:
            line = line.strip()
            dnasequence += line
            TE_dict[key] = dnasequence
    return TE_dict

giant_string = convert_genome_file_to_giant_string(genome_input)
outf = open("testoutputfile.txt", 'w')
outf.write(giant_string)
print("written to file")
random_dict = search_occurences_of_substring(repeats_input)

print("The length of the genome is:", len(giant_string))
list_of_unique_sequences = random_dict.values()
for key, value in random_dict.items():
    item = value.strip()
    repeat_length = len(item)
    res = [i.start() for i in re.finditer(item, giant_string)]
    occurences = len(res)
    total_repeat_content = repeat_length*occurences
    print("Number of occurences for: " + key + " is " + str(len(res)))
    # print ("The repeat is: ", item)
    print(f"Total repeat content for {key} is {total_repeat_content}")
    print("---"*50)


##--how-to-run
## -- python3 count_occurences_of_repeats.py lepisosteus_osseus_noadapters.fasta consensi.fa.classified
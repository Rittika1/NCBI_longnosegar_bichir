# NCBI_longnosegar_bichir
The following scripts weree used to prepare the genome of Longnose gar, _Lepisosteus osseus_ for NCBI submission and subsequent analysis

**Script name:**

* filteringsequences.py --> Remove sequences with N. It uses the file with the list of sequence headers given by NCBI  

* remove_adapters_and_duplicate_sequences.py --> removes the adapters and duplicate sequences from the genome using the file contaminations.txt from NCBI

* trinity_rna.sh --> Assemble the RNA seq using trinity

* buscorun.sh --> code to run busco for genome and transciptome

* hisat2-longnosegar.sh --> Make a BAM file from the RNA seq to be used for BRAKER. This part is also part of `fullbrakerpipeline.sh`. 

* fullbrakerpipeline.sh --> Steps for annotating the genome using BRAKER2. Run with the RNA seq and the genome

* count_occurences_of_repeats_by sequence.py --> Takes in the consensi file from the RepeatModeler, and counts the occurence of each repeat sequence in the genome

* estimate_TE_content_by_TE_type.py --> Uses the consensi file to calculate the amount of each TE type from the consensi file

* GO-analysis.sh --> Steps for annotating transcripts using trinotate

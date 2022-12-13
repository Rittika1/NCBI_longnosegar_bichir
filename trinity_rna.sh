##--if runninng on the hpc cluster
# module load trinity/2.14.0

Trinity --seqType fq --left NS035_1.fq --right NS035_2.fq --CPU 12 --max_memory 100G

##--the output is in the form of Trinity_out_dir.Trinity.fasta
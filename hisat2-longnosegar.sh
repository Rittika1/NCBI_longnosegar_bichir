#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=hisat2_senegalus
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16 
#SBATCH --mem=64GB

module load hisat2/2.2.0
module load samtools

#hisat2 [options]* <genome_index_base> PE_reads_1.fq.gz PE_reads_2.fq.gz,SE_reads.fa
##-- hisat2 [options]* -x <hisat2-idx> {-1 <m1> -2 <m2> | -U <r> | --sra-acc <SRA accession number>} [-S <hit>]

hhisat2-build -f  lepisosteus_osseus_noadapter_nodups_noemptylines.fasta lepisosteus_osseus
hisat2 -p 8 -x lepisosteus_osseus -1 .NS035_1.fq -2 .NS035_2.fq -S lepisosteus_osseus_aligned.sam
samtools view -h lepisosteus_osseus_aligned.sam > lepisosteus_osseus_aligned.bam
samtools sort -O bam -T tmp_ -@ 16 -o lepisosteus_osseus_aligned.sorted.bam lepisosteus_osseus_aligned.bam
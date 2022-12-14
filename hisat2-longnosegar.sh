#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=hisat2_senegalus
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16 
#SBATCH --mem=64GB
#SBATCH --error=/scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/hisat2-run-bichir.out

module load bowtie2
module load hisat2/2.2.0
module load samtools

#hisat2 [options]* <genome_index_base> PE_reads_1.fq.gz PE_reads_2.fq.gz,SE_reads.fa

cd /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/RNAs-seq

##-- hisat2 [options]* -x <hisat2-idx> {-1 <m1> -2 <m2> | -U <r> | --sra-acc <SRA accession number>} [-S <hit>]
hisat2-build -f polypterus_senegalus_bowtie.fa polypterus_senegalus_bowtie

##-- hisat2 -f --phred64 -p 8 -x polypterus_senegalus_bowtie -1 NS079_1.fq.gz,NS080_1.fq.gz,NS081_1.fq.gz,NS082_1.fq.gz,NS083_1.fq.gz,NS084_1.fq.gz,NS085b_1.fq.gz -2 NS079_2.fq.gz,NS080_2.fq.gz,NS081_2.fq.gz,NS082_2.fq.gz,NS083_2.fq.gz,NS084_2.fq.gz,NS085b_2.fq.gz > polypterus_senegalus_aligned.sam

hisat2 -p 8 -x polypterus_senegalus_bowtie -1 NS079_1.fq,NS080_1.fq,NS081_1.fq,NS082_1.fq,NS083_1.fq,NS084_1.fq,NS085b_1.fq -2 NS079_2.fq,NS080_2.fq,NS081_2.fq,NS082_2.fq,NS083_2.fq,NS084_2.fq,NS085b_2.fq -S polypterus_senegalus_aligned.sam
samtools view -h polypterus_senegalus_aligned.sam > polypterus_senegalus_aligned.bam
samtools sort -O bam -T tmp_ -@ 16 -o polypterus_senegalus_aligned.sorted.bam polypterus_senegalus_aligned.bam
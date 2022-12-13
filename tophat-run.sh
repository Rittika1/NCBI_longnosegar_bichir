#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=tophat_senegalus
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=64GB
#SBATCH --error=/scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/tophat-run-bichir.out

module load bowtie2
module load tophat/2.1.1

#tophat [options]* <genome_index_base> PE_reads_1.fq.gz PE_reads_2.fq.gz,SE_reads.fa

cd /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/RNAs-seq

tophat2 -p 8 -i 10 -o /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/aligned_RNAseq --solexa1.3-quals polypterus_senegalus_bowtie NS079_1.fq.gz NS079_2.fq.gz NS080_1.fq.gz NS080_2.fq.gz NS081_1.fq.gz NS081_2.fq.gz NS082_1.fq.gz NS082_2.fq.gz NS083_1.fq.gz NS083_2.fq.gz NS084_1.fq.gz NS084_2.fq.gz NS085b_1.fq.gz NS085b_2.fq.gz
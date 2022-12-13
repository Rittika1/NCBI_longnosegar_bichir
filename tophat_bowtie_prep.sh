#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=tophat_senegalus
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=64GB
#SBATCH --error=/scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/tophat-prep-bichir.out

cd /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement

module load samtools
# indexing the fasta files comes in handy for later use but is not necessary for bowtie-build.
samtools faidx /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/GCF_016835505.1_ASM1683550v1_genomic.fna

module load bowtie2

bowtie2-build /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/GCF_016835505.1_ASM1683550v1_genomic.fna polypterus_senegalus_bowtie
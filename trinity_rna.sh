#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=trinity
#SBATCH --time=400:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=14
#SBATCH --mem=100GB
#SBATCH --error=/scratch/rmallik1/PhD_EVILab//GenomeAnnouncement/tirnity_gar3.out

module load trinity/2.14.0

Trinity --seqType fq --left NS035_1.fq --right NS035_2.fq --CPU 12 --max_memory 100G

##--the output is in the form of Trinity_out_dir.Trinity.fasta
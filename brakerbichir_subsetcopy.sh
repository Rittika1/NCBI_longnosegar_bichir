#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=brakerbichirdatabase
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=64GB
#SBATCH --error=/scratch/rmallik1/PhD_EVILab/SIRPs/log-EOfiles/braker2bichir.out

module load braker/2.1.5
module load diamond
export AUGUSTUS_CONFIG_PATH=$HOME/augustus_config

##--prothint preparation for the protein database for running braker2
##--wget https://v100.orthodb.org/download/odb10_arthropoda_fasta.tar.gz
##--tar xvf odb10_vertebrata_fasta.tar.gz
##--cat vertebrate/Rawdata/* > vertebrates_protein_braker.fasta

braker.pl --genome=/scratch/rmallik1/PhD_EVILab/SIRPs/dataset/polypterus_senegalus_subset.fasta --prot_seq=/scratch/rmallik1/PhD_EVILab/SIRPs/dataset/vertebrates_protein_braker.fasta --softmasking --DIAMOND_PATH=/apps/pkg/diamond/2.0.9/bin/diamond --cores=1
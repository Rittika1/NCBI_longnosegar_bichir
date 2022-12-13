#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=brakergar
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=64GB
#SBATCH --error=/scratch/rmallik1/PhD_EVILab/SIRPs/log-EOfiles/braker2gar.out

module load braker/2.1.5
module load diamond
export AUGUSTUS_CONFIG_PATH=$HOME/augustus_config
module load genemark; cp -a $GM_HOME/gm_key /scratch/rmallik1/PhD_EVILab/SIRPs/longnosegar/.gm_key; module unload genemark

##--prothint preparation for the protein database for running braker2
##--wget https://v100.orthodb.org/download/odb10_arthropoda_fasta.tar.gz
##--tar xvf odb10_vertebrata_fasta.tar.gz
##--cat vertebrate/Rawdata/* > vertebrates_protein_braker.fasta
##--braker doesnt wokr with more than 8 cores

cd /scratch/rmallik1/PhD_EVILab/SIRPs/longnosegar

braker.pl --genome=/scratch/rmallik1/PhD_EVILab/SIRPs/longnosegar/lepisosteus_osseus_11Apr2019_0zt9O_filtered.fasta.gz --prot_seq=/scratch/rmallik1/PhD_EVILab/SIRPs/dataset/vertebrates_protein_braker.fasta --softmasking --DIAMOND_PATH=/apps/pkg/diamond/2.0.9/bin/diamond --cores=1
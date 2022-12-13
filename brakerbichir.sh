#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=brakerbichirdatabase_core1
#SBATCH --time=600:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=100GB
#SBATCH --error=/scratch/rmallik1/PhD_EVILab/SIRPs/log-EOfiles/braker2bichir_core1.out

module load genemark; cp -a $GM_HOME/gm_key ~/.gm_key; module unload genemark
module load braker/2.1.5
# module load diamond
export AUGUSTUS_CONFIG_PATH=$HOME/augustus_config

# cd /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/PolypterusBichir

cd /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/PolypterusBichir/braker_core1
##--prothint preparation for the protein database for running braker2
##--wget https://v100.orthodb.org/download/odb10_arthropoda_fasta.tar.gz
##--tar xvf odb10_vertebrata_fasta.tar.gz
##--cat vertebrate/Rawdata/* > vertebrates_protein_braker.fasta

braker.pl --species=polypterusbichir --genome=/scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/PolypterusBichir/polypterus_bichir_lapradei_nodups_noadapters_noemptylines.fsa.masked --bam /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/RNAs-seq/polypterus_bichir_lapradei_aligned.sorted.bam --softmasking --DIAMOND_PATH=/apps/pkg/diamond/2.0.9/bin/diamond --cores 1 --useexisting
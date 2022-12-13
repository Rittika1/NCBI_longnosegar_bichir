#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=repeatmasker
#SBATCH --time=200:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32 
#SBATCH --mem=100GB

module load repeatmodeler/
module load repeatmasker

cd /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement
# BuildDatabase -name polybirlapDB -engine ncbi PolypterusBichir/polypterus_bichir_lapradei_nodups_noadapters_noemptylines.fsa
# RepeatModeler -database polybirlapDB -engine ncbi -pa 32

##--Step-Repeatmasker --
ln -s RM_2251557.SunJul100457512022/consensi.fa.classified 
####--This will produce a gff for the repeat mapping, a masked fasta file, and a table summarizing the repeats found in the genome.
RepeatMasker -pa 16 -gff -lib consensi.fa.classified PolypterusBichir/polypterus_bichir_lapradei_nodups_noadapters_noemptylines.fsa
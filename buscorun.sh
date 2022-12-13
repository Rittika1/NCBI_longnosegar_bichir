#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=buscorunbichir
#SBATCH --time=300:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --mem=128GB
#SBATCH --error=/scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/buscorun_garprotein_actinop.out

module load busco
export AUGUSTUS_CONFIG_PATH=$HOME/augustus_config
export BUSCO_CONFIG_FILE=/apps/pkg/busco/4.0.6/config/config.ini

filepath=$1
inputfile=$2
lineage=$3
outputfolder=$4
mode=$5 ##-- mode can be genome, proteins, transcriptome

# cd /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/longnosegar
echo "cd $1"
cd $1

# busco -i dataset/GCF_016835505.1_ASM1683550v1_genomic.fna -l bichir/vertebrata_odb10 -o busco_vertebrate_bichir --out_path /scratch/rmallik1/SIRPs/bichir -m genome >> busco_vertebrate_bichir.txt -f -c 32
# busco -i lepisosteus_osseus_noadapter_nodups_noemptylines.fasta -l vertebrata_odb10 -o busco_longnosegar -m genome -f 

echo "busco -i $2 -l $3 -o $4 -m $5 -f -c 32"
busco -i $2 -l $3 -o $4 -m $5 -f -c 32

###---How to run:
# ./../scripts_for_genome_announcement/buscorun.sh /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/PolypterusBichir/ RNA actinopterygii_odb10 busco_longnosegar_rna


#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=blastrepbase
#SBATCH --time=600:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=100GB

module load blast

# cat Repbase27.08.fasta/*.ref >> Repbase27.08.fasta
makeblastdb -in Repbase27.08.fasta -dbtype nucl

blastn -query longnosegar/consensi.fa.classified -db Repbase27.08.fasta -out longnosegar/longnosegar_repbase08.out -outfmt 6
blastn -query PolypterusBichir/consensi.fa.classified -db Repbase27.08.fasta -out PolypterusBichir/bichir_repbase08.out -outfmt 6

blastn -query longnosegar/consensi.fa.classified -db Repbase27.08.fasta -out longnosegar/longnosegar_repbase08_max1.out -max_target_seqs 1 -outfmt 6
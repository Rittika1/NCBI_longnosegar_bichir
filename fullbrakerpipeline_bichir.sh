#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=bichir_genome_annotation
#SBATCH --time=200:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=150GB
#SBATCH --error=/scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/genome-annotation-bichir_braker2.out

module load hisat2/2.2.0
# module load samtools
module load repeatmodeler
module load repeatmasker


cd /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/PolypterusBichir
# path_to_rna_seq="$1"

##--Steps for the genome annotation with braker

# ##--First step ---- Making aligned bam file using all the RNA seq files
# hisat2-build -f  polypterus_bichir_lapradei_nodups_noadapters_noemptylines.fsa polypterus_bichir_lapradei
# # hisat2 -p 8 -x polypterus_bichir_lapradei -1 $1NS079_1.fq,NS080_1.fq,NS081_1.fq,NS082_1.fq,NS083_1.fq,NS084_1.fq,NS085b_1.fq -2 NS079_2.fq,NS080_2.fq,NS081_2.fq,NS082_2.fq,NS083_2.fq,NS084_2.fq,NS085b_2.fq -S polypterus_bichir_lapradei_aligned.sam
# hisat2 -p 8 -x polypterus_bichir_lapradei -1 $1NS079_1.fq,$1NS080_1.fq,$1NS081_1.fq,$1NS082_1.fq,$1NS083_1.fq,$1NS084_1.fq,$1NS085b_1.fq -2 $1NS079_2.fq,$1NS080_2.fq,$1NS081_2.fq,$1NS082_2.fq,$1NS083_2.fq,$1NS084_2.fq,$1NS085b_2.fq -S polypterus_bichir_lapradei_aligned.sam
# samtools view -h polypterus_bichir_lapradei_aligned.sam > polypterus_bichir_lapradei_aligned.bam
# samtools sort -O bam -T tmp_ -@ 16 -o polypterus_bichir_lapradei_aligned.sorted.bam polypterus_bichir_lapradei_aligned.bam

# module unload samtools

# ##--Second step ----- Repeat modeling with repeat modeler and then repeat masking with repeat masker
# BuildDatabase -name polybirlapDB -engine ncbi polypterus_bichir_lapradei_nodups_noadapters_noemptylines.fsa
# RepeatModeler -database polybirlapDB -engine ncbi -pa 16

##--Third step ----- RepeatMasker on the modeled repeats and softmasking them
####-- softlink the consensi.fa.classified file, otherwise you will not get a table of classified elements after the run.

ln -s RM_3066855.WedAug31306592022/consensi.fa.classified 

###--This will produce a gff for the repeat mapping, a masked fasta file, and a table summarizing the repeats found in the genome.

RepeatMasker -pa 16 -gff -lib consensi.fa.classified polypterus_bichir_lapradei_nodups_noadapters_noemptylines.fsa

#--Fourth step Finally run braker on the masked genome
module load genemark; cp -a $GM_HOME/gm_key ~/.gm_key; module unload genemark
module load braker
export AUGUSTUS_CONFIG_PATH=$HOME/augustus_config

braker.pl --species=polypterusbichir --genome=/scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/PolypterusBichir/polypterus_bichir_lapradei_nodups_noadapters_noemptylines.fsa.masked --bam /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/PolypterusBichir/polypterus_bichir_lapradei_aligned.sorted.bam --softmasking --DIAMOND_PATH=/apps/pkg/diamond/2.0.9/bin/diamond --cores 8 --useexisting


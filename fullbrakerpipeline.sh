#!/bin/bash
#SBATCH --partition=Orion
#SBATCH --job-name=genome_annotation
#SBATCH --time=200:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=150GB
#SBATCH --error=/scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/genome-annotation-longnosegarpart3_maskandbraker.out

module load hisat2/2.2.0
module load samtools
module load repeatmodeler
module load repeatmasker


cd /scratch/rmallik1/PhD_EVILab/GenomeAnnouncement/longnosegar

##--Steps for the genome annotation with braker

# ##--First step ---- Making aligned bam file using all the RNA seq files
# hisat2-build -f  lepisosteus_osseus_noadapter_nodups_noemptylines.fasta lepisosteus_osseus
# hisat2 -p 8 -x lepisosteus_osseus -1 ../RNAs-seq/NS035_1.fq -2 ../RNAs-seq/NS035_2.fq -S lepisosteus_osseus_aligned.sam
# samtools view -h lepisosteus_osseus_aligned.sam > lepisosteus_osseus_aligned.bam
# samtools sort -O bam -T tmp_ -@ 16 -o lepisosteus_osseus_aligned.sorted.bam lepisosteus_osseus_aligned.bam

module unload samtools

# ##--Second step ----- Repeat modeling with repeat modeler and then repeat masking with repeat masker
# BuildDatabase -name lepisosteus_osseusDB -engine ncbi lepisosteus_osseus_noadapter_nodups_noemptylines.fasta
# RepeatModeler -database lepisosteus_osseusDB -engine ncbi -pa 16

#--Third step ----- RepeatMasker on the modeled repeats and softmasking them
###-- softlink the consensi.fa.classified file, otherwise you will not get a table of classified elements after the run.
ln -s RM_2977898.WedJul131607022022/consensi.fa.classified 
###--This will produce a gff for the repeat mapping, a masked fasta file, and a table summarizing the repeats found in the genome.
RepeatMasker -pa 16 -gff -lib consensi.fa.classified lepisosteus_osseus_noadapter_nodups_noemptylines.fasta

##--Fourth step Finally run braker on the masked genome
module load genemark; cp -a $GM_HOME/gm_key ~/.gm_key; module unload genemark
module load braker
export AUGUSTUS_CONFIG_PATH=$HOME/augustus_config

braker.pl --species=longnosegar_lepisosteus --genome=lepisosteus_osseus_noadapter_nodups_noemptylines.fasta.masked --bam lepisosteus_osseus_aligned.sorted.bam --softmasking --DIAMOND_PATH=/apps/pkg/diamond/2.0.9/bin/diamond --cores 8 --useexisting

# samtools view -h lepisosteus_osseus_aligned.sorted.bam | sed 's/;/./g' | samtools view -Sb -o lepisosteus_osseus_aligned_2.sorted.bam
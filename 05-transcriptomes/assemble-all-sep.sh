#!/usr/bin/env bash

# A script to submit the transcriptome of each developmental stage to the cluster to be assembled
# with Trinity. I will then merge the assemblies into a single one.


INPUT="/scratch/zoology/pycnogonum/HTT33DSX5_4_R15615_20230713/demultiplexed"
BASE="/scratch/zoology/pycnogonum/transcriptome/dev_timepoints"
SCRIPT="/home/user/papadopoulos/repos/pycno-seq/dev_transcriptomes/assemble-single.sh"


sbatch -J pycno-trinity-protonymphon_instar1 $SCRIPT "$INPUT"/235253/235253_S47_L004_R1_001.fastq.gz "$INPUT"/235253/235253_S47_L004_R2_001.fastq.gz "${BASE}/235253_trinity_protonymphon_instar1/"
sbatch -J pycno-trinity-instar6 $SCRIPT "$INPUT"/235254/235254_S48_L004_R1_001.fastq.gz "$INPUT"/235254/235254_S48_L004_R2_001.fastq.gz "${BASE}/235254_trinity_instar6/"
sbatch -J pycno-trinity-embryonic_stage3 $SCRIPT "$INPUT"/235255/235255_S49_L004_R1_001.fastq.gz "$INPUT"/235255/235255_S49_L004_R2_001.fastq.gz "${BASE}/235255_trinity_embryonic_stage3-4/"
sbatch -J pycno-trinity-instar2 $SCRIPT "$INPUT"/235256/235256_S50_L004_R1_001.fastq.gz "$INPUT"/235256/235256_S50_L004_R2_001.fastq.gz "${BASE}/235256_trinity_instar2/"
sbatch -J pycno-trinity-instar3 $SCRIPT "$INPUT"/235257/235257_S51_L004_R1_001.fastq.gz "$INPUT"/235257/235257_S51_L004_R2_001.fastq.gz "${BASE}/235257_trinity_instar3/"
sbatch -J pycno-trinity-instar4 $SCRIPT "$INPUT"/235258/235258_S52_L004_R1_001.fastq.gz "$INPUT"/235258/235258_S52_L004_R2_001.fastq.gz "${BASE}/235258_trinity_instar4/"
sbatch -J pycno-trinity-instar5 $SCRIPT "$INPUT"/235259/235259_S53_L004_R1_001.fastq.gz "$INPUT"/235259/235259_S53_L004_R2_001.fastq.gz "${BASE}/235259_trinity_instar5/"
sbatch -J pycno-trinity-juvenile1 $SCRIPT "$INPUT"/235260/235260_S54_L004_R1_001.fastq.gz "$INPUT"/235260/235260_S54_L004_R2_001.fastq.gz "${BASE}/235260_trinity_juvenile1/"
sbatch -J pycno-trinity-subadult $SCRIPT "$INPUT"/235261/235261_S55_L004_R1_001.fastq.gz "$INPUT"/235261/235261_S55_L004_R2_001.fastq.gz "${BASE}/235261_trinity_subadult/"
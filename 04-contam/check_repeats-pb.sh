#!/usr/bin/env bash
#
#SBATCH --job-name=read_repeats
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=300M
#SBATCH --time=80:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-scan-pb-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-scan-pb-%j.err

# tests:
# 34314 FASTA rows (1% of file)
# /usr/bin/time bwa mem -x pacbio -t 4 ../repeat_modeller/pycno-families.fa onepercent.fasta > test.sam
# needed 49s with 392% CPU usage and 271MB RAM

# 343140 FASTA rows (10% of file)
# /usr/bin/time bwa mem -x pacbio -t 4 ../repeat_modeller/pycno-families.fa tenpercent.fasta > test.sam
# needed 480s wuth 392% CPU usage and 271MB RAM

module load bwa/0.7.18

HIFI="/lisc/scratch/zoology/pycnogonum/raw/m64120_240312_152428.ccs.fasta"
REPEATS="/lisc/scratch/zoology/pycnogonum/genome/draft/repeats/repeat_modeller/pycno-families.fa"
OUTPUT="/lisc/scratch/zoology/pycnogonum/genome/draft/repeats/"

bwa mem -x pacbio -t 4 $REPEATS $HIFI > $OUTPUT/pb.sam
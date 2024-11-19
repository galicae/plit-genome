#!/usr/bin/env bash
#
#SBATCH --job-name=read_repeats
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=5000M
#SBATCH --time=20:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-scan-ont-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-scan-ont-%j.err

# tests:
# 610050 FASTA rows (~1% of file)
# /usr/bin/time bwa mem -x ont2d -t 4 ../repeat_modeller/pycno-families.fa onepercent.fasta > test.sam
# needed 3.2min with 388% CPU usage and 359MB RAM

# 6100500 FASTA rows (~10% of file)
# /usr/bin/time bwa mem -x ont2d -t 4 ../repeat_modeller/pycno-families.fa tenpercent.fasta > test.sam
# needed 54min with 384% CPU usage and 2GB RAM

# first run timed out at 11h (--time=10:00:00) and processed 17,467,334 / 30,502,516 reads, so we 
# need at least 17.5h. Going with 20h to be safe. At least now I know the real memory consumption.

# second run went OOM with 3.5G of RAM, so I'm going with 5G now.

module load bwa/0.7.18

NANOPORE="/lisc/scratch/zoology/pycnogonum/raw/20230601_0904_3C_PAK64436_4d39d6a6/basecalls/202306050/nanopore.fasta"
REPEATS="/lisc/scratch/zoology/pycnogonum/genome/draft/repeats/repeat_modeller/pycno-families.fa"
OUTPUT="/lisc/scratch/zoology/pycnogonum/genome/draft/repeats/"

bwa mem -x ont2d -t 16 $REPEATS $NANOPORE > $OUTPUT/ont.sam
#!/usr/bin/env bash

#SBATCH --job-name=backmap_pycno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=20G
#SBATCH --time=15:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-backmap-pacbio-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-backmap-pacbio-%j.err

module purge 

module load samtools
module load bedtools
# module load bwa # only needed for short reads
module load qualimap
module unload R/4.2.3
module load R
module load perl/5.38.2
export PERL5LIB="/lisc/user/papadopoulos/perl5/lib/perl5"

module load conda
conda activate minimap2-2.28

cd "$TMPDIR" || exit

ASSEMBLY=$1
OUTPUT=$2
mkdir -p "$OUTPUT"

PACBIO="/lisc/scratch/zoology/pycnogonum/raw/m64120_240312_152428.ccs.fasta"
BACKMAP="/lisc/user/papadopoulos/repos/backmap/backmap.pl"

$BACKMAP -a "$ASSEMBLY" \
-hifi $PACBIO \
-o "$OUTPUT" \
-t 16 \
-qo "--java-mem-size=28G"

# copy all the relevant output to the output directory
cp -r "$TMPDIR"/*.bam "$OUTPUT"
# delete $TMPDIR
cd "$OUTPUT" || exit
rm -rf "$TMPDIR"

samtools stats -@ 16 *.bam > stats.txt
#!/usr/bin/env bash
#
#SBATCH --job-name=nextdenovo_pycno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=300G
#SBATCH --time=168:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-nextdenovo-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-nextdenovo-%j.err

module load conda
conda activate nextdenovo

# long read input
NANOPORE="/lisc/scratch/zoology/pycnogonum/raw/20230601_0904_3C_PAK64436_4d39d6a6/basecalls/202306050/PAK64436_1_202306050.fastq.gz"
# nextdenovo path
nextdenovo="/lisc/user/papadopoulos/repos/NextDenovo/nextDenovo"
# output directory
OUTPUT="/lisc/scratch/zoology/pycnogonum/genome/nextdenovo_full/"
mkdir -p "$OUTPUT" || exit 1

# go to $TMPDIR
cd "$TMPDIR" || exit 1

# copy the nanopore reads to $TMPDIR
cp $NANOPORE ./
cp /lisc/user/papadopoulos/repos/NextDenovo/doc/pycno.cfg ./
ls PAK64436_1_202306050.fastq.gz > input.fofn

# run nextdenovo
$nextdenovo pycno.cfg

# copy all the relevant output to the output directory
cp -r "$TMPDIR"/* "$OUTPUT"

# remove $TMPDIR
rm -rf "$TMPDIR"
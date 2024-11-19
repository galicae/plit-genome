#!/usr/bin/env bash
#
#SBATCH --job-name=verkko_controller
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=30-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-verkko-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-verkko-%j.err

module load conda
conda activate verkko

# long read input - ONT
NANOPORE="/lisc/scratch/zoology/pycnogonum/raw/20230601_0904_3C_PAK64436_4d39d6a6/basecalls/202306050/PAK64436_1_202306050.fastq.gz"
# long read input - PacBio CCS
PACBIO=/lisc/scratch/zoology/pycnogonum/raw/m64120_240312_152428.ccs.fastq.gz

# output directory
OUTPUT="/lisc/scratch/zoology/pycnogonum/genome/verkko/"
mkdir -p "$OUTPUT" || exit 1

verkko -d $OUTPUT --hifi $PACBIO --nano $NANOPORE --local-cpus 1 --slurm --snakeopts "--cores 64 --jobs 10"
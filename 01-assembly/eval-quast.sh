#!/usr/bin/env bash
#
#SBATCH --job-name=quast_pycno
#SBATCH --cpus-per-task=1
#SBATCH --mem=600M
#SBATCH --time=10:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-quast-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-quast-%j.err

module load conda
conda activate quast-5.2.0

ASSEMBLY=$1
RESDIR=$2
NAME=$3
mkdir "$RESDIR" -p

quast.py -t 1 \
-l "$NAME" \
-o "$RESDIR" \
--gene-finding \
--eukaryote \
"$ASSEMBLY"
#!/usr/bin/env bash
#
#SBATCH --job-name=busco_pycno
#SBATCH --cpus-per-task=16
#SBATCH --mem=50G
#SBATCH --time=6:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-busco-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-busco-%j.err

module load conda
conda activate busco-5.7.1

RESDIR=$1
FASTA=$2
MODE=$3

BUSCO="/lisc/scratch/zoology/db/busco/"

# mkdir -p "$RESDIR"/busco_arthropoda || exit
mkdir -p "$RESDIR"/busco_metazoa || exit
cd "$TMPDIR" || exit

# busco -i "$FASTA" -l arthropoda -m "$MODE" -o arthropoda -r -c 16 --offline --download_path $BUSCO
busco -i "$FASTA" -l metazoa -m "$MODE" -o metazoa -r -c 16 --offline --download_path $BUSCO

cd "$RESDIR" || exit
# cp -r "$TMPDIR"/arthropoda ./busco_arthropoda/
cp -r "$TMPDIR"/metazoa ./busco_metazoa/
rm -rf "$TMPDIR"
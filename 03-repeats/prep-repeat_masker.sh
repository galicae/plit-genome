#!/usr/bin/env bash
#
#SBATCH --job-name=repeatmasker_pycno
#SBATCH --cpus-per-task=4
#SBATCH --mem=500M
#SBATCH --time=4:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-repeat-masker-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-repeat-masker-%j.err

# RepeatMasker is a lot less resource-intense than RepeatModeler, so it makes sense to run it as a separate script.
# it ran out of memory with 500M, but it's unclear how much the last step needs
module load repeatmasker/4.1.6-3.12.4-5.40.0

SCAFFOLDS=/lisc/scratch/zoology/pycnogonum/genome/draft/draft.fasta
OUTDIR=/lisc/scratch/zoology/pycnogonum/genome/draft/repeats/repeat_masker_gff
mkdir -p "$OUTDIR" || exit 1

cd "$OUTDIR" || exit 1
FAMILIES="../repeat_modeller/pycno-families.fa"

RepeatMasker -pa 4 -xsmall -gff -dir "$TMPDIR" -lib "$FAMILIES" "$SCAFFOLDS"

# copy the results to the output directory:
cp "$TMPDIR"/*.masked "$OUTDIR"/
cp "$TMPDIR"/*.out "$OUTDIR"/
cp "$TMPDIR"/*.tbl "$OUTDIR"/
cp "$TMPDIR"/*.cat* "$OUTDIR"/
cp "$TMPDIR"/*.gff "$OUTDIR"/
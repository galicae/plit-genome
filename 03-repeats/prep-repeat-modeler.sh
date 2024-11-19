#!/usr/bin/env bash
#
#SBATCH --job-name=repeatmodeler_pycno
#SBATCH --cpus-per-task=32
#SBATCH --mem=20G
#SBATCH --time=30:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-repeats-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-repeats-%j.err

# will need optimisation from scratch when I next need it
module load repeatmodeler/2.0.5-5.40.0-1.0.6
# OLDDIR=/lisc/slurm/node-d02/tmp/slurm-9303351

cd "$TMPDIR" || exit 1

OUTDIR=/lisc/scratch/zoology/pycnogonum/genome/draft/repeats/repeat_modeller
SCAFFOLDS=/lisc/scratch/zoology/pycnogonum/genome/draft/draft.fasta

mkdir -p "$OUTDIR" || exit 1

BuildDatabase -name pycno "$SCAFFOLDS"
RepeatModeler -database pycno -threads 32 -LTRStruct > $OUTDIR/repeat_modeller_run.out

# tar "$TMPDIR"/RM_*/ -czf "$OUTDIR"/repeatmodeler.tar.gz
# cp "$TMPDIR"/run.out "$OUTDIR"/run.out

# if the run was successful, there should be three result files:
cp "$TMPDIR"/pycno-families.fa "$OUTDIR"/pycno-families.fa
cp "$TMPDIR"/pycno-families.stk "$OUTDIR"/pycno-families.stk
cp "$TMPDIR"/pycno-rmod.log "$OUTDIR"/pycno-rmod.log
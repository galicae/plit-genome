#!/usr/bin/env bash
#
#SBATCH --job-name=extr_unannot
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=500M
#SBATCH --time=17:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-extract_orfs-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-extract_orfs-%j.err

module load perl/5.40.0
module load transdecoder/5.7.1

DENOVO=$1
OUTPUT=$2

# 228.06user
# 747.90user
# say 1000s = 16-17min

mkdir -p "$OUTPUT" || exit 1
cd "$OUTPUT" || exit 1

# first we need to extract ORFs
TransDecoder.LongOrfs -t "$DENOVO"
# now predict the coding regions
TransDecoder.Predict -t "$DENOVO"
# now convert the resulting .cds file to a single-line fasta
# almost instantaneous
perl -pe '$. > 1 and /^>/ ? print "\n" : chomp' Trinity.fasta.transdecoder.cds > oneline.fasta
# extract complete ORFs. Almost instantaneous.
grep -A1 complete oneline.fasta > complete.fasta
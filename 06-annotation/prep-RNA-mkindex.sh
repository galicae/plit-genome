#!/usr/bin/env bash
#
#SBATCH --job-name=star_pycno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=20G
#SBATCH --time=15:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-star-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-star-%j.err

# GeneMark-ETP utilizes Stringtie2 to assemble RNA-Seq data, which requires that the aligned reads
# (BAM files) contain the XS (strand) tag for spliced reads. Therefore, when aligning with STAR we
# must use the --outSAMstrandField intronMotif option.

module load ngstools/star/2.7.11b

FASTA=$1
ASSEMBLY=$(dirname "$FASTA") # path to the genome directory where the STAR index will be generated
OUTPUT=$ASSEMBLY/transcriptome

mkdir "$OUTPUT" -p || exit

# first go into the assembly directory and create the STAR index
cd "$ASSEMBLY" || exit

# create the STAR index
STAR --runThreadN 30 \
--runMode genomeGenerate \
--genomeDir "$ASSEMBLY" \
--genomeFastaFiles "$FASTA" \
--genomeSAindexNbases 13
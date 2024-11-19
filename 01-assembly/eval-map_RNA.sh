#!/usr/bin/env bash
#
#SBATCH --job-name=star_pycno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=30G
#SBATCH --time=6:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-star-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-star-%j.err

module load ngstools/star/2.7.11a

FASTA=$1
ASSEMBLY=$(dirname "$FASTA") # path to the genome directory where the STAR index was generated
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


BASE="/lisc/scratch/zoology/pycnogonum/raw/HTT33DSX5_4_R15615_20230713/demultiplexed"

EMBRYO3="$BASE/235255/235255_S49"
INSTAR1="$BASE/235253/235253_S47"
INSTAR6="$BASE/235254/235254_S48"
INSTAR2="$BASE/235256/235256_S50"
INSTAR3="$BASE/235257/235257_S51"
INSTAR4="$BASE/235258/235258_S52"
INSTAR5="$BASE/235259/235259_S53"
JUV1="$BASE/235260/235260_S54"
SUBADULT="$BASE/235261/235261_S55"

# put them all in a list
TRANSCRIPTOMES=("$INSTAR1" "$INSTAR6" "$INSTAR2" "$INSTAR3" "$INSTAR4" "$INSTAR5" "$JUV1" "$SUBADULT")

R1="$EMBRYO3"_L004_R1_001.fastq.gz
R2="$EMBRYO3"_L004_R2_001.fastq.gz

# now loop through the list and concatenate the R1/R2 files
for stage in "${TRANSCRIPTOMES[@]}"; do
    R1=$R1,"$stage"_L004_R1_001.fastq.gz
    R2=$R2,"$stage"_L004_R2_001.fastq.gz
done

cd "$TMPDIR" || exit

STAR --runThreadN 30 \
--genomeDir "$ASSEMBLY" \
--readFilesIn "$R1" "$R2" \
--readFilesCommand gunzip -c

# copy relevant files
mkdir "$OUTPUT" -p || exit

cp -r "$TMPDIR"/Log.* "$OUTPUT"/
cp -r "$TMPDIR"/Aligned.* "$OUTPUT"/

# remove $TMPDIR
rm -rf "$TMPDIR"
#!/usr/bin/env bash
#
#SBATCH --job-name=pycno_braker
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=18
#SBATCH --mem=40G
#SBATCH --time=20:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-braker-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-braker-%j.err

module load conda
conda activate singularity

# container location
BRAKER=/lisc/user/papadopoulos/containers/braker3.sif
# path to the output directory, where all the magic should happen
OUTPUT=/lisc/scratch/zoology/pycnogonum/genome/draft/braker
mkdir "$OUTPUT" -p || exit
cd "$OUTPUT" || exit

# copy AUGUSTUS config files for BRAKER
cp -r ~/repos/Augustus/config .

# define input files
# the genome assembly
GENOME=/lisc/scratch/zoology/pycnogonum/genome/draft/draft_softmasked.fasta
# the RNA-seq dataset BAMs
BASE=/lisc/scratch/zoology/pycnogonum/genome/draft/transcriptome
ZYGOTE="$BASE/ZYGOTE/Aligned.out.bam"
EARLY_CLEAVAGE="$BASE/EARLY_CLEAVAGE/Aligned.out.bam"
EMBRYO0_1="$BASE/EMBRYO0_1/Aligned.out.bam"
EMBRYO3_5="$BASE/EMBRYO3_5/Aligned.out.bam"
EMBRYO9_10="$BASE/EMBRYO9_10/Aligned.out.bam"
EMBRYO3="$BASE/EMBRYO3/Aligned.out.bam"
INSTAR1="$BASE/INSTAR1/Aligned.out.bam"
INSTAR2="$BASE/INSTAR2/Aligned.out.bam"
INSTAR3="$BASE/INSTAR3/Aligned.out.bam"
INSTAR4="$BASE/INSTAR4/Aligned.out.bam"
INSTAR5="$BASE/INSTAR5/Aligned.out.bam"
INSTAR6="$BASE/INSTAR6/Aligned.out.bam"
JUV1="$BASE/JUV1/Aligned.out.bam"
SUBADULT="$BASE/SUBADULT/Aligned.out.bam"
# the Arthropoda OrthoDB protein sequences
ARTHROPODA=/lisc/scratch/zoology/db/Arthropoda.fa

# now call the container. Important to mount the current directory, /scratch/, and the $TMPDIR,
# in case it is needed.
singularity exec -B "$PWD,/lisc/scratch/zoology/,$TMPDIR" "$BRAKER" braker.pl \
--AUGUSTUS_CONFIG_PATH="${PWD}"/config \
--genome=$GENOME \
--prot_seq=$ARTHROPODA \
--bam="$ZYGOTE","$EARLY_CLEAVAGE","$EMBRYO0_1","$EMBRYO3_5","$EMBRYO9_10","$EMBRYO3","$INSTAR1","$INSTAR2","$INSTAR3","$INSTAR4","$INSTAR5","$INSTAR6","$JUV1","$SUBADULT" \
--softmasking \
--threads 18
#!/usr/bin/env bash
#
#SBATCH --job-name=pycno-chromap
#SBATCH --cpus-per-task=16
#SBATCH --mem=15G
#SBATCH --time=1:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-scaf-chromap-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-scaf-chromap-%j.err

# I had trouble figuring out how to correctly run YAHS so I asked Darrin. He pointed me to his
# genome assembly pipeline repository and in particular the yahs rulefile
# (https://github.com/conchoecia/genome_assembly_pipelines/blob/master/snakefiles/GAP_yahs). I tried
# installing/running that on my mac but ran into stupid issues because of clang/llvm problems.

# I don't think I can run the snakemake workflow on the cluster as-is. since it isn't optimised for
# our cluster and will try to install stuff instead of using already existing modules. I will
# instead try to run all the steps one by one and adapt the rules to LiSC/SLURM scripts.

# part 1: from raw files to YAHS input

module load conda
conda activate chromap

module load samtools

# ASSEMBLY="/lisc/scratch/zoology/pycnogonum/genome/flye_full/assembly.fasta"
ASSEMBLY="/lisc/scratch/zoology/pycnogonum/genome/draft/draft.fasta"
R1="/lisc/scratch/zoology/pycnogonum/raw/omniC/DTG_OmniC_1016_R1.fastq"
R2="/lisc/scratch/zoology/pycnogonum/raw/omniC/DTG_OmniC_1016_R2.fastq"
OUT="/lisc/scratch/zoology/pycnogonum/genome/draft/chromap"

mkdir -p $OUT
cd $OUT || exit

# index ref (line 100)
chromap -i -r $ASSEMBLY -o asm.index
# hic to pairs (line 112)
chromap --preset hic -x asm.index -r $ASSEMBLY -1 $R1 -2 $R2 -t 16 -q 5 -o asm_q_5.pairs
# possibly run with -q 0 to figure out true number of chromosomes?
# hic to sam (line 138)
chromap --preset hic -x asm.index -r $ASSEMBLY -1 $R1 -2 $R2 -t 16 --SAM -o asm_hic.sam

# sam to bam (line 163)
samtools view -@ 16 -hb asm_hic.sam | samtools sort -@ 16 -o asm_hic.sorted.bam
# index assembly (line 204)
samtools faidx $ASSEMBLY
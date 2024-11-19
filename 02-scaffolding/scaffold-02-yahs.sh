#!/usr/bin/env bash
#
#SBATCH --job-name=pycno-yahs
#SBATCH --cpus-per-task=1
#SBATCH --mem=25G
#SBATCH --time=20:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-scaf-yahs-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-scaf-yahs-%j.err

# I had trouble figuring out how to correctly run YAHS so I asked Darrin. He pointed me to his
# genome assembly pipeline repository and in particular the yahs rulefile
# (https://github.com/conchoecia/genome_assembly_pipelines/blob/master/snakefiles/GAP_yahs). I tried
# installing/running that on my mac but ran into stupid issues because of clang/llvm problems. I am
# adapting the rules to SLURM scripts.

# rule run_yahs_on_the_data (line 237)
module load yahs/1.2a.2

ASSEMBLY="/lisc/scratch/zoology/pycnogonum/genome/flye_full/assembly.fasta"
BAM="/lisc/scratch/zoology/pycnogonum/genome/flye_full/darrin/asm_hic.sorted.bam"
OUT="/lisc/scratch/zoology/pycnogonum/genome/flye_full/darrin/"

mkdir -p "$OUT" || exit 1

yahs -o $OUT/yahs.out --no-contig-ec --no-scaffold-ec --no-mem-check -v 2 $ASSEMBLY $BAM
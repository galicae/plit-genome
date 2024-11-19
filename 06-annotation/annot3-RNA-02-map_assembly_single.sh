#!/usr/bin/env bash
#
#SBATCH --job-name=mmap_pycno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --mem=10G
#SBATCH --time=5:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-map-txome-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-map-txome-%j.err

# with 1% of data and 3 CPUs:
# [M::main] Real time: 448.742 sec; CPU: 1260.678 sec; Peak RSS: 1.830 GB
# 1251.43user 9.26system 7:28.76elapsed 280%CPU (0avgtext+0avgdata 1919296maxresident)k

# with 10% of data and 3 CPUs:
# [M::main] Real time: 1528.465 sec; CPU: 3772.846 sec; Peak RSS: 2.758 GB
# 3743.86user 29.02system 25:28.51elapsed 246%CPU (0avgtext+0avgdata 2892008maxresident)k
# BUT THAT WAS WITH THE WRONG ARGUMENT ORDER, it is much faster the other way round

module load conda
conda activate minimap2-2.28

TXOME=$1
OUTPUT=$2
DRAFT=/lisc/scratch/zoology/pycnogonum/genome/draft/draft.fasta

cd "$TMPDIR" || exit
minimap2 -ax splice:hq $DRAFT "$TXOME" > "$OUTPUT"/txome_assembly.sam
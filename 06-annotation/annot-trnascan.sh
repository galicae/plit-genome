#!/usr/bin/env bash
#
#SBATCH --job-name=pycno_trnascan
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=500M
#SBATCH --time=1:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-trnascan-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-trnascan-%j.err

module load trnascan

# Testing was performed with a FASTA file with 60 chars/line.

# | CPUs | input size (lines) | real time | max memory | CPU util. |
# |------|--------------------|-----------|------------|-----------|
# | 1    | 78753              | 45s       | 57.5Mb     | 97%       | 
# | 2    | 78753              | 31s       | 97Mb       | 142%      | 
# | 4    | 78753              | 30s       | 16.8Mb     | 182%      | (testing)
# | 1    | 787530             | 7:04      | 172Mb      | 98%       |
# | 2    | 787530             | 4:58      | 225Mb      | 145%      |
# | 4    | 787530             | 4:12      | 336Mb      | 188%      |
# |------|--------------------|-----------|------------|-----------|
# | 2    | 7875382            | 53:40     | 304Mb      | 60%       | (run)

ASSEMBLY=/lisc/scratch/zoology/pycnogonum/genome/draft/draft.fasta
OUTPUT=/lisc/scratch/zoology/pycnogonum/genome/draft/trnascan/
mkdir "$OUTPUT" -p || exit

cd "$OUTPUT" || exit

tRNAscan-SE \
-o trnascan.out \
-f trnascan.fasta \
-b trnascan.bed \
--stats trnascan.stats \
--progress \
--hitsrc \
--thread 2 \
"$ASSEMBLY"
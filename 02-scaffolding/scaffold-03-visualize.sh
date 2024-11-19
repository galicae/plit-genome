#!/usr/bin/env bash
#
#SBATCH --job-name=pycno-juicer
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=1:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-scaf-juicer-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-scaf-juicer-%j.err

# I had trouble figuring out how to correctly run YAHS so I asked Darrin. He pointed me to his
# genome assembly pipeline repository and in particular the yahs rulefile
# (https://github.com/conchoecia/genome_assembly_pipelines/blob/master/snakefiles/GAP_yahs). I tried
# installing/running that on my mac but ran into stupid issues because of clang/llvm problems. I am
# adapting the rules to SLURM scripts.

# rule generate_long_file_for_JBAT (line 259)
module load yahs/1.2a.2

INDEX="/lisc/scratch/zoology/pycnogonum/genome/flye_full/assembly.fasta.fai"
BIN="/lisc/scratch/zoology/pycnogonum/genome/flye_full/scaffold/yahs.out.bin"
AGP="/lisc/scratch/zoology/pycnogonum/genome/flye_full/scaffold/yahs.out_scaffolds_final.agp"
ASSEMBLY="/lisc/scratch/zoology/pycnogonum/genome/flye_full/scaffold/yahs.out_scaffolds_final.fa.assembly"
OUT="/lisc/scratch/zoology/pycnogonum/genome/flye_full/scaffold/"

cd $OUT || exit 1

juicer pre $BIN $AGP $INDEX | \
    sort -k2,2d -k6,6d -k3,3n -k7,7n -T ./ --parallel=16 -S32G | \
    awk 'NF' | \
    awk '$2<=$6{{print $1, $2, $3, $4, 0, $6, $7, $8, "1 - - 1  - - -" }} \
            $6<$2{{print $1, $6, $7, $4, 0, $2, $3, $8, "1 - - 1  - - -" }}' > yahs_out_scaffolds_final.long

LONG="/lisc/scratch/zoology/pycnogonum/genome/flye_full/scaffold/yahs_out_scaffolds_final.long"

# rule generate_assembly_for_hic_gen (line 308)
AWKSCRIPT="/lisc/user/papadopoulos/repos/genome_assembly_pipelines/bin/generate-assembly-file-from-fasta.awk"
awk -f $AWKSCRIPT yahs.out_scaffolds_final.fa > yahs.out_scaffolds_final.fa.assembly

# rule JBAT_pairs_to_hic (line 338)"
cd "$TMPDIR" || exit 1

VIS3DDNA="/lisc/user/papadopoulos/repos/3d-dna/visualize/run-assembly-visualizer.sh"
# make a hic file
bash $VIS3DDNA -p false $ASSEMBLY $LONG || true
# move to result dir, get out, delete TMPDIR
cp "$TMPDIR"/*.hic $OUT
cd $OUT || exit 1
rm -rf "$TMPDIR"
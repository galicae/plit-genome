#!/usr/bin/env bash
#
#SBATCH --job-name=pycno_filter
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --time=5:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-filter-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-filter-%j.err

module load samtools

TXOME=$1

cd "$TXOME" || exit
samtools view -@2 -F 0x900 -q 30 -S -b txome_assembly.sam > txome_assembly.hd.bam


module load conda
conda activate agat-1.4.0

agat_convert_minimap2_bam2gff.pl -i txome_assembly.hd.bam -o txome_assembly.gff
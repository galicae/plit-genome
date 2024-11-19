#!/usr/bin/env bash
#
#SBATCH --job-name=star_pycno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=32G
#SBATCH --time=2:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-star-worker-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-star-worker-%j.err

# GeneMark-ETP utilizes Stringtie2 to assemble RNA-Seq data, which requires that the aligned reads
# (BAM files) contain the XS (strand) tag for spliced reads. Therefore, when aligning with STAR we
# must use the --outSAMstrandField intronMotif option.

# rule minimap2_txome_to_genome:
#     input:
#         assem = config["REF"],
#         txome = config["TXOME"]
#     output:
#         bam = config["tool"] + "/output/bams/txome_to_ref.filtered.sorted.bam"
#     threads: workflow.cores - 1
#     params:
#         sort_threads = int(workflow.cores/5)
#     shell:
#         """
#         minimap2 -t {threads} -ax splice {input.assem} {input.txome} | \
#            samtools view -F 4 -q 10 -hb -@ {params.sort_threads} - | \
#            samtools sort -@ {params.sort_threads} - > {output.bam}
#         """

# rule minimap2_long_to_genome:
#     input:
#         assem = config["REF"],
#         txome = config["LONGREADS"]
#     output:
#         bam = config["tool"] + "/output/bams/long_to_ref.filtered.sorted.bam"
#     threads: workflow.cores - 1
#     params:
#         sort_threads = int(workflow.cores/5)
#     shell:
#         """
#         minimap2 -t {threads} -ax splice:hq {input.assem} {input.txome} | \
#            samtools view -F 4 -q 10 -hb -@ {params.sort_threads} - | \
#            samtools sort -@ {params.sort_threads} - > {output.bam}
#         """

module load ngstools/star/2.7.11b

ASSEMBLY=$1
STAGENAME=$2
STAGE=$3
OUTPUT=$ASSEMBLY/transcriptome/$STAGENAME

mkdir "$OUTPUT" -p || exit

R1="$STAGE"_R1_001.fastq.gz
R2="$STAGE"_R2_001.fastq.gz

cd "$TMPDIR" || exit

STAR --runThreadN 30 \
--outSAMstrandField intronMotif \
--genomeDir "$ASSEMBLY" \
--readFilesIn "$R1" "$R2" \
--readFilesCommand gunzip -c

cp -r "$TMPDIR"/Log.* "$OUTPUT"/
cp -r "$TMPDIR"/Aligned.* "$OUTPUT"/

# remove $TMPDIR
rm -rf "$TMPDIR"
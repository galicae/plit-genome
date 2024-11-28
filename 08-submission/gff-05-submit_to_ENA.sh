#!/usr/bin/env bash

# submit the GFF3 file to ENA. Assumes we are in the submission directory
# and the genome manifest file is present and valid.
module load java

MODE=$1 # either -validate or -submit

cd /lisc/scratch/zoology/pycnogonum/genome/submission || exit

java -jar ~/bin/webin-cli-8.0.0.jar \
    -context genome \
    -userName Webin-68127 \
    -passwordFile ~/webin.pwd \
    -manifest genome.manifest \
    "$MODE"
#!/usr/bin/env bash

# a script to keep track of what I have aligned against what
# so we can find it again when it is time to write the paper.

# references
FLYE=/Users/npapadop/Documents/data/sequences/plit/flye.fasta
SHASTA=/Users/npapadop/Documents/data/sequences/plit/shasta.fasta
HIFIASM=/Users/npapadop/Documents/data/sequences/plit/hifiasm.fa
FLYE_OMNI=/Users/npapadop/Documents/data/sequences/plit/draft_filtered.fasta

# output format
M8FORMAT="query,target,fident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,qlen"

# queries
SMART_ARACHNIDA_HOX=/Users/npapadop/Documents/data/sequences/plit/2023-10-16_SMART_arachnida.fasta
NCBI_CHELICERATA_HOX=/Users/npapadop/Documents/data/sequences/plit/2023-10-16_chelicerata-hox.fasta
PYCLIT_HOX=/Users/npapadop/Documents/data/sequences/plit/Plit_HoxGenes.fasta

WORKDIR=/Users/npapadop/Documents/projects/pycnogonum/2024-05-28_wnt_finder
mkdir -p $WORKDIR
cd $WORKDIR || exit 1

### Finding hox genes
cd /Users/npapadop/Documents/projects/pycnogonum/2023-10-16_hox_finder || exit 1
mmseqs easy-search $SMART_ARACHNIDA_HOX $SHASTA smart_shasta.m8 tmp
mmseqs easy-search $SMART_ARACHNIDA_HOX $HIFIASM smart_hifiasm.m8 tmp
mmseqs easy-search $SMART_ARACHNIDA_HOX $FLYE_OMNI smart_draft.m8 tmp
mmseqs easy-search $NCBI_CHELICERATA_HOX $FLYE ncbi_flye.m8 tmp
mmseqs easy-search $NCBI_CHELICERATA_HOX $SHASTA ncbi_shasta.m8 tmp
mmseqs easy-search $NCBI_CHELICERATA_HOX $HIFIASM ncbi_hifiasm.m8 tmp
mmseqs easy-search $NCBI_CHELICERATA_HOX $FLYE_OMNI ncbi_draft.m8 tmp

### Using hand-picked hox gene sequences
cd /Users/npapadop/Documents/projects/pycnogonum/2023-10-16_hox_finder || exit 1
mmseqs easy-search $PYCLIT_HOX $FLYE pyclit.m8 tmp --format-output $M8FORMAT
mmseqs easy-search $PYCLIT_HOX $FLYE_OMNI pyclit.m8 tmp --format-output $M8FORMAT
mmseqs easy-search $BRANCHO_ABDA $FLYE abda.m8 tmp --format-output $M8FORMAT
mmseqs easy-search $BRANCHO_ABDA contig_2855.fa abda.m8 tmp --format-output $M8FORMAT
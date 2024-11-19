#!/usr/bin/env bash

# put de novo transcriptomes in an array
BASE="/scratch/zoology/pycnogonum/transcriptome/development"

embryonic_stage34=$BASE/embryonic_stage3-4
instarI_protonymphon=$BASE/instarI-protonymphon
instar_II=$BASE/instar_II
instar_III=$BASE/instar_III
instar_IV=$BASE/instar_IV
instar_V=$BASE/instar_V
instar_VI=$BASE/instar_VI
juvenile_I=$BASE/juvenile_I
subadult=$BASE/subadult

TXOMES=("$embryonic_stage34" "$instarI_protonymphon" "$instar_II" "$instar_III" "$instar_IV" "$instar_V" "$instar_VI" "$juvenile_I" "$subadult")

# define BUSCO script
BUSCO=/lisc/user/papadopoulos/repos/pycno-seq/nanopore/eval-busco.sh

# loop over the assemblies and submit the BUSCO job for each
for LOC in "${TXOMES[@]}"; do
  sbatch "$BUSCO" "$LOC" "$LOC"/Trinity.fasta
done

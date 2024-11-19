#!/usr/bin/env bash

# This script is used to start all evaluation analysis for the different genome assemblies

# keep track of our assemblies
BASE="/lisc/scratch/zoology/pycnogonum/genome"
FLYE=${BASE}/flye_full/assembly.fasta
SCAFFOLD=${BASE}/draft/draft.fasta
REPEATS=${BASE}/draft/draft_softmasked.fasta
SHASTA=${BASE}/shasta_full/Assembly.fasta


# put assemblies in an array
ASSEMBLIES=("$SCAFFOLD")
NAMES=("draft")

# I will check three things for each assembly:
# 1. BUSCO
# 2. QUAST
# 3. RNAseq mapping
# 4. mapping to the Nymphon genome
# 5. DNA backmapping

##### Tools
BUSCO=/lisc/user/papadopoulos/repos/pycno-seq/nanopore/eval-busco.sh
QUAST=/lisc/user/papadopoulos/repos/pycno-seq/nanopore/eval-quast.sh
STAR=/lisc/user/papadopoulos/repos/pycno-seq/nanopore/eval-map_RNA.sh
BACKMAP_ONT=/lisc/user/papadopoulos/repos/pycno-seq/nanopore/eval-backmap-ont.sh
BACKMAP_PB=/lisc/user/papadopoulos/repos/pycno-seq/pacbio/eval-backmap-pb.sh

# loop over the assemblies and names and submit the evaluation jobs for each
# use the appropriate name for each assembly
for i in "${!ASSEMBLIES[@]}"; do
  # BUSCO completeness
  ASSEMBLY=${ASSEMBLIES[$i]}
  RESDIR=$(dirname "$ASSEMBLY")
  sbatch "$BUSCO" "$RESDIR" "$ASSEMBLY"

  # quast for basic assembly qc stats
  NAME=${NAMES[$i]}
  RESDIR=$(dirname "$ASSEMBLY")
  sbatch "$QUAST" "$ASSEMBLY" "$RESDIR"/quast "$NAME"

  # map RNA reads with STAR
  sbatch "$STAR" "$ASSEMBLY"
  
  # map the DNA reads to the assembly with backmap
  RESDIR=$(dirname "$ASSEMBLY")/backmap/
  sbatch $BACKMAP_ONT "$ASSEMBLY" "$RESDIR"/backmap/ont
  sbatch $BACKMAP_PB "$ASSEMBLY" "$RESDIR"/backmap/pacbio
done

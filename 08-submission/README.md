# Submission

Utility scripts for data upload to ENA.

- [EMBL format conversion](convert_to_embl.sh) for an annotated genome (Fasta + GFF3) - inspired
  from a [prokka issue](https://github.com/tseemann/prokka/issues/145), leading to
  [GFF3toEMBL](https://github.com/sanger-pathogens/gff3toembl) and eventually to the real solution,
  [EMBLmyGFF3](https://github.com/NBISweden/EMBLmyGFF3).
- A [Python script](txome_manifest.py) to batch-create manifest files for de novo transcriptome
  submissions to ENA.
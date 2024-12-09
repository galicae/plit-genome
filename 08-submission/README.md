# Submission

Utility scripts for data upload to ENA. This was very difficult to figure out.

## Raw data submission

Constructing manifest files for the raw data was fairly straightforward following the
[ENA documentation](https://ena-docs.readthedocs.io/en/latest/index.html), especially the part
concerning [raw reads submission](https://ena-docs.readthedocs.io/en/latest/submit/reads.html).

## Assembled transcriptome submission

Since we had a lot of time points, we wrote a custom [Python script](txome_manifest.py) to
batch-create manifest files for all the _de novo_ assembled transcriptomes. This was also relatively
straightforward, especially the transcriptome assembly [submission
guide](https://ena-docs.readthedocs.io/en/latest/submit/assembly/transcriptome.html).

## Assembled genome with functional annotation

This was a pain to get right, and required two-three weeks to get right; and we still weren't able
to include functional information like predicted functions, PFAM domains, or EC numbers.

ENA requires that annotated genome assemblies be submitted as EMBL files. To control the process, we
wrote a [Makefile](./Makefile). This was an excellent decision to make early in the submission
procedure, as we ended up having to finetune and re-run the entire thing multiple times. The steps
are:

1. [compose](gff-01-compose_gff.sh) the GFF by combining the protein coding gene models (Isoseq,
   BRAKER3 round 1, BRAKER3 round 2, de novo assembled transcriptomes), and the tRNA prediction. We
   also manually replaced three gene models that were incorrectly split up with an earlier BRAKER3
   gene model. At this stage, we officially renamed pseudochromosomes 54-59 to 52-57, and sort the 
   resulting GFF file.
2. [annotate](gff-02-functional_annot.ipynb) the GFF by adding information from EggNOG-mapper. We
   need a [wrapper script](gff-02-functional_annot.sh) for that, since using conda environments is
   rather tricky with `make`. The information added, if present, is the proposed gene symbol,
   function description, EC number, and PFAM domains identified.
3. [conform](gff-03-ENA_conform.sh) the GFF to ENA standards. This step flags short introns (less
   than 10 bases, presumably created by polymerase slippage or post-transcriptional modifications)
   with the `pseudo` tag, ensuring that the ENA validator doesn't complain about them. A previous
   version (commented out) [extracted](gff-03-build_kill_list.py) the offending exons into a new GFF
   file; this approach was abandoned because it had to extract entire genes, which was beside the
   point.
4. [convert](gff-04-convert_to_embl.sh) the GFF to EMBL format by combining it with the FASTA file.
   Uses [EMBLmyGFF3](https://github.com/NBISweden/EMBLmyGFF3) (and a lot of the useful information
   provided in its solved and unsolved GitHub issues, the true source of most useful information
   about ENA). Before running the real script, one has to run `EMBLmyGFF3` with the
   `--expose-translations` and modify the resulting .json file in order to suppress exons (as this
   will create the "abutting features cannot be adjacent" error that the validator throws).
5. [submit](gff-05-submit_to_ENA.sh) the EMBL file to ENA. The manifest file and the chromosome file
   still have to be written separately.

Big thanks to [Jacques Dainat](https://github.com/Juke34), who wrote and is maintaining
[AGAT](https://github.com/NBISweden/AGAT) and [EMBLmyGFF3](https://github.com/NBISweden/EMBLmyGFF3),
as well as diligently answering questions and resolving issues.
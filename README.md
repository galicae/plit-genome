# The _Pycnogonum litorale_ (Strøm, 1762) draft genome

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14188290.svg)](https://doi.org/10.5281/zenodo.14188290)

This repository contains the computational analysis for the P. litorale draft genome manuscript. The
code is split up by task, and should roughly correspond to the respective "Materials and Methods"
sections of the manuscript.

1. **Assembly:** code for read QC and genome assembly.
2. **Scaffolding:** code for scaffolding with `yahs`.
3. **Repeats:** repeat prediction and annotation.
4. **Contam:** analysis of repeats and possible contaminants; contaminant removal.
5. **Transcriptomes:** de-novo assembly of deeply sequenced developmental transcriptomes.
6. **Annotation:** prediction of protein-coding genes and tRNAs.
7. **Analysis:** downstream analysis; placing _P. litorale_ in the chelicerate/arthropod context,
   finding Hox genes, functional annotation with EggNOG-mapper.
8. **Submission:** scripts to handle ENA submission.

The project's raw data can be found on ENA under project accession [PRJEB80537](). Additional (intermediate) results
have been uploaded to Zenodo under the DOI [10.5281/zenodo.14185694](https://zenodo.org/records/14185694).

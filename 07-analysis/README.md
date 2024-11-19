# Analysis

The code in this folder concerns downstream analysis after genome assembly and annotation.

### _Pycnogonum litorale_ in the chelicerate/arthropod context

To gain a first understanding of the _P. litorale_ genome we compared it to publicly available
genome assemblies for arthropods in general and chelicerates in particular using common metrics.
This notebook produced most of the material for figures 2 and 3 in the manuscript.

- [The genome assembly of _P. litorale_ in the broader arthropod/chelicerate context](genomic_context.ipynb)

### Hox genes

We used manually curated CDS's for _P. litorale_ Hox genes to locate them in the genome. The
putative CDS's overlap with predicted gene models and form a single cluster on pseudochromosome 56.
All Hox genes are present, except for _Hox9/abdominalA_, for which contradicting data exists for
pycnogonids. This notebook produced material for figure 4 and suppl. figure 3 of the manuscript.

- [Exploring Hox genes](hoxfinder.ipynb)

We also used other published Hox gene sequences to confirm our search results.

- [Hox gene searches](genes.sh)

### EggNOG-mapper output

A brief look at the functional annotation provided by EggNOG-mapper for the predicted pycnogonid
peptide sequences, broken down by prediction quality (also see how the annotation [was
produced](../06-annotation/README.md)). We find that annotation quality correlates with annotation
confidence (Iso-seq > BRAKER round 1 > BRAKER round 2 > de-novo).

- [functional annotation overview](emapper_output.ipynb)
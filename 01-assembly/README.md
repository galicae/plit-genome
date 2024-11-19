# Genome assembly

Code in this folder covers the steps from receiving the data until producing a favored draft
assembly for scaffolding.

### Preprocessing

To estimate genome size, we counted kmers for the [ONT](preprocess-jellyfish_count-ont.sh) and
[PacBio](preprocess-jellyfish_count-pb.sh) data using $k=21$. The resulting k-mer spectra were
analyzed with [GenomeScope](http://genomescope.org) and
[GenomeScope2](http://genomescope.org/genomescope2.0/).

### Assembly

The sequencing coverage was enough for robust genome size estimates (and also ONT data is
technically not meant for k-mer spectrum analysis because of the high error rates). Since some
genome assemblers require an estimated genome size, we assumed a genome size around 500Mb.

We tried out a variety of assemblers, mostly on the ONT data.

- [canu v2.2](assemble-canu.sh) (ONT)
- [flye v2.9.2](assemble-flye.sh) (ONT)
- [shasta v.0.11.1](assemble-shasta.sh) (ONT)
- [Verkko v2.0](assemble-verkko.sh) (ONT)
- [NextDenovo v2.5.2](assemble-nextdenovo.sh) (ONT)
- [flye v2.9.2](assemble-flye-pb.sh) (PacBio)
- [hifiasm v0.19.8](assemble-hifiasm.sh) (PacBio)


### Evaluation

Multiple tools failed, or required such extensive troubleshooting that we decided against using
them. We performed basic QC on each finished assembly with the
[`evaluate_assemblies.sh`](evaluate_assemblies.sh) script.

- basic statistics with `quast`,
- assessed completeness of metazoan and arthropod single-copy ortholog genes with `BUSCO`,
- mapped available RNA-seq data onto the assembly,
- mapped the ONT and PacBio data back to the assembly.

The best assembly, in terms of contiguity and BUSCO completeness, was produced by Flye using the ONT
data; this assembly was kept for further work.

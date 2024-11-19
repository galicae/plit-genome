# Developmental transcriptomes

We obtained developmental transcriptomes from different stages of *Pycnogonum litorale* development.
Staging was done after molts, where possible. The following stages were sampled:

- embryonic stage 3-4
- instar I-protonymphon
- instar II
- instar III
- instar IV
- instar V
- instar VI
- juvenile I
- subadult

The samples were sequenced on the Illumina NovaSeq platform, with 150bp paired-end reads.

We also obtained short-read sequencing data from our collaborators, though at lower sequencing
coverage:

- zygote
- early cleavage
- embryo 0-1
- embryo 3-5
- embryo 9-10
- mixed instar II-V

We also generated long-read HiFi datasete from mixed developmental stages of _Pycnogonum litorale_
as part of a multiplexed Iso-seq run, together samples from two further species.

### Short-read de novo transcriptome assembly

We assembled the deeply sequenced short-read transcriptomes (embryonic stage 3-4, instar
I-protonymphon, instar II, instar III, instar IV, instar V, instar VI, juvenile I, subadult) with
Trinity.

- [`assemble-all-sep.sh`](assemble-all-sep.sh): main script, submits single scripts
- [`assemble-single.sh`](assemble-single.sh): commands to assemble a single dataset

### Iso-seq processing

We followed the protocol for Iso-seq processing as [described by the
manufacturer](https://isoseq.how/clustering/)

- Produce [consensus](isoseq-01-consensus.sh) HiFi reads from the ZMWs.
- Remove primers and identify barcodes with [`lima`](isoseq-02-lima.sh) 
- Trim poly(A) tails and remove concatemers with [`refine`](isoseq-03-refine.sh) 
- [Cluster](isoseq-04-cluster.sh) the reads into isoforms
- [Align](isoseq-05-align.sh) to the genome

### Evaluation

We [evaluated](eval-busco.sh) the de-novo assemblies with BUSCO v5.2.0, using the arthropoda_odb10
database.

| stage                 | complete | single | duplicated | fragmented | missing | total |
|-----------------------|----------|--------|------------|------------|---------|-------|
| embryonic_stage3-4    | 98.1%    | 44.7%  | 53.4%      | 0.7%       | 1.2%    | 1013  |
| instar_I-protonymphon | 98.8%    | 47.3%  | 51.5%      | 0.7%       | 0.5%    | 1013  |
| instar_II             | 99.4%    | 42.3%  | 57.1%      | 0.3%       | 0.3%    | 1013  |
| instar_III            | 99.2%    | 43.5%  | 55.7%      | 0.4%       | 0.4%    | 1013  |
| instar_IV             | 99.2%    | 37.3%  | 61.9%      | 0.4%       | 0.4%    | 1013  |
| instar_V              | 99.3%    | 44.7%  | 54.6%      | 0.4%       | 0.3%    | 1013  |
| instar_VI             | 99.0%    | 47.0%  | 52.0%      | 0.5%       | 0.5%    | 1013  |
| juvenile_I            | 99.2%    | 44.1%  | 55.1%      | 0.4%       | 0.4%    | 1013  |
| subadult              | 99.3%    | 47.5%  | 51.8%      | 0.2%       | 0.5%    | 1013  |

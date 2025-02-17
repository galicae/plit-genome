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

### Assembly overview

<details>
<summary>Click to expand</summary>

| Assembly                   | shasta         | flye        | M2 flye_pb       | hybrid long read | verkko     | wengan pretend     | HiFiasm (hic.p_ctg) |
|----------------------------|----------------|-------------|------------------|------------------|------------|--------------------|---------------------|
| type                       | ONT            | ONT         | HiFi             | ONT + HiFi       | ONT + HiFi | HiFi contigs + ONT | HiFi + ONT + omniC  |
| # contigs (>= 1000 bp)     | 14,656         | 10,856      | 7,696            | 11,948           |            |                    | 1,901               |
| # contigs (>= 0 bp)        | 14,747         | 13,520      | 7,758            | 11,948           |            |                    | 1,849               |
| **# contigs (>= 5000 bp)** | **13,996**     | **3,429**   | **7,114**        | **11,948**       |            |                    | **1,773**           |
| # contigs (>= 10000 bp)    | 12,607         | 2,677       | 6,049            | 3,000            |            |                    | 1,579               |
| # contigs (>= 25000 bp)    | 7,025          | 1,824       | 3,808            | 1,732            |            |                    | 1,243               |
| # contigs (>= 50000 bp)    | 3,438          | 1,321       | 2,398            | 1,101            |            |                    | 771                 |
| Total length (>= 0 bp)     | 569,965,269    | 529,880,842 | 524,250,265      | 243,039,200      |            |                    | 564,656,146         |
| Total length (>= 1000 bp)  | 569,921,876    | 528,047,687 | 524,207,443      | 243,039,200      |            |                    | 564,638,380         |
| Total length (>= 5000 bp)  | 567,841,097    | 508,723,655 | 522,258,094      | 243,039,200      |            |                    | 564,373,315         |
| Total length (>= 10000 bp) | 557,002,179    | 503,406,950 | 514,264,131      | 187,137,640      |            |                    | 562,919,782         |
| Total length (>= 25000 bp) | 465,488,885    | 489,576,998 | 476,997,904      | 167,428,257      |            |                    | 557,004,365         |
| Total length (>= 50000 bp) | 337,359,041    | 471,872,883 | 427,261,245      | 144,927,648      |            |                    | 539,726,847         |
| **#contigs**               | **14,697**     | **13,427**  | **7,752**        | **11,948**       |            |                    | **1,862**           |
| Largest contig             | 1,578,167      | 4,458,759   | 3,173,197        | 1,238,400        |            |                    | 7,914,832           |
| Total length               | 569,952,592    | 529,844,325 | 524,248,151      | 243,039,200      |            |                    | 564,647,311         |
| GC (%)                     | 39.72          | 40.21       | 40.09            | 39.92            |            |                    | 39.63               |
| N50                        | 62,769         | 522,825     | 192,982          | 79,409           |            |                    | 1,768,572           |
| N90                        | 17,100         | 42,521      | 27,270           | 5,963            |            |                    | 165,091             |
| auN                        | 96,209.9       | 743,185.5   | 277,025.8        | 135,514.7        |            |                    | 2,321,162.2         |
| L50                        | 2,506          | 277         | 757              | 728              |            |                    | 90                  |
| L90                        | 9,314          | 1,430       | 3,610            | 7,492            |            |                    | 410                 |
| # N's per 100 kbp          | 0.00           | 0.00        | 0.00             | 0.00             |            |                    | 0.00                |
|                            |                |             |                  |                  |            |                    |                     |
| Approx. runtime (CPUs)     | 45m (48)       | 21h (30)    | 6:15 (16)        | 18h (32)         | (breaks)   | (oom)              | 13h (32)            |
|                            |                |             |                  |                  |            |                    |                     |
| BUSCO metazoa complete     | 86.2% (arthr.) | 94.2%       | ?                | ?                | ?          | ?                  | 97.1%               |
| BUSCO metazoa single       | 72.8% (arthr.) | 87.8%       | ?                | ?                | ?          | ?                  | 89.9%               |
| BUSCO metazoa duplicated   | 13.4% (arthr.) | 6.4%        | ?                | ?                | ?          | ?                  | 7.2%                |
| BUSCO metazoa fragmented   | 6.7% (arthr.)  | 3.6%        | ?                | ?                | ?          | ?                  | 1.3%                |
| BUSCO metazoa missing      | 7.1% (arthr.)  | 2.2%        | ?                | ?                | ?          | ?                  | 1.6%                |


</details>
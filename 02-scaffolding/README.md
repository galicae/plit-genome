# Scaffolding

Code in this folder covers the steps from the initial draft genome (produced by Flye with the ONT
data) until the raw scaffolded assembly (pre-juicebox).

Here we repurposed a pipeline by Darrin Schultz, available via the [Genome Assembly
Pipelines](https://github.com/conchoecia/genome_assembly_pipelines) repository, in particular the
[yahs
rulefile](https://github.com/conchoecia/genome_assembly_pipelines/blob/master/snakefiles/GAP_yahs).
To fit it better to our computing environment, we broke it down into three steps:

- mapping the omni-C data onto the draft genome:
  [`scaffold-01-chromap.sh`](./scaffold-01-chromap.sh)
- actually scaffolding with [`yahs`](./scaffold-02-yahs.sh)...
- or [`salsa`](./scaffold-02-salsa.sh)
- producing the files that would be needed for visualisation (and editing) with juicebox:
  [`scaffold-03-visualize.sh`](./scaffold-03-visualize.sh)

We used the same evaluation scripts as during the assembly procedure to evaluate the quality of the
scaffolded assemblies. We decided in favor of the `yahs` assembly, as it had higher contiguity and
better BUSCO scores. Following that, the assembly and omniC map were manually edited in
[juicebox](https://github.com/aidenlab/Juicebox) to correct clear chromosome rearrangements and
smaller misassemblies. The corrected scaffold was exported in FASTA form and used from here on out.

## Genome assembly progress

<details>

<summary>Click to expand</summary>

Starting out from the `flye` assembly, progressing to scaffolding with yahs, manual curation with
juicebox (and removal of obvious contaminant scaffolds), ending with the GAP `sort_scaffolds`
pipeline.

| Assembly                   | flye        | flye        | flye + jb   | rd2 + decont  | BRAKER | ISO-seq + BRAKER |
|----------------------------|-------------|-------------|-------------|---------------|--------|------------------|
| scaffolder                 | -           | yahs        | yahs + me   | yahs + me     | -      | -                |
| # contigs (>= 0 bp)        | 10,856      | 12,371      | 10,767      | 10,257        | -      | -                |
| # contigs (>= 1000 bp)     | 13,520      | 9,707       | 8,199       | 7,689         | -      | -                |
| **# contigs (>= 5000 bp)** | **3,429**   | **2,280**   | **1,332**   | **790**       | -      | -                |
| # contigs (>= 10000 bp)    | 2,677       | 1,528       | 749         | 510           | -      | -                |
| # contigs (>= 25000 bp)    | 1,824       | 725         | 310         | 220           | -      | -                |
| # contigs (>= 50000 bp)    | 1,321       | 381         | 140         | 108           | -      | -                |
| Total length (>= 0 bp)     | 529,880,842 | 530,110,642 | 470,215,199 | 471,606,659   | -      | -                |
| Total length (>= 1000 bp)  | 528,047,687 | 528,277,487 | 468,450,049 | 469,841,509   | -      | -                |
| Total length (>= 5000 bp)  | 508,723,655 | 508,953,455 | 450,696,092 | 452,022,552   | -      | -                |
| Total length (>= 10000 bp) | 503,406,950 | 503,636,750 | 446,677,803 | 450,081,153   | -      | -                |
| Total length (>= 25000 bp) | 489,576,998 | 490,943,099 | 439,890,306 | 445,538,587   | -      | -                |
| Total length (>= 50000 bp) | 471,872,883 | 479,062,479 | 434,157,830 | 441,710,284   | -      | -                |
| **#contigs**               | **13,427**  | **12,278**  | **10,675**  | **10,165**    | -      | -                |
| Largest contig             | 4,458,759   | 18,159,430  | 13,781,389  | 14,198,558    | -      | -                |
| Total length               | 529,844,325 | 530,074,125 | 470,179,169 | 471,570,629   | -      | -                |
| GC (%)                     | 40.21       | 40.21       | 39.67       | 39.66         | -      | -                |
| N50                        | 522,825     | 7,393,989   | 7,715,281   | 7,968,359     | -      | -                |
| N90                        | 42,521      | 56,483      | 3,832,569   | 4,275,246     | -      | -                |
| auN                        | 743,185.5   | 7,692,823.7 | 7,600,557.7 | 7,994,033.9   | -      | -                |
| L50                        | 277         | 24          | 24          | 23            | -      | -                |
| L90                        | 1,430       | 344         | 56          | 54            | -      | -                |
| # N's per 100 kbp          | 0.00        | 43.35       | 28.56       | 42.98         | -      | -                |
|||||||
| Approx. runtime (CPUs)     | 21h (30)    | 7min(1)     | (a week?)   | -             | 17h    | -                |
|||||||
| BUSCO metazoa complete     | 94.2%       | 96.7%       | 96.7%       | -             | 96.0%  | 95.7% (90.3%)    |
| BUSCO metazoa single       | 87.8%       | 91.0%       | 91.0%       | -             | 79.2%  | 40.1% (87.1%)    |
| BUSCO metazoa duplicated   | 6.4%        | 5.7%        | 5.7%        | -             | 16.8%  | 55.6% (3.2%)     |
| BUSCO metazoa fragmented   | 3.6%        | 1.6%        | 1.6%        | -             | 0.5%   | 1.3% (1.5%)      |
| BUSCO metazoa missing      | 2.2%        | 1.7%        | 1.7%        | -             | 3.5%   | 3.0% (8.2%)      |

For Iso-seq ft. BRAKER the numbers in parentheses are the BUSCO results after keeping one "best"
isoform per locus (rules: longest complete CDS > complete CDS > longest CDS).

</details>
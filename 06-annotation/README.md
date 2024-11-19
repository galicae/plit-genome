# Annotation

Code in this folder covers the annotation of the genome with gene models, mostly for protein-coding
genes. The starting point is the scaffolded, decontaminated draft assembly.

## Annotating protein-coding genes on the _Pycnogonum_ genome

### BRAKER3 with developmental RNA-seq data

BRAKER3 is one of the most widely used tools for eukaryotic gene prediction, and one that
consistently performs well in benchmarks. However, installing the software is a non-trivial
endeavour in a HPC system without admin privileges. We provide here a summary of our experience in
the hopes that it is useful to other hopeful users.

- [Installing BRAKER3 in a shared system without admin access](install_braker.md)

We generated RNA-seq data for a time series spanning development from late embryogenesis until the
subadult stage (embryo 3-4, instars 1 to 6, juvenile 1, subadult), and our collaborators provided
data for even earlier timepoints (zygote, early cleavage, embryo 3-5). This data was mapped to the
draft genome (average: 72.8% uniquely mapping, 15% multimapping, so pretty good completeness) and
the resulting BAM files used as input to BRAKER3.

- [`prep-RNA-mkindex.sh`](prep-RNA-mkindex.sh) - before mapping the RNA we need to index the draft
  genome so that STAR can actually map to it.
- [`prep-RNA-map-all.sh`](prep-RNA-map-all.sh) - main script that will submit all mapping jobs.
- [`prep-RNA-map-single.sh`](prep-RNA-map-single.sh) - worker script that will map the RNA reads
  from a developmental timepoint to the draft genome.
- [`prep-RNA-bam.sh`](prep-RNA-bam.sh) - main script that will submit the SAM-to-BAM conversion jobs
  to the cluster.
- [`prep-RNA-sam2bam.sh`](prep-RNA-sam2bam.sh) - worker script that will convert a SAM file to a BAM
  file in the same location.
- [`prep-RNA-index_bam.sh`](prep-RNA-index_bam.sh) - index the resulting BAM files

BRAKER3 also expects a FASTA file with protein sequences expected to be found in the genome. For
this, we used the Arthropoda partition from [orthoDB](https://www.orthodb.org).

BRAKER3 was run from a container on the Vienna LiSC (Life Science Cluster; LiSC for short).

- [annotate/annot-braker.sh](./annot1-braker.sh)

This predicted 11,451 gene models. However, manual inspection of the RNA-seq mapping on the draft
genome revealed that BRAKER3 had been rather conservative in its predictions, and that many loci
that looked like they contained exon structures did not receive any annotation.

### using Iso-seq collapsed transcripts as gene models

We generated a long-read transcriptome using PacBio Iso-seq technology. After collapsing isoforms by
mapping onto the draft genome, we were left with 8,904 transcript families, which we interpreted as
genes. By comparing the Iso-seq "genes" with the BRAKER3 models we were able to identify multiple
cases where BRAKER3 occasionally merged gene models if they were too close to each other.

We decided to combine the Iso-seq and BRAKER3 annotation by giving precedence to Iso-seq. We
filtered the BRAKER3 gene models to remove any that overlapped (same strand, any overlap) with the
Iso-seq genes, and were left with 3,596 gene models, raising our total to 3,596 + 8,904 = 12,500.

- [Map](annot1-isoseq-map.sh) the Iso-seq collapsed transcripts to the draft genome
- [isoseq_confirm.ipynb](./annot1-isoseq_confirm.ipynb) - cross-reference the Iso-seq mapping
  locations with BRAKER predictions and produce a new GFF file that contains their union.

Unfortunately, the Iso-seq transcriptome we generated was part of a multiplexed run. This meant that
we "lost" almost 60% of our effective sequence depth on other organisms, making the _Pycnogonum_
Iso-seq less effective for gene annotation. Manual inspection confirmed what the numbers suggested:
there were still plenty of loci with RNA-seq peaks that looked like _bona fide_ genes but received
no annotation from either PacBio or BRAKER3.

We consider Iso-seq+BRAKER3 "round 1" of the genome annotation. In the final GFF file, gene models
that are derived from Iso-seq are have "PacBio" in the `source` column, and their IDs are in the
form `PB.XXXX`, where `X` are digits. BRAKER3 gene models have "AUGUSTUS" listed as their `source`
and their IDs have the form `gXXXXX`, with `X` again being digits.

### Re-using unannotated loci for a second round of annotation

There were a couple of indications that the genome annotation was not yet complete. First, BUSCO
completeness of the gene models was lower than the entire genome; second, the mapping rates of the
RNA-seq data was much lower for gene models (avg. uniquely mapping: 48.69%) compared to the entire
genome (avg. uniquely mapping: 72.8%); finally, manual inspection easily identified loci that looked
like genes but had no annotation.

We proceeded to a second round of annotation. We filtered the RNA-seq data to only keep the mapped
reads that did _not_ overlap with any of the gene models of the first BRAKER/Iso-seq round:

- [annot2-RNA-extracts.sh](./annot2-RNA-extracts.sh) - main script that will submit worker scripts
  for each transcriptome.
- [text](annot2-RNA-extract_uncovered.sh) - worker script that, for a bulk transcriptome will
  extract the reads that map on un-modelled regions.

...and supplied the same orthoDB arthropod partition as protein hints:

- [annot2-braker.sh](./annot2-braker.sh)

As the protein hints overlapped with round 1, it was to be expected that BRAKER3 would also produce
gene models that would overlap with round 1. To safely exclude these cases we used _exons_ to test
for gene overlap. Using entire gene models would preclude genes that overlap with other genes (but
on the other strand), or genes that lie in another gene's intron (such as the CHAT/VCHAT genes,
conserved in _Platynereis_).

This task was mostly achieved on the command line, using a combination of `bedtools intersect` to
identify overlaps between GFF files, `AGAT` to convert from GTF to GFF, and bash utility tools
`grep`, `cut`, `sort`, and `sed` to extract and lightly manipulate lines from the resulting files.

We consider this "round 2" of the genome annotation. In the final GFF file, gene models from round 2
have "AGAT" as `source` for gene/mRNA entries or "AUGUSTUS" for exons/CDS. Gene IDs are in the form
`r2_gXXXX`, with `r2` standing for "round 2" and the rest being the usual BRAKER3 gene ID. Round 2
produced an additional 2,223 gene models, bringing our total to 14,723.

<details>
<summary>Click here for details</summary>

First extract the round 2 exons that don't overlap:

```bash
$ grep exon braker/braker.gtf > braker_exons.gtf
$ grep exon ../annot_merge/merged.gff3 > draft_exons.gtf
$ bedtools intersect -v -b draft_exons.gtf -a braker_exons.gtf > unique_exons.gtf
```

Keep track of which genes these come from:

```bash
$ cat unique_exons.gtf | cut -f9 | cut -d" " -f 4 | sort -u > keep_candidates.txt
```

At the same time, there might be round 2 genes that are a bit bigger than round 1 genes, and thus
mostly overlap but have some unique exons. We'd like to avoid those:

```bash
$ bedtools intersect -wa -b draft_exons.gtf -a braker_exons.gtf > shared_exons.gtf
$ cat shared_exons.gtf | cut -f9 | cut -f4 -d" " | sort -u > overlap.txt
```

We can now filter the candidate genes by those that have some overlap:

```bash
$ grep -v -f overlap.txt keep_candidates.txt > keep_genes.txt
```

And finally, we can filter the GTF file:
    
```bash
$ grep -f keep_genes.txt braker/braker.gtf > braker2_unique.gtf
```

Now, before we can use this GTF file we need to make the gene names unique so that they don't
overlap with the round 1 gene names. We can do this by adding a suffix to the gene names:

```bash
$ sed -r 's/(g[[:digit:]])/r2_\1/g' braker2_unique.gtf > braker2_unique_renamed.gtf
```

Finally, we can convert to a GFF3 file and append to our existing annotation:

```bash
$ module load conda
$ conda activate agat-1.4.0
$ agat_convert_sp_gxf2gxf.pl -g braker2_unique_renamed.gtf -o ./braker2_unique_renamed.gff3
```

Let's copy that over to the annotation merge site:

```bash 
$ cp braker2_unique_renamed.gff3 ../annot_merge/braker2_unique.gff3
```

Now we can remove the lines that contain introns or start/stop codons:

```bash
$ cd ../annot_merge
$ grep -v -E -i "(intron)|(codon)" braker2_unique_renamed.gff3 > braker2_unique_renamed_nocodon_intron.gff3
```

</details>

### Using _de novo_ transcriptomes as additional evidence

Despite the improvements, manual inspection continued to suggest that there were loci with real
RNA-seq peaks and exon-like structures that did not receive gene models. We reasoned that loci that
represented real genes would be more likely to be present in multiple time points. Since BRAKER3 had
already seen these loci and didn't identify them as genes, we hypothesized that the signal-to-noise
ratio might have played a role. Instead of using raw reads we therefore turned to _de novo_
assembled transcripts, and tried to find loci where transcripts from multiple timepoints mapped onto
the draft genome.

We used [Trinity](https://github.com/trinityrnaseq/trinityrnaseq) to perform _de novo_ assemblies
for the in-house RNA-seq datasets, as they had been sequenced at a much deeper level than the
transcriptomes provided by our collaborators, giving the tool better chances to assemble real
sequences (also refer to the [corresponding section](../05-transcriptomes/README.md)) We kept
complete ORFs, as annotated by [TransDecoder](https://github.com/TransDecoder/TransDecoder), and
mapped those against the draft genome.

- [`filter_assemblies.sh`](./annot3-RNA-01-filter_assemblies.sh) - main script that submits
  filtering jobs to the cluster.
- [`extract_complete_ORFs.sh`](annot3-RNA-01-extract_complete_ORFs.sh) - worker script that will
  extract coding regions that represent complete ORFs
- [`map_assemblies.sh`](./annot3-RNA-02-map_assemblies.sh) - main script that will submit
  mapping jobs.
- [map complete ORFs to genome](annot3-RNA-02-map_assembly_single.sh) - worker script
- [`pack_sams.sh`](./annot3-RNA-03-pack_sams.sh) - main script that will submit formatting jobs to
  the cluster.
- [convert to GFF3](annot3-RNA-03-pack_sam.sh) - worker script that will extract reads that mapped
  well and save them in GFF3 format.

We chose to use the instar 3 transcriptome, which had 99% BUSCO completeness (metazoa), as a
reference. We used `bedtools intersect` to find all draft genome loci where an instar 3 transcript
mapped and overlapped (at 90% of its length) with a mapped transcript from another time point (also
at 90% of its length), and excluded all loci that overlapped with gene models from rounds 1 and 2.
We then translated the cDNA match parts of each locus to exons. Whenever there was disagreement
between the different _de novo_ transcriptomes about exon boundaries, we picked the most common exon
boundary.

- [mining de novo assembled transcriptomes](annot3-RNA-04-denovo_mining.ipynb)

While this approach is less sensitive than BRAKER3 and is incapable of distinguishing between
isoforms, it is fairly robust in finding gene and exon boundaries, at least so far as the coding
regions are concerned.

We consider this "round 3" of the genome annotation. In the final GFF file, gene models from round 3
have "Trinity" as `source`. Gene IDs are in the form `at_DNXXXX`, with `at` standing for "assembled
transcriptomes", `DN` being a tribute to Trinity transcript naming, and `X` being digits. Round 3
produced an additional 774 gene models, bringing our total to 15,497.

### Consolidating results

Finally, we can form the GFF3 file and sort it:

```bash
$ cat isoseq.gff > merged.gff3
$ cat braker.gff >> merged.gff3
$ cat braker2_unique_renamed_nocodon_intron.gff3 >> merged.gff3
$ cat denovo_txomes/overlap_translated.gff3 >> merged.gff3
$ cat ../trnascan/trnascan.gff3 >> merged.gff3
$ module load genometools/
$ gt gff3 -tidy -retainids -o merged_sorted.gff3 -force merged.gff3
```

### Testing

First, convert the GFF to GTF for convenience:

```bash
$ gt gff3_to_gtf -o merged_sorted.gtf merged_sorted.gff3
```

Now we can use [AGAT](https://agat.readthedocs.io/en/latest/tools/agat_sp_extract_sequences.html) to
extract transcripts from the genome:

```bash
$ agat_sp_extract_sequences.pl -g merged_sorted.gff3 -f ../draft_softmasked.fasta -t exon --merge -o transcripts.fa
```

We can then use this file as input for TransDecoder...

```bash
$ TransDecoder.LongOrfs -t transcripts.fa
$ TransDecoder.Predict -t transcripts.fa
```

...and finally look at BUSCO completeness:

```bash
$ conda deactivate
$ conda activate busco-5.7.1
$ busco -i transcripts.fa.transdecoder.pep -l metazoa -m protein -o metazoa -r -c 4 --offline --download_path ../../busco/busco_downloads/
```

Which returns:

```
---------------------------------------------------
|Results from dataset metazoa_odb10                |
---------------------------------------------------
|C:96.5%[S:40.7%,D:55.8%],F:1.5%,M:2.0%,n:954      |
|920    Complete BUSCOs (C)                        |
|388    Complete and single-copy BUSCOs (S)        |
|532    Complete and duplicated BUSCOs (D)         |
|14    Fragmented BUSCOs (F)                       |
|20    Missing BUSCOs (M)                          |
|954    Total BUSCO groups searched                |
---------------------------------------------------
```

This is very, very close to what we had for the entire genome (except for the high prevalence of
duplicated BUSCOs, which can be explained by the fact that we included all isoforms). In particular,
it is worth noting that, for the entire genome, we had 1.6% fragmented and 1.7% missing BUSCOs.
Taken together, this suggests that we have a fairly complete set of gene models.

We can do the same with the arthropod BUSCO set:

```bash
$ busco -i transcripts.fa.transdecoder.pep -l arthropoda -m protein -o arthropoda -r -c 4 --offline --download_path ../../busco/busco_downloads/
```

Which returns:

```
---------------------------------------------------
|Results from dataset arthropoda_odb10             |
---------------------------------------------------
|C:95.8%[S:37.3%,D:58.5%],F:2.0%,M:2.2%,n:1013     |
|971    Complete BUSCOs (C)                        |
|378    Complete and single-copy BUSCOs (S)        |
|593    Complete and duplicated BUSCOs (D)         |
|20    Fragmented BUSCOs (F)                       |
|22    Missing BUSCOs (M)                          |
|1013    Total BUSCO groups searched               |
---------------------------------------------------
```

Very similar results; again suggesting that we have a fairly complete set of gene models.

## tRNAscan

We also used tRNAscan to predict tRNAs in the draft genome. 

- [run the tool](annot-trnascan.sh)
- [export in GFF3 format](tRNAscan_to_gff3.ipynb)
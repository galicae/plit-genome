# Repeats, annotation, and possible contamination

After the trials and tribulations of genome assembly, scaffolding, repeat masking, and basic
(protein-coding) gene annotation, we finally reached the point where the genome could be useful. At
the same time, this was another checkpoint where we could compare the genome to other known
metazoan/arthropod/chelicerate genome assemblies to get a sense of whether we had something
reasonable or whether we might need to go back to the drawing board.

We got three red flags, which on their own would not have prompted much further investigation, but
together were very concerning:

1. RepeatMasker/RepeatModeler suggested that 60% of the (rather small) genome was repetitive, and
   that 45% of that was "unclassified" repeats. While lineage-specific repeats are common, _that
   many_ of them certainly aren't.
2. In the process of investigating the repeats (read: BLASTing them against NCBI `nr` for funsies),
   we were surprised to find that some of them returned hits in sea anemones. In particular, two
   persistent results belonged to _Metridium senile_, a sea anemone that we actually feed the _P.
   litorale_ larvae in our culture. While the matches were partial and the e-values were barely
   significant, this was too much of a coincidence.
3. We used a set of bulk RNA-seq data from various developmental timepoints to annotate the genome
   with `BRAKER`. Despite the extremely good coverage of development, BRAKER only identified 11.4k
   protein-coding genes, a far cry from the number we'd usually expect from a metazoan genome.

We have three objectives:

1. Make a decision re: repeats. Are they real? Can we come up with an idea for how we have so many
   unclassified repeats?
2. Is the _Metridium_ contamination real?
3. Can we find more protein-coding genes?

### 0. data and setup

- `FLYE=/lisc/scratch/zoology/pycnogonum/genome/flye_full/assembly.fasta` - the original, unscaffolded _P. litorale_ genome assembly
- `DRAFT=/lisc/scratch/zoology/pycnogonum/genome/draft/draft_softmasked.fasta` - The scaffolded, manually edited _P. litorale_ genome assembly
- `METRIDIUM=/lisc/scratch/zoology/pycnogonum/raw/GCA_949775045.1_jaMetSeni4.1_genomic.fna` - the _M. senile_ genome assembly
- `NANOPORE=/lisc/scratch/zoology/pycnogonum/raw/20230601_0904_3C_PAK64436_4d39d6a6/basecalls/nanopore.fasta` - the ONT data that we used to assemble the _P. litorale_ genome
- `HIFI=/lisc/scratch/zoology/pycnogonum/raw/m64120_240312_152428.ccs.fasta` - PacBio HiFi data from a collaborator that weren't deep enough for an assembly
- `REPEATS=/lisc/scratch/zoology/pycnogonum/genome/draft/repeats/repeat_modeller/pycno-families.fa` - the predicted repeat families from RepeatModeler

### 1. Repeats

We need to figure out if the repeats are real. We will go back to the raw reads that we used for
assembly and ask if they already contain repeats. If they do, and if the percentage of reads that
contain repeats is high, we can be more confident that the results of RepeatMasker are not an 
artifact.

First, map the repeats on the reads:

```bash
$ OUTPUT=/lisc/scratch/zoology/pycnogonum/genome/draft/repeats
$ bwa mem -x ont2d $REPEATS $NANOPORE > $OUTPUT/ont.sam
$ bwa mem -x pacbio $REPEATS $HIFI > $OUTPUT/pb.sam
```

See the [ONT](check_repeats-ont.sh) and [PacBio](check_repeats-pb.sh) scripts for
details.

Let's first have a look at the ONT data:

```bash
$ samtools flagstat $OUTPUT/ont.sam
$
$ 97,952,355 + 0 in total (QC-passed reads + QC-failed reads)
$ 30,502,516 + 0 primary
$ 0 + 0 secondary
$ 67,449,839 + 0 supplementary
$ 0 + 0 duplicates
$ 0 + 0 primary duplicates
$ 85,877,260 + 0 mapped (87.67% : N/A)
$ 18,427,421 + 0 primary mapped (60.41% : N/A)
$ 0 + 0 paired in sequencing
$ 0 + 0 read1
$ 0 + 0 read2
$ 0 + 0 properly paired (A : N/A)
$ 0 + 0 with itself and mate mapped
$ 0 + 0 singletons (A : N/A)
$ 0 + 0 with mate mapped to a different chr
$ 0 + 0 with mate mapped to a different chr (mapQ>=5)
```

Let's break this down:

- ~98 million total alignments are produced, from...
- 30.5 million reads (primary).
- The total map rate is 60.4% (primary mapped: 18.4 million reads). Since our mapping reference are
  the _P. litorale_ repeat families, this means that 60.4% of the reads have at least one repeat
  element on them. However, there are also...
- 67.4m supplementary alignments, i.e. alternative alignments. If our reference was a real genome,
  this category would denote chimeric reads or split alignments. However, since our reference is the
  (rather short) repeats, this essentially means that every read has an average of 2-3 repeats
  mapping to it.

The 60.4% map rate is surprisingly similar to the proportion of the genome that was marked as
repeats by RepeatMasker/RepeatModeler (60%). This suggests that the repeats might be real.

Second, let's have a look at our validation:

```bash
$ samtools flagstat $OUTPUT/pb.sam
$ 
$ 11,081,282 + 0 in total (QC-passed reads + QC-failed reads)
$ 1,715,700 + 0 primary
$ 0 + 0 secondary
$ 9,365,582 + 0 supplementary
$ 0 + 0 duplicates
$ 0 + 0 primary duplicates
$ 10,739,929 + 0 mapped (96.92% : N/A)
$ 1,374,347 + 0 primary mapped (80.10% : N/A)
$ 0 + 0 paired in sequencing
$ 0 + 0 read1
$ 0 + 0 read2
$ 0 + 0 properly paired (A : N/A)
$ 0 + 0 with itself and mate mapped
$ 0 + 0 singletons (A : N/A)
$ 0 + 0 with mate mapped to a different chr
$ 0 + 0 with mate mapped to a different chr (mapQ>=5)
```

Let's break this down:

- 11 million total alignments are produced, from...
- 1.7 million reads (primary).
- The total map rate is 80.1% (primary mapped: 1.37 million reads), so 4/5 of the PacBio reads
  have at least one repeat element on them. However, there are also...
- 9.37m supplementary alignments, i.e. alternative alignments, suggesting an average of 8-9 repeats
  per read. The average length of the PacBio reads is three times higher than the ONT reads
  (5,892nt/1,848nt), so this makes sense.

#### Takeaways: 

The repeats seem to be real. There seem to be multiple repeats present on each read.

Ways to improve this analysis:

- repeat analysis with short reads
- filter mapq30 alignments, count #alignments per read
- analyse the CIGAR strings to see what portion of each read is matched by high quality maps of
  repeat content


### 2a. _Metridium_ contamination

Map the ONT reads onto the _Metridium_ genome using the [backmap
script](../nanopore/eval-backmap-ont.sh) We wrote for assembly qc:

```bash
$ OUTPUT=/lisc/scratch/zoology/pycnogonum/genome/metridium_cont
$ sbatch eval-backmap-ont.sh $METRIDIUM $OUTPUT
```

The first thing to ask here is how many reads mapped well to the _Metridium_ genome. This
information is included in the `.stats` file produced by `backmap`. Consider the SN section of that
file here for closer inspection, but the important takeaway is that ~290k/30.5m reads mapped to the
_Metridium_ genome (0.95%) with mapping quality >0. This is worrying and should be investigated
more.

<details>

<summary>Summary Numbers from `samtools stats`</summary>

```bash
SN      raw total sequences:    30502516        # excluding supplementary and secondary reads
SN      filtered sequences:     0
SN      sequences:      30502516
SN      is sorted:      1
SN      1st fragments:  30502516
SN      last fragments: 0
SN      reads mapped:   419599
SN      reads mapped and paired:        0       # paired-end technology bit set + both mates mapped
SN      reads unmapped: 30082917
SN      reads properly paired:  0       # proper-pair bit set
SN      reads paired:   0       # paired-end technology bit set
SN      reads duplicated:       0       # PCR or optical duplicate bit set
SN      reads MQ0:      129520  # mapped and MQ=0
SN      reads QC failed:        0
SN      non-primary alignments: 1413288
SN      supplementary alignments:       1742261
SN      total length:   56368688445     # ignores clipping
SN      total first fragment length:    56368688445     # ignores clipping
SN      total last fragment length:     0       # ignores clipping
SN      bases mapped:   3057365257      # ignores clipping
SN      bases mapped (cigar):   356727603       # more accurate
SN      bases trimmed:  0
SN      bases duplicated:       0
SN      mismatches:     79904074        # from NM fields
SN      error rate:     2.239918e-01    # mismatches / bases mapped (cigar)
SN      average length: 1848
SN      average first fragment length:  1848
SN      average last fragment length:   0
SN      maximum length: 1533915
SN      maximum first fragment length:  1533915
SN      maximum last fragment length:   0
SN      average quality:        34.7
SN      insert size average:    0.0
SN      insert size standard deviation: 0.0
SN      inward oriented pairs:  0
SN      outward oriented pairs: 0
SN      pairs with other orientation:   0
SN      pairs on different chromosomes: 0
SN      percentage of properly paired reads (%):        0.0
```

</details>

We can then extract only the high-quality (map quality >30) primary alignments (exclude non-primary
alignments with `-F 0x100`):

```bash
$ cd $OUTPUT
$ samtools view -q 30 -F 0x100 GCA_949775045.1_jaMetSeni4.1_genomic.fna.ont.sort.bam | cut -f1 > primary_mq30.txt
```

This leaves us with only 32,490 reads.

At the same time, since `flye` doesn't keep track of which reads were used for contig building, we
need to map the reads back to the assembly, which I'd already done for QC reasons anyway. However,
we should be focusing on high-quality alignments that are not secondary or supplementary (0x100 and
0x800 flags):

```bash
$ OUTPUT=/lisc/scratch/zoology/pycnogonum/genome/draft/backmap/ont
$ sbatch eval-backmap-ont.sh $DRAFT $OUTPUT
$ samtools view -F 0x900 -q 30 -S $OUTPUT/draft.fasta.ont.sort.bam > $OUTPUT/draft.fasta.ont.sort.sam
$ BACKMAPPED_ONT=/lisc/scratch/zoology/pycnogonum/genome/draft/backmap/ont/draft.fasta.ont.sort.sam
```

(feel free to use more threads to speed `samtools view` up.)

We can combine the two outputs to see where the high-confidence _Metridium_ reads are concentrated
on the _P. litorale_ assembly:

```bash
$ LC_ALL=C fgrep -f primary_mq30.txt $BACKMAPPED_ONT > metridium_scaffolds.txt
```

This leaves us with 10,170 putatively _Metridium_ reads which have mapped well to the _P. litorale_
draft. We can then sum up how many times each scaffold was hit by _Metridium_ reads:

```bash
$ cat metridium_scaffolds.txt | cut -f3 | sort | uniq -c | sort -k1,1nr > metridium_scaffolds.txt_summary
```

The summary file is available in the [repository](./metridium_scaffolds.sam_summary). However, the
most important message becomes clear if we just inspect the top hits:

```bash
$  2478 pseudochrom_16
$   623 pseudochrom_22
$   373 scaffold_1844
$   355 pseudochrom_38
$   272 pseudochrom_13
$   238 pseudochrom_7
$   233 pseudochrom_24
$   214 pseudochrom_8
$   213 pseudochrom_17
$   174 pseudochrom_23
```

This looks a bit concerning. We need to go back to the contigs that were used to build the scaffolds
and do the same. However, if the offending contigs are highly repetitive and the "metridial" reads
are also highly repetitive, this is less concerning, and can be explained by the similarity of
low-complexity regions or tandem repeats.

Mapping scaffolds to contigs is not straightforward because of the manual editing of the hiC map.
It might be faster to just look at the locations of the putative _Metridium_ reads on the current
assembly and try to make sense out of that.

We cross-referenced the predicted repeats of the _P. litorale_ genome with the mapping locations of
the putative _Metridium_ reads. Out of the 10,170 putative _Metridium_ reads, 6,039 (60%) are at
least 25% repetitive, and 4,593 are at least 50% repetitive (see relevant
[notebook](metridium.ipynb)). This leaves us with maybe 5,000 problematic reads out of a total of
30.5 million.

For context, if we do the same thing but with contigs, and then refer back to the original flye
assembly (before scaffolding):

```bash
$ OUTPUT=/lisc/scratch/zoology/pycnogonum/genome/flye_full/backmap_ont
$ sbatch eval-backmap-ont.sh $FLYE $OUTPUT
$ samtools view -N primary_mq30.txt -F 0x900 -q 30 metridium_locs.sam > metridium_contigs.sam
$ cat metridium_contigs.sam | cut -f3 | sort | uniq -c | sort -k1,1nr > metridium_contigs.sam_summary
```

This file is also [uploaded](./metridium_contigs.sam_summary). Let's have a look at the top hits:

```bash
$ head metridium_contigs.txt_summary
$
$ 2197 contig_8782
$  324 contig_21131
$  151 contig_28132
$  146 contig_6939
$  123 contig_19945
$   94 contig_11056
$   79 contig_5985
$   78 contig_19987
$   77 contig_4985
$   76 contig_4041
```

If we go back to the alignment graph from `flye` and have a look, the alignment path is very
illuminating:

```bash
contig_8782     209547  86      N       N       1       *       10576,-3609,-3607,8782,20233,-24417,-24416,-28783,13730,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605,3605
```

This contig's path starts out normal, but very quickly devolves into a self-repeat.

Overall, it looks like _Metridium_ contamination is not a real danger; rather, we should start
contemplating other possibilities to explain these weak sequence similarities, such as horizontal
gene transfer.


### 2b. Other contaminants

Widespread _Metridium_ contamination seems to be out of the question, but this doesn't mean that
other contaminants can't be present. To check for that, we implemented an approach very similar to
`Kraken2.0`. Briefly, we aligned UniRef90 onto the draft using `mmseqs2` and then then used the
`taxonomy` module to assign kingdom-level taxonomy information to each hit; we then excluded
contigs/scaffolds that did not overwhelmingly contain metazoan genes.

First we need to download UniRef90 and also build the `mmseqs2` database from the genome sequences.

- [mmseqs-download_uniref90.sh](mmseqs-download_uniref90.sh)
- [mmseqs-prepdb.sh](mmseqs-prepdb.sh)

These can be run in parallel.

Then we do the actual alignment/taxonomy assignment:

- [mmseqs-align.sh](mmseqs-align.sh)

We then used a custom notebook to parse the result and save taxonomy information per
pseudochromosome/scaffold:

- [contamination.ipynb](contamination.ipynb)

Finally, we used the outputs of this notebook to filter out the contamination from the assembly:

- [filter_draft.ipynb](filter_draft.ipynb)

#### 3. Gene prediction

(see [genome annotation](../06-annotation/README.md) code)
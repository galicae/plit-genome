# List of files on Zenodo

Data accompanying the manuscript have been uploaded on Zenodo (10.5281/zenodo.14185694). Here we
present a brief description of each file and put them in meaningful groups.

## referenced supplement

Supplementary material from the manuscript.

- suppl-fig1-alignment.pdf
- suppl-fig2-genomescope.png
- suppl-fig3-abdA_araneae.png
- suppl-fig4-genomic_context.png

- suppl-table1-data_overview.tsv
- suppl-table2-Plit_COI-alignment_distances.pdf
- suppl-table3-isoseq.tsv
- suppl-table4-genome_progress.tsv
- suppl-table5-abdA.tsv
- suppl-table6-r2_g3735-Alignment-HitTable.csv
- suppl-table7-chelicerate_genomes.tsv
- suppl-table8-arthropod_repeat_content.tsv
- suppl-table9-chelicerate_repeat_content.tsv
- suppl-table10-Pycnognonum_microRNAs.xlsx

- suppl-file1-araneae_abdA.fasta
- suppl-file2-arthropod_genomes.tsv

- unref-table-mapping_rates.tsv

## figures

- figs.zip: archive of raw and processed figures for the manuscript in full resolution

## analysis

### genomic context

The broader arthropod/chelicerate context for the _P. litorale_ genome assembly. Files used/generated by the [genomic_context](https://github.com/galicae/plit-genome/blob/main/07-analysis/genomic_context.ipynb) notebook.

- araneae.tsv: repeat makeup of published chelicerate assemblies
- arthropoda.tsv: genome assembly statistics for arthropod genomes. From NCBI Genomes.
- modern_taxids.txt: list of taxonomic IDs for species; made to be submitted to NCBI Taxonomy.
- tax_report.txt: the full taxonomic report for each query species. Contains tax IDs for the entire lineage.
- total_repeats.tsv: total repeat content of published chelicerate genomes.

### Hox genes

Files concerning the Hox gene cluster analysis.

- Plit_HoxGenes.fasta: putative Hox gene sequences for P. litorale
- putative_hox-Alignment-HitTable.csv: 
- araneae_abdA.fasta: arachnid abdA sequences from NCBI
- araneae_abdA.m8: alignment of arachnid abdA sequences against the draft genome
- plit.m8: MMseqs2 alignment results for the putative Hox sequences against the draft genome.
- r2_g3735-Alignment-HitTable.csv: NCBI BLAST results (nr) for gene r2_g3735

## processed (intermediate) data

### 00-kmer-jellyfish.zip

k-mer spectra analysis with GenomeScope and GenomeScope2.0

### 00-seq-qc.zip

quality control output for raw sequencing data (e.g. FastQC output)

### 01-assembly

- assembly_graph.gfa: Flye output
- assembly_graph.gv: Flye output
- assembly_info.txt: Flye output
- assembly.fasta: Flye output
- backmap.hifi.sort.bam.cov-hist.pdf: coverage histogram of the back-mapped PacBio data
- backmap.ont.sort.bam.cov-hist.pdf: coverage histogram of the back-mapped ONT data
- BUSCO.arthropoda_odb10.txt: BUSCO completeness report (arthropoda_odb10)
- BUSCO.metazoa_odb10.txt: BUSCO completeness report (metazoa_odb10)
- flye.log: Flye assembler log
- quast_report.pdf: assembly QC

### 02-scaffold

`yahs` output files:

- asm_hic.sorted.bam
- flye-yahs.fa
- yahs.out_scaffolds_final.agp
- yahs.out_scaffolds_final.fa.hic
- yahs.out_scaffolds_final.fa.assembly

Juicebox (manual curating) results:

- yahs.out_scaffolds_final.fa.review.assembly
- 02-flye-yahs-juicebox.fa

GAP `sort_scaffolds` pipeline outputs

- 03-flye-yahs-juicebox-merge.fasta
- plit_q_0_50000_0.5FracBest_unseen_scaffolds.txt
- plit_q_0_50000_0.5FracBest_insertion_stats.tsv
- plit_q_0_50000_0.5FracBest_appended_scaffolds.tsv
- plit_q_0_50000_0.5FracBest_inserted_scaffolds.tsv

### 03-contamination

Refer to the [contamination analysis](https://github.com/galicae/plit-genome/blob/main/04-contam/README.md) for details.

Decontaminating the draft genome from non-metazoan scaffolds:

- plit_q_0_50000_0.5FracBest_output_filtered.fasta: input draft genome
- contam_tax.m8: Alignment results of UniRef90 against draft genome (MMseqs2)
- scaffolds_taxonomic_distribution.tsv: summary of contam_tax.m8; number of genes from each taxonomic level per scaffold.
- scaffolds_taxonomic_distribution_collapsed_vir.tsv: scaffolds with predominantly viral hits
- scaffolds_taxonomic_distribution_suspect.tsv: scaffolds whose genes are <90% metazoan

Checking for widespread _Metridium_ contamination:

- primary_mq30.txt: list of high-quality mapping reads (presumptive "metridial")
- metridium_scaffolds.txt_summary: no. of presumptive _Metridium_ reads per draft scaffold
- metridium_scaffolds.txt: filtered SAM file with all high-quality "_Metridium_" hits on draft scaffolds
- metridium_contigs.sam_summary: no. of presumptive _Metridium_ reads per Flye contig

### 04-annotation

Repeat analysis with RepeatModeler/RepeatMasker:

- draft.fasta.tbl: output of RepeatModeler in tabular form
- pb.sam.flagstats: summary of mapping the repeat families to the PacBio data.
- pycno-families.fa: output of RepeatModeler - the sequences of the _P. litorale_ repeat families
- draft.fasta.out.gff: output of RepeatModeler - repeat locations on the draft genome

Protein coding gene annotation:

- annot-01-isoseq.gff: GFF file with the gene models proposed using Iso-seq isoforms
- annot-01-braker.gff: GFF file with the gene models proposed from round 1 of BRAKER3 using developmental transcriptomes
- annot-02-braker.gff3: GFF file with the gene models proposed from round 2 of BRAKER3, using developmental transcriptome reads that weren't used in round 1
- annot-03-denovo.gff3: GFF file with the gene models proposed from the de novo transcriptomes
- deep_denovo_assemblies.zip: the de-novo assembled transcriptomes from the deeply sequenced developmental time points. Also available on ENA.

tRNAscan output

- trnascan.bed
- trnascan.out
- trnascan.fasta
- trnascan.stats

MirMachine output

- Pli_september.PRE.gff: MirMachine output with permissive threshold
- Pli_september.PRE-1.gff: MirMachine output with strict threshold
- Pli_september.PRE.fasta: predicted miRNA sequences

## Results

- draft_softmasked.fasta: draft genome with repetitive regions softmasked
- draft.fasta: draft genome fasta
- hox.gff3: the position of the Hox genes in GFF3 form.
- merged_sorted.gff3: protein-coding gene models from all rounds of annotation
- transcripts.fa: TransDecoder-extracted putative transcripts
- transcripts.fa.transdecoder.pep: TransDecoder predicted peptides
- out.emapper.annotations: EggNOG-mapper functional annotation for the predicted peptides
- out.emapper.best.annotations: filtered EggNOG-mapper annotation; best hit per gene kept
- miRNA.fasta: FASTA sequences of predicted miRNAs
- miRNA.lenient.gff: GFF of miRNA positions (permissive MirMachine cutoff)
- miRNA.strict.gff: GFF of miRNA positions (strict MirMachine cutoff)
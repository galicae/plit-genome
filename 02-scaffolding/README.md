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
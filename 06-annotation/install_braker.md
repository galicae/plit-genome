# Installing BRAKER3 on LISC

#### Accurate as of 2023-12-21

## Motivation

BRAKER3 is one of the premier pipelines for eukaryotic gene prediction. Unfortunately, it is also
one of the most difficult to install and run, especially in a HPC environment and _especially_
without root access. This is because BRAKER3 is a pipeline that combines several different tools,
needs several obscure dependencies, and requires a lot of configuration.

Since I foresee a lot of gene prediction in my future, I decided to take the time to document my
progress installing and running the software so that future me (and maybe current/future you) can
benefit the next time this is needed.

## Installation

My main sources are
* the [BRAKER3 GitHub page](https://github.com/Gaius-Augustus/BRAKER)
* the [BRAKER3 DockerHub page](https://hub.docker.com/r/teambraker/braker3)
* the [LISC HOWTO run containers page](https://lisc.univie.ac.at/wiki/content/working_environment/applications/software_as_container#singularity_and_apptainer)

### Step 1: Get BRAKER image

We are going to be working exclusively with Singularity, since Docker is not really optimised for 
HPC environments. There is no dedicated Singularity image for BRAKER3, but there is a Docker image
that Singularity can use. Let's pull that.

First I will create an appropriate directory structure for all of this:

```
>niko@laptop$ ssh lisc
>niko@lisc:~$ mkdir containers
>niko@lisc:~$ cd containers
```

The LISC website suggests the `apptainer` env, which should contain the newest version of
apptainer/singularity. Unfortunately, this does not seem to be the case, so I will use the
`singularity` env instead.

```
>niko@lisc:~/containers$ module load conda
>niko@lisc:~/containers$ conda activate singularity
```

Pull the image:

```
>niko@lisc:~/containers$ singularity build braker3.sif docker://teambraker/braker3:latest
```

<details>
  <summary>output</summary>
  ```
    (lots of text but the end should look similar to this:)
    2023/12/21 11:16:46  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/url-loader/node_modules/.bin/webpack} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:46  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-embed/node_modules/.bin/semver} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:46  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-embed/node_modules/.bin/vl2pdf} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:46  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-embed/node_modules/.bin/vl2png} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:46  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-embed/node_modules/.bin/vl2svg} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:46  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-embed/node_modules/.bin/vl2vg} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/csv2json} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/csv2tsv} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/dsv2dsv} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/dsv2json} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/json2csv} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/json2dsv} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/json2tsv} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/topo2geo} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/topomerge} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/topoquantize} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/tsv2csv} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-loader/node_modules/.bin/tsv2json} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-projection/node_modules/.bin/geo2svg} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-projection/node_modules/.bin/geograticule} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-projection/node_modules/.bin/geoproject} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-projection/node_modules/.bin/geoquantize} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-projection/node_modules/.bin/geostitch} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-themes/node_modules/.bin/vl2pdf} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-themes/node_modules/.bin/vl2png} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-themes/node_modules/.bin/vl2svg} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/vega-themes/node_modules/.bin/vl2vg} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/verdaccio/node_modules/.bin/JSONStream} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/verdaccio/node_modules/.bin/envinfo} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/verdaccio/node_modules/.bin/handlebars} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/verdaccio/node_modules/.bin/js-yaml} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/verdaccio/node_modules/.bin/marked} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/verdaccio/node_modules/.bin/mime} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/verdaccio/node_modules/.bin/mkdirp} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/verdaccio/node_modules/.bin/pino} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/verdaccio/node_modules/.bin/semver} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/verdaccio/node_modules/request/node_modules/.bin/uuid} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/warning/node_modules/.bin/loose-envify} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/webpack/node_modules/.bin/acorn} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/webpack/node_modules/.bin/browserslist} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/webpack/node_modules/terser-webpack-plugin/node_modules/.bin/terser} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/webpack/node_modules/terser-webpack-plugin/node_modules/.bin/webpack} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/webpack-bundle-analyzer/node_modules/.bin/acorn} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/webpack-bundle-analyzer/node_modules/.bin/mkdirp} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/webpack-bundle-analyzer/node_modules/.bin/opener} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/webpack-cli/node_modules/.bin/import-local-fixture} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/webpack-cli/node_modules/.bin/webpack} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/worker-loader/node_modules/.bin/webpack} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  warn rootless{opt/conda/share/jupyter/lab/staging/node_modules/yarn-deduplicate/node_modules/.bin/semver} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:16:47  info unpack layer: sha256:326593c72c7e03cb9871c467596fa18fc4b639718a0d9b6401fa9d10c651dfa2
    2023/12/21 11:16:54  info unpack layer: sha256:5c0048263e6eb546f9aca8c9de2e27e5f27ab5d0f65b11ec910ec6c425aa89f3
    2023/12/21 11:16:54  info unpack layer: sha256:179f754036e2ed1733341fa46bb1701649ad0cb671cbb1c27024e82c28a7c739
    2023/12/21 11:16:54  info unpack layer: sha256:e0f250156230802be0037b5aab71a25983bc15fd6939ddfe860f8ca769aae171
    2023/12/21 11:16:59  info unpack layer: sha256:722137bce0015e70b1c769e21a9cee9e2db0dad25023d40b7be5de4f6cd36043
    2023/12/21 11:16:59  info unpack layer: sha256:afd4f74c025028308b4f876a35509b1c8e66fa6cae794cd7cd756fcf8b9b1538
    2023/12/21 11:16:59  info unpack layer: sha256:1c44777d0dc4b79af795a0c0e36ff5c06de0ebf44d720d2362b736256cc6608e
    2023/12/21 11:16:59  info unpack layer: sha256:d1b34f82f8cdd5b8a1a4b02092856245514c8d9a8f4c6967ec3cec874d1b8829
    2023/12/21 11:17:00  info unpack layer: sha256:7da56a27f920dac47ec7df9eabd6bd4512b38968bfce850ee97ead3a85060fca
    2023/12/21 11:17:01  info unpack layer: sha256:911b3fb18e1c56358fae9bede839bfc53d2f7c23074805b8e50682f3d127f72e
    2023/12/21 11:17:02  info unpack layer: sha256:a8aaeed7aa6f26e7a85826f0c81a19764c544860568bed2565f89aa5a8eccd91
    2023/12/21 11:17:03  info unpack layer: sha256:4e55a6c82cf9816efd77f43fda4782801df62d729f37e64cf646c8c830c0202d
    2023/12/21 11:17:03  info unpack layer: sha256:4e8420ef9a6d15a7586ac7a35b91a85cba159711c14b6b3d6c12c60f802749c8
    2023/12/21 11:17:03  info unpack layer: sha256:d2fcf73697ea247644f6b122f58d8388fbfa87727ef8640485cced96a764a24e
    2023/12/21 11:17:03  info unpack layer: sha256:1079f418230549427d87bfba97ed9f97f16ad8383d036bf380d48674f6ffbd43
    2023/12/21 11:17:10  warn rootless{home/jovyan/.npm/_cacache/content-v2/sha512/74/32/89d2fc016984c6e2e7b9772ef32b1223783f6a7c6bf7c01cedf6b7198fcbdc968d0b79375939cda8169ccce2297c2dd698619b0b73fdbebe8638776523d1} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{home/jovyan/.npm/_cacache/content-v2/sha512/a0/42/8e68d25c890945d9f40cfa48df32f539fdb939bb3d2042a5fd60e02d47221c144de430001d63b6e0739ec4f32eb6a889f55b4b5595b4c88f7ddbe1bf78ce} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{home/jovyan/.npm/_cacache/content-v2/sha512/b7/f5/6b32b6a074deca06db865ddc0e078371033360075e39ce72e3a92ef0404452feed6e253ab67af36c76240b67aa82b76fdb60d594daa8cdfc5ccddd55815c} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{home/jovyan/.npm/_cacache/content-v2/sha512/c8/df/f4f9c4e46618c643c0951ecc7c3d15413af8b6a43f2bfb0d6236d0b02530812035365425fe75b9f42b732f9fd9208a4f97f6281f0b7761f368ef30799b22} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{home/jovyan/.npm/_cacache/content-v2/sha512/ff/46/32caf6c684788c1988aefa35dd857d3ebbc978564c6eaf7d91a8395d2b034695845f8dcf346925064e7f4c91f51e7a3637449a48cb0fcc7dc6cac7f66078} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{opt/conda/lib/libblas.so} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{opt/conda/lib/libcblas.so} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{opt/conda/lib/libcrypto.so} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{opt/conda/lib/libgfortran.so} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{opt/conda/lib/libgfortran.so.5} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{opt/conda/lib/liblapack.so} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{opt/conda/lib/libopenblas.so} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{opt/conda/lib/libopenblas.so.0} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:10  warn rootless{opt/conda/lib/libssl.so} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:17  warn rootless{opt/conda/ssl/cert.pem} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:17  warn rootless{opt/conda/ssl/misc/tsget} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers"
    2023/12/21 11:17:17  info unpack layer: sha256:72bfc406f45c190828445af56635120ccd43b4cc0ff96b1f4aed725fc31f3dab
    2023/12/21 11:17:20  info unpack layer: sha256:1cc47d4e243f5f6f7538d9d8c1849f08ae21c306410b0d8a8310a6d374a84a4d
    INFO:    Creating SIF file...
    INFO:    Build complete: braker3.sif
  ```
</details>

This should result in a file called "braker3.sif" in the current directory.

At this point, we should be able to run BRAKER3. Let's test it out:

```bash
>niko@lisc:~/containers$ singularity exec braker3.sif braker.pl
```

This prints BRAKER's help message, so it seems to work.

### Step 2: GeneMark-ETP license

There are additional instructions for getting BRAKER3 to run, where a valid license for GeneMark-ETP
is required. BRAKER suggests you run the following command:

```bash
>niko@lisc:~/containers$ singularity exec braker3.sif braker.pl print_braker3_setup.py
```

but for me this hangs _forever_, so I looked for the script itself. While it is not in the
repository any more, you can still find it in an old
[commit](https://github.com/Gaius-Augustus/BRAKER/commit/dfd688adcd71e96fb02cc784e2b05b307874377d).
I extrapolated from the script that this is what has to happen:

Go to the [GeneMark website](http://exon.gatech.edu/GeneMark/license_download.cgi), and pretend you
want to download `GeneMark-ES/ET/EP ver 4.71_lic`. This will take you to a page where you can choose
to download the software (ignore) and the key. Copy the link for the 64bit key.

Then, on LISC, do the following:

```bash
>niko@lisc:~/containers$ cd ~
>niko@lisc:~$ wget <link> # this is the link for the 64 bit key
>niko@lisc:~$ gunzip gm_key_64.gz
>niko@lisc:~$ mv gm_key_64 ~/.gm_key
```

This should be enough to get BRAKER3 with GeneMark-ETP to run.

### Step 3: Test run & Augustus config

Let's make a test directory:

```bash
>niko@lisc:~/containers$ mkdir test
>niko@lisc:~/containers$ cd test
```

A critical part of the BRAKER3 pipeline is Augustus, another notoriously finicky piece of software.
If we don't say anything, Augustus will try to overwrite its default config files, somewhere in the
depths of the container, where it doesn't have write access. We need to provide a valid config
collection to Augustus in a writable location. It seems like the most prudent way to do this is to
clone the Augustus repository somewhere safe and then copy the config folder to the test directory:

```bash
>niko@lisc:~/containers/test$ cd ~/repos
>niko@lisc:~/repos$ git clone git://github.com/Gaius-Augustus/Augustus.git
>niko@lisc:~/repos$ cd -
>niko@lisc:~/containers/test$ cp -r ~/repos/Augustus/config .
```

In the future, in the scripts we will write for slurm, we will have to copy the config folder to the
corresponding results directory on `/scratch/` or directly in the `$TMPDIR`.

Now we can run BRAKER3. I am modifying the final call from the [test3
script](https://github.com/Gaius-Augustus/BRAKER/blob/master/example/singularity-tests/test3.sh),
and benefitting from [najoshi](https://github.com/najoshi)'s [helpful GitHub
comment](https://github.com/Gaius-Augustus/BRAKER/issues/609#issuecomment-1571506735):

```bash
>niko@lisc:~/containers/test$ singularity exec -B ${PWD} $HOME/containers/braker3.sif braker.pl \
--AUGUSTUS_CONFIG_PATH=${PWD}/config \
--genome=/opt/BRAKER/example/genome.fa \
--prot_seq=/opt/BRAKER/example/proteins.fa \
--bam=/opt/BRAKER/example/RNAseq.bam \
--softmasking \
--threads 8 \
--gm_max_intergenic 10000 \
--skipOptimize
```

This took less than 10 minutes for me, and the output should look something like that:

```bash
INFO:    Converting SIF file to temporary sandbox...
# Thu Dec 21 14:42:44 2023:Both protein and RNA-Seq data in input detected. BRAKER will be executed in ETP mode (BRAKER3).
#*********
# Thu Dec 21 14:42:44 2023: Log information is stored in file /lisc/user/papadopoulos/test/braker/braker.log
#*********
# WARNING: Number of reliable training genes is low (114). Recommended are at least 600 genes
#*********
INFO:    Cleaning up image...
```

## Preparing the run

It is now time to compose a script for our real-life use cases. We aim to run BRAKER with RNA-seq
and protein data, so we need to produce BRAKER's desired input files first.

A good reference for this is the recent [TSEBRA
tutorial](https://github.com/KatharinaHoff/BRAKER-TSEBRA-Workshop/blob/main/GenomeAnnotation.ipynb)
offered by Katharina Hoff. This tutorial is pretty detailed, and if a user made it this far they can
probably follow it. I will just outline the steps I took.

#### Step 0: repeat masking

Repeats are a big problem for gene prediction; they may look coincidentally like protein-coding
genes, or may be actual protein-coding genes (such as transposases); both cases are usually not what
we are interested in. A genome should be repeat-masked prior to gene prediction. Paraphrasing from
the tutorial:

```bash
T=72 # you need a large number of threads and fast i/o storage
GENOME=/path/to/your/genome.fa # the fasta file of your genome
DB=some_db_name_that_fits_to_species

BuildDatabase -name ${DB} ${GENOME}
RepeatModeler -database ${DB} -pa ${T} -LTRStruct
RepeatMasker -pa 72 -lib ${DB}-families.fa -xsmall ${GENOME}
```

The `-xsmall` flag is important, as it means we are _soft-masking_ the genome, i.e. replacing the
repeats with lower-case letters instead of Ns.

#### Step 1: RNA-seq alignment

Spliced alignments of bulk RNA-seq data are invaluable for finding protein-coding genes, as they
can pinpoint the location of exons, introns, and UTRs. I am using STAR for this, but any other
aligner should work as well. The tutorial uses HISAT2.

First create an index for your genome:

```bash
STAR --runThreadN 30 \ # choose an appropriate number of threads
--runMode genomeGenerate \
--genomeDir "$ASSEMBLY" \ # the path to the directory where you want the index to be
--genomeFastaFiles "$FASTA" \ # the input genome FASTA file
--genomeSAindexNbases 13 # 12 or 13 will make a little difference, we can use either
```

Then align your reads:

```bash
STAR --runThreadN 30 \ # choose an appropriate number of threads
--outSAMstrandField intronMotif \ # very important for BRAKER
--genomeDir "$ASSEMBLY" \ # the path to the directory where the index is
--readFilesIn "$R1" "$R2" \ # Read 1 and Read 2 of your paired-end RNA-seq data
--readFilesCommand gunzip -c # if your reads are gzipped
```

This will generate a file called `Aligned.out.sam` in the current directory. We need to convert that
to BAM format and sort it:

```bash
samtools view -bSh Aligned.out.sam > Aligned.out.bam
```

#### Step 2: protein alignment

For that we need a protein database. I am using the [OrthoDB
database](https://bioinf.uni-greifswald.de/bioinf/partitioned_odb11/); in my case, it's Arthropods,
but use whatever fits.

## Running BRAKER3 on LISC

I used the following script, with a genome of ~530Mb and 8 RNA-seq datasets. It took about 20h to
run. RAM should not be the bottleneck for BRAKER3, as most of the steps are not so intensive (I also
am using pre-mapped RNA-seq data, so that alleviates the situation somewhat). There are some
guesstimates of performance on the AUGUSTUS repository that could help you decide how much
RAM/runtime to ask for. I was laughably wrong in my estimates.

```bash
#!/usr/bin/env bash
#
#SBATCH --job-name=pycno_braker
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32 # 60% CPU efficiency for me, no idea about peak consumption
#SBATCH --mem=100G # ended up needing 30G
#SBATCH --time=10-0 # ended up needing 20h
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@univie.ac.at
#SBATCH --output=/path/to/logfile-%j.out
#SBATCH --error=/path/to/logfile-%j.err

# 
module load conda
conda activate singularity

# container location
BRAKER=~/containers/braker3.sif # or wherever you put it; I use absolute paths to be safe
# path to the output directory, where all the magic should happen
OUTPUT=/path/to/output/directory
mkdir "$OUTPUT" -p || exit
cd "$OUTPUT" || exit

# copy AUGUSTUS config files for BRAKER
cp -r ~/repos/Augustus/config . # again, amend directories as needed

# define input files
# the genome assembly
GENOME=/path/to/some/assembly.fasta # mine was about 530Mbase (and a file size of 514Mbyte)
# the BAMs of the RNA-seq datasets to use as references for AUGUSTUS
BASE=/some/base/directory/that/contains/all/of/them/
DEV_TIMEPOINT1="$BASE/DEV_TIMEPOINT1/Aligned.out.bam"
DEV_TIMEPOINT2="$BASE/DEV_TIMEPOINT2/Aligned.out.bam"
DEV_TIMEPOINT3="$BASE/DEV_TIMEPOINT3/Aligned.out.bam"
# the corresponding OrthoDB protein sequences
ORTHODB=/path/to/fasta/file.fa

# now call the container. Important to mount the current directory, /scratch/, and the $TMPDIR,
# in case it is needed.
singularity exec -B "$PWD,/lisc/scratch/partition/of/your/institute/where/all/your/files/live/,$TMPDIR" "$BRAKER" braker.pl \
--AUGUSTUS_CONFIG_PATH="${PWD}"/config \
--genome=$GENOME \
--prot_seq=$ORTHODB \
--bam="$DEV_TIMEPOINT1","$DEV_TIMEPOINT2","$DEV_TIMEPOINT3" \
--softmasking \
--threads 32
```
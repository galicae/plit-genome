#!/usr/bin/env python

study = "PRJEB80537"

samples = ["ERS21095029", "ERS21095030", "ERS21095031", "ERS21095032", "ERS21095033", "ERS21095034", "ERS21095035", "ERS21095036", "ERS21095037"]
assembly_names = ["RNA_EMBRYO3", "RNA_INSTAR1", "RNA_INSTAR2", "RNA_INSTAR3", "RNA_INSTAR4", "RNA_INSTAR5", "RNA_INSTAR6", "RNA_JUV1", "RNA_SUBADULT"]
base = "/lisc/scratch/zoology/pycnogonum/transcriptome/development"
file_locs = ["embryonic_stage3-4", "instar_II", "instar_III", "instar_I-protonymphon", "instar_IV", "instar_V", "instar_VI", "juvenile_I", "subadult"]
out_dir = "/lisc/scratch/zoology/pycnogonum/genome/submission/transcriptomes"

for sample, name, loc in zip(samples, assembly_names, file_locs):
    f = f"{out_dir}/{loc}.manifest"
    with open(f, 'w') as manifest:
        manifest.write(f"STUDY   PRJEB80537\n")
        manifest.write(f"SAMPLE  {sample}\n")
        manifest.write(f"ASSEMBLYNAME    {name}\n")
        manifest.write(f"ASSEMBLY_TYPE isolate\n")
        manifest.write(f"PROGRAM Trinity\n")
        manifest.write(f"PLATFORM    ILLUMINA\n")
        manifest.write(f"FASTA   {base}/{loc}/Trinity.fasta.gz\n")

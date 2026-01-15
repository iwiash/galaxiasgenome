## Re-running clean copy of all GBS analyses past SNPcalling
```
mkdir ~/nobackup/source_files/GBS/source_files/all_analyses_rerun
cd ~/nobackup/source_files/GBS/source_files/all_analyses_rerun

## set up git
git init
```

** add filetree here **

## SNP calling
```
module load cutadapt/4.4-gimkl-2022a-Python-3.11.3
module load BWA/0.7.18-GCC-12.3.0
module load FastQC/0.12.1
module load VCFtools/0.1.15-GCC-9.2.0-Perl-5.30.1
module load Stacks/2.67-GCC-12.3.0
module load snakemake/7.32.3-gimkl-2022a-Python-3.11.3
module load SAMtools/1.16.1-GCC-11.3.0
```

### Config file
```
mode: "refmap" # "denovo" or "refmap"

raw_fastq: # single-end currently not supported
  reads: "../../00_good_data/SQ1146_CE3JBANXX_s_2_fastq.txt.gz"

cutadapt:
  adapter: "CCGAGATCGGAAGAGC" # Sequence of the adapter
  length: "50" # Mininimum length for refmap, common length for denovo
  minimum_phred: "25"  # Changed '=' to ':'

genome: # only needed for refmap mode
  ref: "../../polished_genome_22kb_filtered.fa"

vcf_filtering:
  parameters: "--max-missing 0.8 --maf 0.001" # vcftools arguments, passed at once
```
### Snakemake
```
  ## make graph of rules
snakemake --dag filtered.recode.vcf | dot -Tsvg > dag.svg

  ## run snakemake pipeline to bwa step
snakemake --cores all filtered.recode.vcf

  ## once hits bwa errors out so ru by hand:
bwa index -p polished_genome_22kb_filtered.fa polished_genome_22kb_filtered.fa
  ## then run snake again
snakemake --cores all filtered.recode.vcf

```

### Snakemake troubleshooting

bwa mem step is not working.

Initial run: 
```
[Thu Jan 15 13:59:36 2026]
rule bwa_map:
    input: polished_genome_22kb_filtered.fa, samples/KOARO_MarK07.fq.gz
    output: mapped_reads/KOARO_MarK07.bam
    jobid: 37
    reason: Missing output files: mapped_reads/KOARO_MarK07.bam; Input files updated by another job: samples/KOARO_MarK07.fq.gz
    wildcards: sample=KOARO_MarK07
    resources: tmpdir=/tmp

[main_samview] fail to read the header from "-".
[Thu Jan 15 14:03:07 2026]
Error in rule bwa_map:
    jobid: 347
    input: polished_genome_22kb_filtered.fa, samples/KOARO_Lag_K07.fq.gz
    output: mapped_reads/KOARO_Lag_K07.bam
    shell:
        bwa mem polished_genome_22kb_filtered.fa samples/KOARO_Lag_K07.fq.gz | samtools view -Sb - > mapped_reads/KOARO_Lag_K07.bam
        (one of the commands exited with non-zero exit code; note that snakemake uses bash strict mode!)

Removing output files of failed job bwa_map since they might be corrupted:
mapped_reads/KOARO_Lag_K07.bam

## it's also doing this sometimes:
[main_samview] fail to read the header from "-".
[main_samview] fail to read the header from "-".
[main_samview] fail to read the header from "-".
[Thu Jan 15 14:20:02 2026]
[Thu Jan 15 14:20:02 2026]
[Thu Jan 15 14:20:02 2026]
```

successive run:
```
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[main_samview] fail to read the header from "-".
[M::process] read 137644 sequences (10000053 bp)...
[M::process] read 142216 sequences (10000104 bp)...
[M::process] read 135176 sequences (10000129 bp)...
[M::process] read 139906 sequences (10000110 bp)...
[M::process] read 145006 sequences (10000051 bp)...
[M::process] read 135396 sequences (10000002 bp)...
[M::process] read 141736 sequences (10000034 bp)...
[M::process] read 143418 sequences (10000090 bp)...
[M::process] read 138082 sequences (10000073 bp)...
[M::process] read 133760 sequences (10000079 bp)...
[Thu Jan 15 16:38:40 2026]
Error in rule bwa_map:
    jobid: 15
    input: polished_genome_22kb_filtered.fa, samples/KOARO_GB323.fq.gz
    output: mapped_reads/KOARO_GB323.bam
    shell:
        bwa mem polished_genome_22kb_filtered.fa samples/KOARO_GB323.fq.gz | samtools view -Sb - > mapped_reads/KOARO_GB323.bam
        (one of the commands exited with non-zero exit code; note that snakemake uses bash strict mode!)

Removing output files of failed job bwa_map since they might be corrupted:
mapped_reads/KOARO_GB323.bam
```

If I run cmd outside of snake get this:
```
bwa mem polished_genome_22kb_filtered.fa samples/KOARO_Lag_K07.fq.gz | samtools view -Sb - > mapped_reads/KOARO_Lag_K07.bam

[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::process] read 143560 sequences (10000095 bp)...
[M::process] read 143552 sequences (10000052 bp)...
[M::mem_process_seqs] Processed 143560 reads in 14.435 CPU sec, 14.312 real sec
[M::process] read 143506 sequences (10000067 bp)...
[M::mem_process_seqs] Processed 143552 reads in 15.183 CPU sec, 14.999 real sec
[M::process] read 143912 sequences (10000017 bp)...
[M::mem_process_seqs] Processed 143506 reads in 15.055 CPU sec, 14.890 real sec
[M::process] read 143800 sequences (10000029 bp)...
[M::mem_process_seqs] Processed 143912 reads in 14.567 CPU sec, 14.394 real sec
[M::process] read 143910 sequences (10000163 bp)...
[M::mem_process_seqs] Processed 143800 reads in 14.526 CPU sec, 14.358 real sec
[M::process] read 143850 sequences (10000048 bp)...
[M::mem_process_seqs] Processed 143910 reads in 14.415 CPU sec, 14.232 real sec
[M::process] read 143680 sequences (10000064 bp)...
[M::mem_process_seqs] Processed 143850 reads in 14.062 CPU sec, 13.895 real sec
[M::process] read 143834 sequences (10000122 bp)...
[M::mem_process_seqs] Processed 143680 reads in 14.218 CPU sec, 14.022 real sec
[M::process] read 143616 sequences (10000078 bp)...
[M::mem_process_seqs] Processed 143834 reads in 14.564 CPU sec, 14.408 real sec
[M::process] read 143836 sequences (10000058 bp)...
[M::mem_process_seqs] Processed 143616 reads in 14.130 CPU sec, 13.951 real sec
[M::process] read 143566 sequences (10000107 bp)...
[M::mem_process_seqs] Processed 143836 reads in 14.561 CPU sec, 14.392 real sec
[M::process] read 38743 sequences (2692484 bp)...
[M::mem_process_seqs] Processed 143566 reads in 15.109 CPU sec, 15.016 real sec
[M::mem_process_seqs] Processed 38743 reads in 4.007 CPU sec, 3.930 real sec
[main] Version: 0.7.18-r1243-dirty
[main] CMD: bwa mem polished_genome_22kb_filtered.fa samples/KOARO_Lag_K07.fq.gz
[main] Real time: 178.627 sec; CPU: 179.401 sec
```


## VCF filtering
```
nano filtered_indvs.txt
## general individuals to remove

nano island_indvs.txt
## Auckland/Chatham islands indvs to remove for some analyses
```

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
module load FastQC/0.12.1
module load SAMtools/1.21-GCC-12.3.0
module load VCFtools/0.1.15-GCC-9.2.0-Perl-5.30.1
module load Stacks ###
module load Snakemake ###

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
bwa index -p polished_genome_22kb_filtered ../../polished_genome_22kb_filtered.fa
  ## then run snake again
snakemake --cores all filtered.recode.vcf

```

## VCF filtering
```
nano filtered_indvs.txt
## general individuals to remove

nano island_indvs.txt
## Auckland/Chatham islands indvs to remove for some analyses
```

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

  ## run bwa index first bc broken
bwa index -p polished_genome_22kb_filtered.fa polished_genome_22kb_filtered.fa

  ## run snakemake pipeline
snakemake --cores all filtered.recode.vcf

```


## VCF filtering
```
nano filtered_indvs.txt
## general individuals to remove

nano island_indvs.txt
## Auckland/Chatham islands indvs to remove for some analyses
```

Shell script:
```
#!/usr/bin/env bash 
set -e

exec &>> vcf_filtering.log

## load module
module purge
module load VCFtools/0.1.15-GCC-9.2.0-Perl-5.30.1

## set variables
VCF="../00_data/filtered.recode.vcf"
MASTER="../00_data/master_working_vcf_all_pops_no_lowdata"
SUB="../00_data/sub_master_no_offshore_islands"

## filter lowdata/negctrls

echo "filtering low data and negative controls"
vcftools \
	--vcf $VCF \
	--exclude-positions snps_to_rm.txt \
	--remove filtered_indvs.txt \
	--max-missing 0.8 \
	--out $MASTER \
	--recode

echo "lowdata filtered to $MASTER.recode.vcf"

## filter island populations

echo "filtering island individuals"
vcftools \
        --vcf $MASTER.recode.vcf \
        --remove island_indvs.txt \
        --max-missing 0.8 \
        --out $SUB \
        --recode

echo "island filtered VCF at $SUB.recode.vcf"

echo "filtering complete :)"
```

## IQTREE

### Preparation
Creates phylip file and appends Tasmanian reference to the end:
```
#!/usr/bin/env bash 
set -e

exec &>> iqtree_preparation.log

##load modules
module purge
module load BEDTools/2.31.1-GCC-12.3.0

## needed input files
VCF="../00_data/master_working_vcf_all_pops_no_lowdata.recode.vcf"
GENOME="../00_data/polished_genome_22kb_filtered.fa"
##phylip prefix
PHYLIP="all_samples_iqtree_input"
## temporary files that get deleted at the end
POSITIONS="positions.bed"
SEQUENCE="reference_extracted_seq.fasta"
REFERENCE="nohead.fa"
STRING="reference_string.txt"



## cut reference alleles from VCF file
awk 'BEGIN {OFS="\t"} !/^#/ {print $1, $2-1, $2}' $VCF > $POSITIONS

## extract BED positions from masked genome fasta
bedtools getfasta -fi $GENOME -bed $POSITIONS -fo $SEQUENCE

## the resulting file has a header and each base on a different line
##remove headers - resulting file still has a base on each line
awk '/^>/ {if (seq) print seq; seq=""; next} {seq=seq $0} END {print seq}' $SEQUENCE > $REFERENCE

##stick all the lines together - creates a little loop in sed to loop back to 'a' until the last line of the file ($!)
##and tells it to put the next line up with the first and remove all newline characters then sticks Tasmanian_reference_GB in front 
sed ':a;N;$!ba;s/\n//g' $REFERENCE | sed "s/^/Tasmanian_reference_GB\t/g" > $STRING

echo "reference string created"

## convert VCF to phylip input file
python vcf2phylip/vcf2phylip.py --input $VCF --output-prefix $PHYLIP

echo "sticking string to phylip"

## stick string onto end of phylip
cat $STRING >> $PHYLIP.min4.phy

## remove temp files
rm $POSITIONS $SEQUENCE $STRING $REFERENCE

echo "reference sequence added to phylip!  dont forget to manually change the sample number :)"
```


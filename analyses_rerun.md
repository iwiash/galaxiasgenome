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

### Modelfinder pro 
```
#!/bin/bash -e
#SBATCH --job-name=mfp_iqtree_alldata 
#SBATCH --time=15:00:00      # Walltime (HH:MM:SS)
#SBATCH --mem=5G 
#SBATCH --account=uoo02831
#SBATCH --cpus-per-task=32
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

## load modules 
module purge
module load IQ-TREE/2.2.2.2-gimpi-2022a

## set input variables
PHYLIP="all_samples_iqtree_input.min4.phy"
## set output variables
PREFIX="mfp_all_samples"
OUTDIR="mfp_all_samples_output/"

## make output directory if doesn't exist
mkdir $OUTDIR

## run  iqtree with modelfinder
iqtree2 -nt 32 -s $PHYLIP -st DNA -m MFP -bb 1000 -nm 5000 -pre $OUTDIR$PREFIX

echo "modelfinder tree run complete"

```

## BayeScan outlier testing
### Metadata
```
	## Pull metadata from full metadata file (00_metadata)
cut -f 1,2 NO_ISLANDS_all_locations_no_lowdata_FULL_METADATA.txt > bayescan_metadata_no_islands.txt
```

### PGDSpider GUI
```
Input file: sub_master_no_offshore_islands.recode.vcf
Input metadata: bayescan_metadata_no_islands.txt
Output format: GESTE/Bayescan
Output file: pgdspider_outputs/no_offshore_islands_bayescan_input.txt
SPID: snpcalling_rerun_bayescan.spid

Press convert - comes up with a little screen where you can add a metadata file with pop IDs and pop assignments

```

### Bayescan slurm
```
#!/bin/bash -e
#SBATCH --job-name=bayescan # Job name (shows up in the queue)
#SBATCH --time=8:00:00      # Walltime (HH:MM:SS) 48h
#SBATCH --mem=16G            # Memory in MB
#SBATCH --account=uoo02831
#SBATCH --cpus-per-task=4
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

module purge
module load BayeScan/2.1-GCCcore-7.4.0

GESTE="no_offshore_islands_bayescan_input.txt"

bayescan_2.1 \
	-threads 4 \
	$GESTE

echo "bayescan finished"

```
#### Get positions of SNPs from VCF and then process in R
```
grep -v "^#" ../00_data/polished_genome_22kb_filtered.fa | cut -f 1,2,3 > positions_for_bayescan_results.txt

```

#### Also refilter VCF to make copy with only significant SNPs
```
cut -f 3 significant_only_bayescan_stats_no_islands.txt > no_islands_sig_positions.txt

vcftools --vcf ../00_data/maf_filtered_sub_no_offshore_vcf.recode.vcf --snps no_islands_sig_positions.txt --out maf_filtered_no_islands_bayescansig --recode
```

** Link R script **

### Calculate raw FST values 

#### Need a list of migratory and nonmigratory individuals:
```
## migratory all - all incl islands
cat ../../00_metadata/mainland_migratory.txt ../../02_vcf_filtering/island_indvs.txt | grep -v "^#" > migratory_all.txt

## migratory no islands
cp ../../00_metadata/mainland_migratory.txt migratory_no_islands.txt

## nonmigratory
grep -v -f migratory_all.txt ../../00_metadata/bayescan_metadata_no_islands.txt | cut -f 1 > nonmigratory_all.txt

```

#### Weir FST with VCFtools
```
vcftools --vcf master_working_vcf_all_pops_no_lowdata.recode.vcf --weir-fst-pop migratory_all.txt --weir-fst-pop nonmigratory_all.txt --out allmigratory_vs_nonmigratory

vcftools --vcf sub_master_no_offshore_islands.recode.vcf --weir-fst-pop migratory_no_islands.txt --weir-fst-pop nonmigratory_all.txt --out noislandsmigratory_vs_nonmigratory

## make a list of significant SNP unadjusted FSTs
grep -f significant_snps_bayescan_stats_no_islands.txt raw_fst_calculations/noislandsmigratory_vs_nonmigratory.weir.fst > original_run_significant_snps_raw_weir_fst.txt
```

## PCA analysis

Prepare all the files for:

* All samples eigenvectors
* No islands only eigenvectors
* No islands no lagoon saddle tarn eigenvectors
* Only mainland migratory (13mi, breccia, Stewart is) eigenvectors

Sort of a confusing script sorry:
```
#!/usr/bin/env bash 
set -e

exec &>> pca_prep.log

## load modules
module purge
module load PLINK/2.00a6.9
module load VCFtools/0.1.15-GCC-9.2.0-Perl-5.30.1

## set variables
## existing vcfs
VCF="../00_data/master_working_vcf_all_pops_no_lowdata.recode.vcf"
NOISLAND="../00_data/sub_master_no_offshore_islands.recode.vcf"

## subset vcfs (created here)
MIGVCF="../00_data/mainland_migratory_only"
LSTVCF="../00_data/sub_master_no_lagoon_no_islands"

## plink outputs
BED="../00_data/master_working_vcf_all_pops_no_lowdata"
NOISLANDBED="../00_data/sub_master_no_offshore_islands"
FREQ="master_vcf_allele_frequencies"

## PCA outputs
FULLOUT="all_samples_pca"
MIGOUT="mainland_migratory_only_pca"
LSTOUT="no_lagoon_no_islands_pca"
NOISLANDOUT="no_islands_pca"

## metadata
MIGR="../00_metadata/mainland_migratory.txt"
LST="../00_metadata/lagoon_saddle_indvs.txt"


## convert full VCF to BED
plink2 --vcf $VCF --make-bed --out $BED

## convert no islands to bed
plink2 --vcf $NOISLAND --make-bed --out $NOISLANDBED

## run allele freq calculations
plink2 --bfile $BED --freq --out $FREQ

## subset VCF to only migratory individuals
vcftools --vcf $VCF --keep $MIGR --max-missing 0.8 --out $MIGVCF --recode

## convert VCF to BED for migratory only
plink2 --vcf $MIGVCF.recode.vcf --make-bed --out $MIGOUT

## subset island free VCF to remove LST
vcftools --vcf $NOISLAND --remove $LST --max-missing 0.8 --out $LSTVCF --recode

## convert VCF to BED for LST
plink2 --vcf $LSTVCF.recode.vcf --make-bed --out $LSTOUT

echo "VCF converted to BED"

## run PC analysis all samples
plink2 --bfile $BED --pca --out $FULLOUT

## run PC analysis mainland migratory only
plink2 --bfile $MIGOUT --read-freq $FREQ.afreq --pca --out $MIGOUT

## run PC analysis island removed all other samples
plink2 --bfile $NOISLANDBED --pca --out $NOISLANDOUT

## run PC analysis islands + LST removed
plink2 --bfile $LSTOUT --pca --out $LSTOUT

echo "eigenvector/values produced - now go run your PCAs in R :)"
```

## WinPCA
#### Dependencies stuff
```
module load Python
pip install scikit-allel

## clone git
git clone https://github.com/MoritzBlumer/winpca.git

## make script writeable
chmod +x winpca/winpca

## Add winpca to bin
cd /home/iwias275/bin
ln -s /home/iwias275/nobackup/source_files/GBS/source_files/all_analyses_rerun/06_winpca/winpca/winpca
## removed old link just in casies
```

#### Find first and last position of scaffold of interest (17)
```
grep "^scaffold_17" master_working_vcf_all_pops_no_lowdata.recode.vcf | cut -f 1,2 | head -n 1
## scaffold_17     48102

grep "^scaffold_17" master_working_vcf_all_pops_no_lowdata.recode.vcf | cut -f 1,2 | tail -n 1
## scaffold_17     23340122

```
#### Run WinPCA plot for this scaffold
```
## calculate PCAs
winpca pca scaffold_17_outputs/scaffold_17_master_vcf master_working_vcf_all_pops_no_lowdata.recode.vcf scaffold_17:48102-23340122

## run chromplot
winpca chromplot scaffold_17_outputs/scaffold_17_master_vcf scaffold_17:48102-23340122 -m all_locations_no_lowdata_FULL_METADATA.txt -g MIGRATORY-STATUS -c Diadromous:2596BE,Non-Diadromous:be2528
```
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

genome plot all:
```
CHROMS='scaffold0001,scaffold0007,scaffold0021,scaffold0037,scaffold0080'

winpca genomeplot ./ $CHROMS -m all_locations_no_lowdata_FULL_METADATA.txt -g MIGRATORY-STATUS -c Diadromous:2596BE,Non-Diadromous:be2528
```

## LDBlockShow
#### Input files
```


```

#### Run LD
```
LDBlockShow/bin/LDBlockShow -InVCF sub_master_no_offshore_islands.recode.vcf \
	-OutPut outputs/scaffold_17_no_islands_linkage \
	-Region scaffold_17:48102:23340122 \
	-NoShowLDist 90000000

## run some aesthetic changes
LDBlockShow/bin/ShowLDSVG -InPreFix outputs/scaffold_17_no_islands_linkage \
	-OutPut outputs/scaffold_17_no_islands_linkage \
	-SpeSNPName original_run_scaffold_17_significant_snps.txt \
	-NoShowLDist 90000000 \
	-PointSizeRatio 0.5 \
	-SNPNameSizeRatio 0

```

** add img here **

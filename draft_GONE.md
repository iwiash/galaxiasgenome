Clone repository
```
git clone https://github.com/esrud/GONE.git
```

Use subset VCFs of noislands_renamed_full_sorted.vcf that separate each pops

Make chrom map file
```
bcftools view -H ../subset_vcfs/12mile_only_renamed.vcf | cut -f 1 | uniq | awk '{print $0"\t"$0}' > 12mile.chrom-map.txt
```
Make .map/.ped files
```
vcftools --vcf ../subset_vcfs/12mile_only_renamed.vcf --chrom-map 12mile.chrom-map.txt --out 12mile --plink
```

Ok this is when it gets a bit stupid - gotta be a better way
```
Manually rm SCAFFOLD_000 in front of names with ctrl f replace in .map file
 - could definitely replace this with a sed cmd but for debugging of the actual gone script i want to move forward

cp .map and .ped files into gone directory - in future might have to do a hideous ln -s file struct for each lake
```

```
#!/bin/bash -e
#SBATCH --job-name=gone_testrun
#SBATCH --time=15:00:00
#SBATCH --mem=32G
#SBATCH --account=uoo02831
#SBATCH --cpus-per-task=12

bash script_GONE.sh subset_vcfs/12mile_only_renamed

echo "gone run complete'
```

#######################################################################################################################################################

## Stairway
```
module load Miniconda3

conda create -n easySFS
conda activate easySFS
conda install -c conda-forge numpy pandas scipy -y
git clone https://github.com/isaacovercast/easySFS.git
```
then copy appropriate files in and:
```
./easySFS.py -i meta/rotoroa_sample_id_filtered.recode.vcf.gz -p metadata_pops_samplenames_only_full.txt -a --preview
## use numbers from this (just choose # of samples i actually have) for next step? - the # go up to double bc diploid but stairway wants the folded sfs to be 2n
## so if i use a # higher than the actual number it freaks out
## -a flag for use all coz otherwise it reduces to 1 per chrom and get rly low #s

##test run with one of the pops
## with # of samples (11)
./easySFS.py -i all_samples.recode.vcf -p meta/rotoroa.txt --proj 11 -a -o rotoroa_sfs_sampnum

## with theoretical max
./easySFS.py -i all_samples.recode.vcf -p meta/rotoroa.txt --proj 20 -a -o rotoroa_sfs_max

## output sfs:
## 11
12 folded "Lake-Rotoroa"
69679.72712484456 7671.808557782077 3823.27084443765 2546.178781229091 2043.245212862471 1888.769478844169 0 0 0 0 0 0
1 0 0 0 0 0 1 1 1 1 1 1

## 20
21 folded "Lake-Rotoroa"
63595.58008658008 7375.294372294346 3719.658008658001 2457.2251082251 1726.17316017315 1385.393939393936 1146.129870129868 1049.61038961039 945.3116883116871 999.1948051948013 493.4285714285704 0 0 0 0 0 0 0 0 0 0
1 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1
```
remove first value (monomorphic sites) before going into stairway

sidenote: cut up the big vcf into pop specific ones (maybe processes faster? lowkey i cant tell)
```
for meta in *.txt; do
    cut -f1 "$meta" > "${meta%.txt}_sample_id.txt"
done

for pop_file in *_sample_id.txt; do
    pop_name="${pop_file%.txt}"
    vcftools --vcf ../all_samples.recode.vcf --keep $pop_file --recode --out "${pop_name}_filtered"
done

gzip *filtered.recode.vcf

```

move to stairway directory and:
Blueprint file
```
#example blueprint file
#input setting
popid: rotoroa # id of the population (no white space)
nseq: 22 # number of sequences
L: 	87653 # total number of observed nucleic sites, including polymorphic and monomorphic
whether_folded: true # whethr the SFS is folded (true or false)
SFS:  7671.808557782077 3823.27084443765 2546.178781229091 2043.245212862471 1888.769478844169 0 0 0 0 0 0
#smallest_size_of_SFS_bin_used_for_estimation: 1 # default is 1; to ignore singletons, uncomment this line and change this number to 2
#largest_size_of_SFS_bin_used_for_estimation: 6 # default is nseq/2 for folded SFS
pct_training: 0.67 # percentage of sites for training
nrand: 2 5 7 9 # number of random break points for each try (separated by white space)
project_dir: rotoroa_numsamp # project directory
stairway_plot_dir: stairway_plot_es # directory to the stairway plot files
ninput: 200 # number of input files to be created for each estimation
#random_seed: 6
#output setting
mu: 4.2e-9 # assumed mutation rate per site per generation (taken from stickleback paper for de novo rates)
year_per_generation: 1 # assumed generation time (in years)
#plot setting
plot_title: chalice_test_run # title of the plot
xrange: 0,0 # Time (1k year) range; format: xmin,xmax; "0,0" for default
yrange: 0,0 # Ne (1k individual) range; format: xmin,xmax; "0,0" for default
xspacing: 2 # X axis spacing
yspacing: 2 # Y axis spacing
fontsize: 12 # Font size

```

run
```
java -cp stairway_plot_es Stairbuilder rotoroa.blueprint
## creates rotoroa.blueprint.sh

bash rotoroa.blueprint.sh
```
OTHER POPS
```
./easySFS.py -i all_samples.recode.vcf -p meta/diad_comb.txt --proj 52 -a -o mainland_diadromous_sfs_max

  462  ./easySFS.py -i all_samples.recode.vcf -p meta/rotoroa.txt --proj 20 -a -o rotoroa_sfs_max
  463  ./easySFS.py -i all_samples.recode.vcf -p meta/marian.txt --proj 26 -a -o marian_sfs_max
  464  ./easySFS.py -i all_samples.recode.vcf -p meta/chalice.txt --proj 22 -a -o chalice_sfs_max
  465  ./easySFS.py -i all_samples.recode.vcf -p meta/sylvester.txt --proj 20 -a -o sylvester_sfs_max
  466  ./easySFS.py -i all_samples.recode.vcf -p meta/twelvemile.txt --proj 24 -a -o twelvemile_sfs_max
  467  ./easySFS.py -i all_samples.recode.vcf -p meta/lagoonsaddle.txt --proj 26 -a -o lagoon_sfs_max
  468  ./easySFS.py -i all_samples.recode.vcf -p meta/green.txt --proj 26 -a -o green_sfs_max
  469  ./easySFS.py -i all_samples.recode.vcf -p meta/paringa.txt --proj 26 -a -o paringa_sfs_max
  470  ./easySFS.py -i all_samples.recode.vcf -p meta/auckland.txt --proj 16 -a -o auckland_sfs_max
  471  ./easySFS.py -i all_samples.recode.vcf -p meta/chatham.txt --proj 18 -a -o chatham_sfs_max
```

#######################################################################################################################################################
## TOGA
Requires 2bit format

Convert gb ref to 2bit:

```
module load Miniconda3

conda activate

conda create -n fatotwobit
conda activate fatotwobit
conda install bioconda::ucsc-fatotwobit

faToTwoBit gb_hic_purged_softmasked.fa.masked gb_softmasked.2bit
```

Convert gff3 to bed?
```
module load BEDOPS

gff2bed < mikado.final.longest.gff3 > gb_anno.bed

```

Download Atlantic Salmon ref genome and convert to 2bit 
```
conda install -c conda-forge ncbi-datasets-cli

datasets download genome accession GCF_905237065.1 --include gff3,genome,seq-report
unzip -d atlantic_salmon ncbi_dataset.zip
## lowkey dont need all of those but may as well have them if needed

faToTwoBit atlantic_salmon/ncbi_dataset/data/GCF_905237065.1/GCF_905237065.1_Ssal_v3.1_genomic.fna salmo_salar.2bit
```

Other genomes:
```
## Northern pike
datasets download genome accession GCF_011004845.1 --include gff3,genome,seq-report
unzip -d northern_pike/ ncbi_dataset.zip

## Greater argentine
datasets download genome accession GCA_951799395.1 --include gff3,seq-report
unzip -d greater_argentine/ ncbi_dataset.zip

## Salamanderfish
datasets download genome accession GCA_049190665.1 --include gff3,genome,seq-report
unzip -d salamanderfish/ ncbi_dataset.zip

## Zebrafish
datasets download genome accession GCF_049306965.1 --include gff3,genome,seq-report
unzip -d zebrafish/ ncbi_dataset.zip
```
```
faToTwoBit greater_argentine/ncbi_dataset/data/GCA_951799395.1/GCA_951799395.1_fArgSil1.1_genomic.fna argentina_silus.2bit

faToTwoBit northern_pike/ncbi_dataset/data/GCF_011004845.1/GCF_011004845.1_fEsoLuc1.pri_genomic.fna esox_lucius.2bit

faToTwoBit salamanderfish/ncbi_dataset/data/GCA_049190665.1/GCA_049190665.1_fLepSal2.hap1_genomic.fna lepidogalaxias_salamandroides.2bit

faToTwoBit zebrafish/ncbi_dataset/data/GCF_049306965.1/GCF_049306965.1_GRCz12tu_genomic.fna danio_rerio.2bit
```

makelastchainz
```
git clone https://github.com/hillerlab/make_lastz_chains.git
cd make_lastz_chains

./install_dependencies.py
module load LASTZ
module load Nextflow

### Minimal example
./make_chains.py galaxias atl_salmon ../toga_genomes/gb_softmasked.2bit ../toga_genomes/salmo_salar.2bit --executor slurm --project_dir test_salmo -f

```
trying to do a test run in terminal but getting an error smh


Run toga (no chain file yet)
```
toga.py --project_dir togaout/ --limit_to_ref_chrom ptg000017l_1 
```

TRYING IN AORAKI
```
conda create -n TOGA_env python=3.11
conda activate TOGA_env
Conda install -c bioconda bedparse ucsc-fatotwobit ucsc-twobitinfo

git clone https://github.com/hillerlab/make_lastz_chains.git
cd make_lastz_chains/

conda install bioconda::lastz
module load nextflow  ## DONT WANNA FUCK ARND WITH THIS SO JUST LOAD MODULE FIRST

chmod +x install_dependencies.py 
./install_dependencies.py

```

problem with fatotwobit - libssl.so.1.0.0 error no such file fml

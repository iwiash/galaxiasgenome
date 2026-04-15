## pcadapt
Different method of outlier testing (as opposed to BayeScan)

```
working in ~/nobackup/sourcefiles/GBS/sourcefiles/pcadapt
```

### PLINK

pcadapt takes a bed file so first convert lowdata/island pop removed VCF to bed with plink

```
module load PLINK/2.00a6.9

plink2 --vcf sub_master_renamed_no_islands_sorted_nov25.vcf --make-bed --out plink_renamed_noisland_nov25
```

### PCADAPT

### Move into R to run 

(insert pcadapt md here)

### Back to Jupyter to map SNPs
```
 mkdir outlier_mapping
 cd outlier_mapping/
```

cut snps from VCF and assign line numbers 
```
 grep -v "^#" ../sub_master_renamed_no_islands_sorted_nov25.vcf | cut -f1-3 | awk '{print $0"\t"NR}' > no_islands_renamed_SNPs.txt
 ```

pull line numbers from outlier file
```
 awk '{print $2}' ../bonferroni_adjusted_outliers_0.1thres.txt > pcadapt_bonferroni0.1_outliers_noisland_numbers.txt
```

Make list of outlier SNP IDs
```
awk 'FNR==NR{a[$1];next} (($4) in a)' pcadapt_bonferroni0.1_outliers_noisland_numbers.txt no_islands_renamed_SNPs.txt  | cut -f3 > pcadapt_outlierSNPIDs_bonferroni0.1_noislands.txt
```

Maybe alter to include scaff #s
```
awk 'FNR==NR{a[$1];next} (($4) in a)' pcadapt_bonferroni0.1_outliers_noisland_numbers.txt no_islands_renamed_SNPs.txt  | cut -f1-3 > pcadapt_outlierSNPIDs_bonferroni0.1_noislands.txt
```

ultimately could just use snp ids but i like being able to look per scaffold easily so i like having both

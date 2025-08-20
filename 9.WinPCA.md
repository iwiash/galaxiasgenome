Dependencies stuff
```
module load Python

pip install scikit-allel
```

Clone git
```
git clone https://github.com/MoritzBlumer/winpca.git

chmod +x winpca/winpca
```

Add winpca to bin
```
cd /home/iwias275/bin

ln -s /home/iwias275/nobackup/source_files/GBS/source_files/winpca/winpca/winpca
```
link the winpca function into bin - can call it as 'winpca' instead of having to ./winpca
Should maybe do this with LDBlockshow too..

Changed the snps per window down from 20 to 10 to increase the amt of scaff21 called - couldnt figure out how to do with flags so had to alter the config py
Run PCA 
```
winpca pca newgb_fulldata fulldata_islandsincl_sorted.vcf scaffold_0021:222179-8840409 
```

Run plot
```
winpca chromplot newgb_fulldata scaffold_0021:222179-8840409 -m all_locations_no_lowdata_FULL_METADATA.txt -g MIGRATORY-STATUS -c Diadromous:2596BE,Non-Diadromous:be2528
```


rerun plots for a couple more scaffolds
```
winpca pca scaffold0001 fulldata_islandsincl_sorted.vcf scaffold_0001:838277-27914757

winpca chromplot scaffold0001 scaffold_0001:838277-27914757 -m all_locations_no_lowdata_FULL_METADATA.txt -g MIGRATORY-STATUS -c Diadromous:2596BE,Non-Diadromous:be2528
```

```
winpca pca scaffold0007 fulldata_islandsincl_sorted.vcf scaffold_0007:19978-12821445

winpca chromplot scaffold0007 scaffold_0007:19978-12821445 -m all_locations_no_lowdata_FULL_METADATA.txt -g MIGRATORY-STATUS -c Diadromous:2596BE,Non-Diadromous:be2528
```

blue: 2596BE  red: be2528


rerun scaff 21 zoomed in?
```
winpca pca zoomed_scaff21 fulldata_islandsincl_sorted.vcf scaffold_0021:1922178-8840409
```
coz theres nothing for ages at the start


genome plot all:
```
CHROMS='scaffold0001,scaffold0007,scaffold0021,scaffold0037,scaffold0080'

winpca genomeplot ./ $CHROMS -m all_locations_no_lowdata_FULL_METADATA.txt -g MIGRATORY-STATUS -c Diadromous:2596BE,Non-Diadromous:be2528
```

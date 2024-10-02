## Running purge_dups (Lydia method/stepwise)

**1. minimap2 to align reads to reference** 
```
sbatch gbminimap2.sl
```
[gbminimap2.sl](gbminimap2.sl) - aligns and converts aligned sam to paf.gz for next steps
edit: i actually think it didnt convert to paf -a outputs as sam i think - so GB_aln.paf.gz is a sam i think?? just compressed
downstream steps all ran empty when using the output from this one so i reran it slightly differently
```
seff 50616280

output:
Job ID: 50616280
Cluster: mahuika
User/Group: iwias275/iwias275
State: COMPLETED (exit code 0)
Nodes: 1
Cores per node: 16
CPU Utilized: 4-04:58:41
CPU Efficiency: 56.79% of 7-09:48:00 core-walltime
Job Wall-clock time: 11:06:45
Memory Utilized: 10.92 GB
Memory Efficiency: 34.13% of 32.00 GB
```
if need to rerun can reduce memory/time

[minimap_paf.sl](minimap_paf.sl) - reran with xasm20 and with paf output?
<!--xasm20 for CSS reads - im honestly still unclear on if this was right or should stick with map-hifi but... whats done is done--> 
```
sbatch minimap_paf.sl

seff
Job ID: 50638268
Cluster: mahuika
User/Group: iwias275/iwias275
State: COMPLETED (exit code 0)
Nodes: 1
Cores per node: 16
CPU Utilized: 4-04:44:24
CPU Efficiency: 99.06% of 4-05:41:52 core-walltime
Job Wall-clock time: 06:21:22
Memory Utilized: 6.68 GB
Memory Efficiency: 20.89% of 32.00 GB
```
didnt reduce mem coz i got scared but def can
<!--not sure if this was strictly necessary - could have converted the sam manually? but idk how to do that so!-->

**2. stats for mapped long reads**
```
pbcstat GB_aln.paf.gz #produces PB.base.cov and PB.stat files

calcuts PB.stat > cutoffs 2>calcults.log
```
**3. split assembly and do self-self alignment?**
```
split_fa GB_full.p_ctg.fa > GB_asm.split

minimap2 -xasm5 -DP GB_asm.split GB_asm.split | gzip -c - > GB_asm.split.self.paf.gz
```
splits the assembly then aligns to itself??? whu

**4. purge haplotigs and duplicates**
```
purge_dups -2 -T cutoffs -c PB.base.cov GB_asm.split.self.paf.gz > dups.bed 2> purge_dups.log
```

**5. Get purged primary and haplotig sequences from draft assembly** 
```
get_seqs -e dups.bed GB_full.p_ctg.fa

OUTPUT:
[W::get_seqs_core] ptg000001l 3240744 3276904 is skipped
[W::get_seqs_core] ptg000039l 3478938 3546001 is skipped
[W::get_seqs_core] ptg000073l 1330939 1349834 is skipped
[W::get_seqs_core] ptg000099l 1182349 1251107 is skipped
[W::get_seqs_core] ptg000187l 202589 420058 is skipped
```
is this right?????? im so confused
-e option means only removes duplications from ends of contigs - remove if want to take from middle as well but might delete false positive duplications

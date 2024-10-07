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

**looking at output hap.fa**
```
gfastats hap.fa

OUTPUT:
+++Assembly summary+++: 
# scaffolds: 397
Total scaffold length: 28433761
Average scaffold length: 71621.56
Scaffold N50: 106848
Scaffold auN: 698905.64
Scaffold L50: 33
Largest scaffold: 3280424
Smallest scaffold: 12723
# contigs: 397
Total contig length: 28433761
Average contig length: 71621.56
Contig N50: 106848
Contig auN: 698905.64
Contig L50: 33
Largest contig: 3280424
Smallest contig: 12723
# gaps in scaffolds: 0
Total gap length in scaffolds: 0
Average gap length in scaffolds: 0.00
Gap N50 in scaffolds: 0
Gap auN in scaffolds: 0.00
Gap L50 in scaffolds: 0
Largest gap in scaffolds: 0
Smallest gap in scaffolds: 0
Base composition (A:C:G:T): 7128599:6979205:7035298:7290659
GC content %: 49.29
# soft-masked bases: 0
# segments: 397
Total segment length: 28433761
Average segment length: 71621.56
# gaps: 0
# paths: 397
```
this is way smaller than the initial assemblies.  maybe it is not the final purged assembly but im not sure what that is then..

**looking at purged.fa**
```
gfastats purged.fa

OUTPUT:
+++Assembly summary+++: 
# scaffolds: 266
Total scaffold length: 603880988
Average scaffold length: 2270229.28
Scaffold N50: 8857421
Scaffold auN: 8856822.02
Scaffold L50: 24
Largest scaffold: 27992649
Smallest scaffold: 17764
# contigs: 266
Total contig length: 603880988
Average contig length: 2270229.28
Contig N50: 8857421
Contig auN: 8856822.02
Contig L50: 24
Largest contig: 27992649
Smallest contig: 17764
# gaps in scaffolds: 0
Total gap length in scaffolds: 0
Average gap length in scaffolds: 0.00
Gap N50 in scaffolds: 0
Gap auN in scaffolds: 0.00
Gap L50 in scaffolds: 0
Largest gap in scaffolds: 0
Smallest gap in scaffolds: 0
Base composition (A:C:G:T): 169868341:132259585:132197431:169555631
GC content %: 43.79
# soft-masked bases: 0
# segments: 266
Total segment length: 603880988
Average segment length: 2270229.28
# gaps: 0
# paths: 266
```
this seems way more palusible but idk where it came from

## BUSCO
running BUSCO on the purged.fa file to see how it looks:
```
busco -i purged.fa -m geno -o gbrev_purged_BUSCO -l eukaryota_odb10
```
same as before purging

## purge_haplotigs
```
samtools view -bS GB_aln.sam | samtools sort -o GB_aln_sorted.bam -T tmp.ali
```
sam > sorted bam
```
purge_haplotigs hist -t 10 -b GB_aln_sorted.bam \ 
	-g gbrev_hifi_reads.fq.gz
```


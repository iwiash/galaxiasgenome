Processing of total gbrev Hifi data

Modules
```
module load SAMtools
module load pigz
module load NanoComp
module load cutadapt
```

Convert to fastq
```
samtools fastq -@4 GbrevPB.hifi_reads.bam | pigz > gbrev_hifi_reads.fq.gz

#Output:
[M::bam2fq_mainloop] discarded 0 singletons
[M::bam2fq_mainloop] processed 6826044 reads
```

NanoComp
```
NanoComp --fastq gbrev_hifi_reads.fq.gz --names Gbrev_PacBio_HiFi --outdir nanocomp_assembly_hifi
```

Cutadapt
```
cutadapt -b "AAAAAAAAAAAAAAAAAATTAACGGAGGAGGAGGA;min_overlap=35" \
> -b "ATCTCTCTCTTTTCCTCCTCCTCCGTTGTTGTTGTTGAGAGAGAT;min_overlap=45" \
> --discard-trimmed \
>  -o /dev/null \
> gbrev_hifi_reads.fq.gz \
> -j 0 \
> --revcomp \
> -e 0.05
```
Output:
```
=== Summary ===

Total reads processed:               6,826,044
Reads with adapters:                         1 (0.0%)
Reverse-complemented:                        0 (0.0%)

== Read fate breakdown ==
Reads discarded as trimmed:                  1 (0.0%)
Reads written (passing filters):     6,826,043 (100.0%)

Total basepairs processed: 91,974,606,973 bp
Total written (filtered):  91,974,589,506 bp (100.0%)

=== Adapter 1 ===

Sequence: AAAAAAAAAAAAAAAAAATTAACGGAGGAGGAGGA; Type: variable 5'/3'; Length: 35; Trimmed: 0 times; Reverse-complemented: 0 times

=== Adapter 2 ===

Sequence: ATCTCTCTCTTTTCCTCCTCCTCCGTTGTTGTTGTTGAGAGAGAT; Type: variable 5'/3'; Length: 45; Trimmed: 1 times; Reverse-complemented: 0 times
0 times, it overlapped the 5' end of a read
1 times, it overlapped the 3' end or was within the read

Minimum overlap: 45
No. of allowed errors:
1-19 bp: 0; 20-39 bp: 1; 40-45 bp: 2

Overview of removed sequences (5')
length  count   expect  max.err error counts



Overview of removed sequences (3' or within)
length  count   expect  max.err error counts
17444   1       0.0     2       1
```

HiC

Trimming UMIs - remove first 10 bases

```
zcat Bruce_fish_HiC_S1_R1_001.fastq.gz | awk '{ if(NR%2==0) {print substr($1,10)} else {print} }' | gzip > Fish_HiC_trimmed_R1_001.fastq.gz

zcat Bruce_fish_HiC_S1_R2_001.fastq.gz | awk '{ if(NR%2==0) {print substr($1,10)} else {print} }' | gzip > Fish_HiC_trimmed_R2_001.fastq.gz
```
R1 and R2 are the forward and reverse reads - first readd in R1 matches first read in R2

Assembly

```
nano hifiasmHIC.sl (see hifiasmHIC.sl)

sbatch hifiasm.sl
```
 gfastats

 ```
module load gfastats

gfastats GB_full_HIC.p_ctg.fa
```
gfastats output:
```
+++Assembly summary+++: 
# scaffolds: 664
Total scaffold length: 630588521
Average scaffold length: 949681.51
Scaffold N50: 7215088
Scaffold auN: 8253254.37
Scaffold L50: 27
Largest scaffold: 28003021
Smallest scaffold: 12723
# contigs: 664
Total contig length: 630588521
Average contig length: 949681.51
Contig N50: 7215088
Contig auN: 8253254.37
Contig L50: 27
Largest contig: 28003021
Smallest contig: 12723
# gaps in scaffolds: 0
Total gap length in scaffolds: 0
Average gap length in scaffolds: 0.00
Gap N50 in scaffolds: 0
Gap auN in scaffolds: 0.00
Gap L50 in scaffolds: 0
Largest gap in scaffolds: 0
Smallest gap in scaffolds: 0
Base composition (A:C:G:T): 176460736:138981680:138809043:176337062
GC content %: 44.05
# soft-masked bases: 0
# segments: 664
Total segment length: 630588521
Average segment length: 949681.51
# gaps: 0
# paths: 664
```
gfastats for non Hi-C assembly:
```
+++Assembly summary+++: 
# scaffolds: 639
Total scaffold length: 632314749
Average scaffold length: 989537.95
Scaffold N50: 7968812
Scaffold auN: 8500142.03
Scaffold L50: 26
Largest scaffold: 27992649
Smallest scaffold: 12723
# contigs: 639
Total contig length: 632314749
Average contig length: 989537.95
Contig N50: 7968812
Contig auN: 8500142.03
Contig L50: 26
Largest contig: 27992649
Smallest contig: 12723
# gaps in scaffolds: 0
Total gap length in scaffolds: 0
Average gap length in scaffolds: 0.00
Gap N50 in scaffolds: 0
Gap auN in scaffolds: 0.00
Gap L50 in scaffolds: 0
Largest gap in scaffolds: 0
Smallest gap in scaffolds: 0
Base composition (A:C:G:T): 176996940:139238790:139232729:176846290
GC content %: 44.04
# soft-masked bases: 0
# segments: 639
Total segment length: 632314749
Average segment length: 989537.95
# gaps: 0
# paths: 639
```
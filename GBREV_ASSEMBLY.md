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



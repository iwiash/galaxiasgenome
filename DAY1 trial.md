load modules
```
module load pigz
module load SAMtools
module load NanoComp
module load cutadapt
```

**Subset of the data (from module not galax) to confirm it works**
```
zcat /nesi/nobackup/uoo02831/ashleigh/LRA/resources/deepconsensus/m64011_190830_220126.Q20.fastq.gz \
| head -n 200000 | pigz > hifi_50k_reads.fq.gz
```
zcat decompresses the .gz file > head 20000 > pigz compresses to a .gz file

**NanoComp takes FastQs or BAMs and creates summary stats (read lngth, qual score)**
```
NanoComp --fastq hifi_50k_reads.fq.gz --names PacBio_HiFi --outdir nanocomp_hifi
```
Used it just on the hifi reads instead of both coz were not using ONT data with the fish
names tag gives them names in the analysis rather thn just "file 1" "file 2"
outdir tag creates an output dir within ur current dir

 **cutadapt to trim adaptor sequences off**
 ```
 cutadapt \
    -b "AAAAAAAAAAAAAAAAAATTAACGGAGGAGGAGGA;min_overlap=35" \
    -b "ATCTCTCTCTTTTCCTCCTCCTCCGTTGTTGTTGTTGAGAGAGAT;min_overlap=45" \
    --discard-trimmed \
    -o /dev/null \
    hifi_50k_reads.fq.gz \
    -j 0 \
    --revcomp \
    -e 0.05
 ```
-b "seq" specifies the sequence to be cut and the min overlap
-o specifies the output of trimmed reads? in this case /dev/null gets rid of them i think
-j 0 means use all cores to do this
--revcomp makes it reverse complement so it searches on both strands maybe?
-e is error rate of 0.05

OUTPUT:

=== Summary ===

Total reads processed:                  50,000
Reads with adapters:                        19 (0.0%)
Reverse-complemented:                       14 (0.0%)

== Read fate breakdown ==
Reads discarded as trimmed:                 19 (0.0%)
Reads written (passing filters):        49,981 (100.0%)

Total basepairs processed:   925,788,363 bp
Total written (filtered):    925,450,290 bp (100.0%)

=== Adapter 1 ===

Sequence: AAAAAAAAAAAAAAAAAATTAACGGAGGAGGAGGA; Type: variable 5'/3'; Length: 35; Trimmed: 0 times; Reverse-complemented: 0 times

=== Adapter 2 ===

Sequence: ATCTCTCTCTTTTCCTCCTCCTCCGTTGTTGTTGTTGAGAGAGAT; Type: variable 5'/3'; Length: 45; Trimmed: 19 times; Reverse-complemented: 14 times
0 times, it overlapped the 5' end of a read
19 times, it overlapped the 3' end or was within the read

Minimum overlap: 45
No. of allowed errors:
1-19 bp: 0; 20-39 bp: 1; 40-45 bp: 2

Overview of removed sequences (5')
length  count   expect  max.err error counts

Overview of removed sequences (3' or within)
length  count   expect  max.err error counts
43      3       0.0     2       0 0 3
44      2       0.0     2       0 2
70      1       0.0     2       1
84      1       0.0     2       1
85      2       0.0     2       1 0 1
86      3       0.0     2       3
87      1       0.0     2       1
404     1       0.0     2       1
725     1       0.0     2       0 1
4075    1       0.0     2       0 1
10709   1       0.0     2       0 0 1
16064   1       0.0     2       1
18881   1       0.0     2       0 0 1

idk if i rly need to save this but im gonna

##Now for fish

```
samtools fastq -@4 GbrevPB.hifi_reads.bam | head -n 100000 | pigz > gbrev_hifi_read_subset.fq.gz
```
use the ONT downsample code instead
converts bam to fastq, subsets 100000 lines, compresses fastq w pigz

**nanocomp**
```
NanoComp --fastq gbrev_hifi_read_subset.fq.gz --names PacBio_Hifi --outdir nanocomp_gbrev_hifi
```
makes lots of plots and summary stats

**cutadapt to remove adapter seq**
```
cutadapt \
-b "AAAAAAAAAAAAAAAAAATTAACGGAGGAGGAGGA;min_overlap=35" \
-b "ATCTCTCTCTTTTCCTCCTCCTCCGTTGTTGTTGTTGAGAGAGAT;min_overlap=45" \
--discard-trimmed \
-o /dev/null \
gbrev_hifi_read_subset.fq.gz \
-j 0 --revcomp -e 0.05
```
-b - which seq to cut
discard trimmed - get rid of trimmed seq
-o output file, /dev/null is a file in unix-likes that discards data written to it
-j 0 - number of cpu threads to use - 0 uses as many threads as there are cpu cores available?
--revcomp - reverse complement - tells to reverse complemet after trimming
-e - error rate set to 0.05 - only trims if seq matches with error rate of 5% or less

*Output:*
=== Summary ===

Total reads processed:                  25,000
Reads with adapters:                         0 (0.0%)
Reverse-complemented:                        0 (0.0%)

== Read fate breakdown ==
Reads discarded as trimmed:                  0 (0.0%)
Reads written (passing filters):        25,000 (100.0%)

Total basepairs processed:   350,979,301 bp
Total written (filtered):    350,979,301 bp (100.0%)

=== Adapter 1 ===

Sequence: AAAAAAAAAAAAAAAAAATTAACGGAGGAGGAGGA; Type: variable 5'/3'; Length: 35; Trimmed: 0 times; Reverse-complemented: 0 times

=== Adapter 2 ===

Sequence: ATCTCTCTCTTTTCCTCCTCCTCCGTTGTTGTTGTTGAGAGAGAT; Type: variable 5'/3'; Length: 45; Trimmed: 0 times; Reverse-complemented: 0 times

**doesn't look like it trimmed anything- no adapter seq in data hopefully**


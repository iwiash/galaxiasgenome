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
 >>>maybe split doc here?  its getting kind of unwieldy -preprocessing vs post assembly qc - or just fix the formatting
 
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
purge_dups

```
module load purge_dups
```
create config file
```
pd_config.py -l tempdir -n config_gbrev.json GB_full.p_ctg.fa asm1_config_ref
```
try for src using . or "." if that doesnt work

step 3 that didnt work:
```
run_purge_dups.py config_gbrev.json /opt/nesi/CS400_centos7_bdw/purge_dups/1.2.6-gimkl-2022a-Python-3.10.5/bin/purge_dups gBrev1

```
ok purgedups did not work - tabled for now

## purge_haplotigs:
```
module load minimap2
module load SAMtools
module load BEDTools
module load purge_haplotigs
```
### 1.  mapping longreads back to assembly:
```
minimap2 -ax map-hifi GB_full.p_ctg.fa gbrev_hifi_reads.fq.gz --secondary=no | samtools sort -m 5G -o gb_aligned.bam -T tmp.ai

```
-ax - output as sam, presets for hifi mapping
(assembly) (longreads) 
--secondary=no - i have no clue
pipe to samtools, idk what sort does -m looks like memory 2 use? -o output bam and idk what -T is   maybe temporary files

**ASIDE: rerunning this with the specific numbers from sebastian code and also adding the .fa to end of alignment = failed**
output:
```
[M::mm_idx_gen::12.600*1.62] collected minimizers
[M::mm_idx_gen::16.041*1.69] sorted minimizers
[M::main::16.041*1.69] loaded/built the index for 639 target sequence(s)
[M::mm_mapopt_update::16.679*1.66] mid_occ = 186
[M::mm_idx_stat] kmer size: 19; skip: 19; is_hpc: 0; #seq: 639
[M::mm_idx_stat::17.045*1.65] distinct minimizers: 44477099 (93.34% are singletons); average occurrences: 1.487; average spacing: 9.562; total length: 632314749
[M::worker_pipeline::562.797*1.98] mapped 35601 sequences
[M::worker_pipeline::1006.383*1.99] mapped 35543 sequences
[M::worker_pipeline::1515.339*1.99] mapped 35679 sequences
[M::worker_pipeline::1944.151*1.99] mapped 35729 sequences
[E::sam_parse1] SEQ and QUAL are of different length
[W::sam_read1_sam] Parse error at line 152657
samtools sort: truncated file. Aborting
```

### 2. create histogram with purge_haplotigs
```
purge_haplotigs hist -b gb_aligned.bam -g GB_full.p_ctg.fa
```
-b bam?  - g genome?

this failed boooo

## rerunning purge_dups without json based on lydia code

### minimap2 
aligning reads to the genome 
```
minimap2 -ax map-hifi GB_full.p_ctg.fa gbrev_hifi_reads.fq.gz > aln.sam
```
first little bit of output was this:
```
[M::mm_idx_gen::11.710*1.62] collected minimizers
[M::mm_idx_gen::14.836*1.69] sorted minimizers
[M::main::14.837*1.69] loaded/built the index for 639 target sequence(s)
[M::mm_mapopt_update::15.431*1.66] mid_occ = 186
[M::mm_idx_stat] kmer size: 19; skip: 19; is_hpc: 0; #seq: 639
[M::mm_idx_stat::15.769*1.65] distinct minimizers: 44477099 (93.34% are singletons); average occurrences: 1.487; average spacing: 9.562; total length: 632314749
then just those ### reads mapped
```
set running for 8 hours and did not finish... might have to send off as a job

ok working bit of purge_dups code is now in [purge_dups.md](purge_dups.md)

## Jellyfish

```
jellyfish count -m 21 -s 100M -t 4 -C <(zcat gbrev_hifi_reads.fq.gz)
```
counts canonical(-C) 21-mers in the sequence file

memory issue - ran with -t 4 and 32 G
plot histogram:
```
jellyfish histo -t 4 mer_counts.jf > gb_reads.histo
```





### BUSCO???
```
 busco -i GB_full.p_ctg.fa -m geno -o gbrev --auto-lineage-euk
```
i kinda dont know how this works so i dont know if this actually ran right or not

looks like it has output some stuff?
```
# BUSCO version is: 5.6.1 
# The lineage dataset is: eukaryota_odb10 (Creation date: 2024-01-08, number of genomes: 70, number of BUSCOs: 255)
# Summarized benchmarking in BUSCO notation for file /scale_wlg_nobackup/filesets/nobackup/uoo02831/ashleigh/source_files/genome/Gbrev_assembly/asm1_purgedups/GB_full.p_ctg.fa
# BUSCO was run in mode: euk_genome_met
# Gene predictor used: metaeuk

	***** Results: *****

	C:99.6%[S:96.1%,D:3.5%],F:0.0%,M:0.4%,n:255	   
	254	Complete BUSCOs (C)			   
	245	Complete and single-copy BUSCOs (S)	   
	9	Complete and duplicated BUSCOs (D)	   
	0	Fragmented BUSCOs (F)			   
	1	Missing BUSCOs (M)			   
	255	Total BUSCO groups searched		   

Assembly Statistics: <- nothing under here?


Dependencies and versions:
	hmmsearch: 3.3
	bbtools: 39.01
	metaeuk: GITDIR-NOTFOUND  <- is this bad?
	busco: 5.6.1
```
but on the log file it says it failed sooooooo idk  prob should just wait till later and stop randomly running things

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

Processing of total gbrev Hifi data

Convert to fastq
```
samtools fastq -@4 GbrevPB.hifi_reads.bam | pigz > gbrev_hifi_reads.fq.gz

#Output:
[M::bam2fq_mainloop] discarded 0 singletons
[M::bam2fq_mainloop] processed 6826044 reads
```

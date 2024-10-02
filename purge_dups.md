## Running purge_dups (Lydia method/stepwise)

**1. minimap2 to align reads to reference** 
```
sbatch gbminimap2.sl
```
aligns and converts aligned sam to paf.gz for next steps
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

**2. stats for mapped long reads**
```
pbcstat GB_aln.paf.gz
```
produces PB.base.cov and PB.stat files

#!/bin/bash -e
#SBATCH --job-name=gbminimap # Job name (shows up in the queue)
#SBATCH --time=20:00:00      # Walltime (HH:MM:SS) 48h
#SBATCH --mem=32G            # Memory in MB
#SBATCH --account=uoo02831
#SBATCH --cpus-per-task=16

module load minimap2/2.24-GCC-11.3.0
module load SAMtools/1.16.1-GCC-11.3.0

minimap2 \
    -t 16 -ax map-hifi \
    purged.fa gbrev_hifi_reads.fq.gz \
    --secondary=no | samtools sort -m 5G -o align_rerun.bam -T temp.ali \
    2> minimap2_rerun_errors.log

echo "alignment and file conversion complete"

#minimap header or smt inside of other bam is causing probs w purge_haplotigs
#rerun with exact ver # from Sebastian code and with a big memory to make sure its not a memory problem

#Submitted batch job 51355133

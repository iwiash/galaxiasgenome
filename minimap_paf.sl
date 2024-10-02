#!/bin/bash -e
#SBATCH --job-name=gbminimap # Job name (shows up in the queue)
#SBATCH --time=12:00:00      # Walltime (HH:MM:SS) 48h
#SBATCH --mem=15G            # Memory in MB
#SBATCH --account=uoo02831
#SBATCH --cpus-per-task=16

module load minimap2

minimap2 \
    -t 16 -x asm20 \
    GB_full.p_ctg.fa gbrev_hifi_reads.fq.gz \
    | gzip -c - > gbrev_hifi_reads.paf.gz \
    2> minimap2_errors2.log

echo "Alignment and PAF conversion done."

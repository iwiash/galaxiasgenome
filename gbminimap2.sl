#!/bin/bash -e
#SBATCH --job-name=gbminimap Job name (shows up in the queue)
#SBATCH --time=48:00:00      # Walltime (HH:MM:SS) 48h
#SBATCH --mem=32G          # Memory in MB
#SBATCH --account=uoo02831
#SBATCH --cpus-per-task=16

module load purge_dups
module load minimap2
module load SAMtools
module load BEDTools 
#dont think i actually need sam/bed/purgedups here.. take out?

minimap2 \
    -t 16 -ax map-hifi \
    GB_full.p_ctg.fa gbrev_hifi_reads.fq.gz \
    > GB_aln.sam \
    2> minimap2_errors.log

echo "alignment done"

gzip -c GB_aln.sam > GB_aln.paf.gz

echo "file conversion done"

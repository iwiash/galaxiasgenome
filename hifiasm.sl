#!/bin/bash -e
#SBATCH --job-name=SerialJob # job name (shows up in the queue)
#SBATCH --time=48:00:00      # Walltime (HH:MM:SS) 48h
#SBATCH --mem=230G          # Memory in MB
#SBATCH --account=uoo02831
#SBATCH --cpus-per-task=128
#SBATCH --partition=milan
module load hifiasm

hifiasm \
    -o GB_full \
    -t 128 \
    gbrev_hifi_reads.fq.gz \
    2> test.log

echo "assembly done, starting onversion"

awk '/^S/{print ">"$2;print $3}' \
    GB_full.bp.p_ctg.gfa \
    > GB_full.p_ctg.fa

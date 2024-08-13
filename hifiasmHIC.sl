#!/bin/bash -e
#SBATCH --job-name=SerialJob # job name (shows up in the queue)
#SBATCH --time=48:00:00      # Walltime (HH:MM:SS) 48h
#SBATCH --mem=230G          # Memory in MB
#SBATCH --account=uoo02831
#SBATCH --cpus-per-task=128
#SBATCH --partition=milan
module load hifiasm

hifiasm \
    -o GB_full_HIC \
    -t128 \
    --h1 Fish_HiC_trimmed_R1_001.fastq.gz \
    --h2 Fish_HiC_trimmed_R2_001.fastq.gz \
    gbrev_hifi_reads.fq.gz\
    2> test.log

echo "assembly done, starting conversion"

awk '/^S/{print ">"$2;print $3}' \
    GB_full_HIC.hic.p_ctg.gfa \
    > GB_full_HIC.p_ctg.fa




#!/bin/bash -e
#SBATCH --job-name=hic_hifiasm_rerun # job name (shows up in the queue)
#SBATCH --time=48:00:00      # Walltime (HH:MM:SS) 48h
#SBATCH --mem=230G          # Memory in MB
#SBATCH --account=uoo02831
#SBATCH --cpus-per-task=128
#SBATCH --partition=milan

module load hifiasm

hifiasm \
    -o hifiasm_umi_outputs/GB_HIC_asm \
    -t128 \
    --h1 Bruce_fish_HiC_S1_R1_001.fastq.gz \
    --h2 Bruce_fish_HiC_S1_R2_001.fastq.gz \
    gbrev_hifi_reads.fq.gz\
    2> test.log

echo "assembly done, starting conversion"

awk '/^S/{print ">"$2;print $3}' \
    GB_HIC_asm.hic.p_ctg.gfa \
    > GB_HIC_asm.p_ctg.fa

echo "conversion done"

#batch job 52209203
#Submitted batch job 52890176 - with 96


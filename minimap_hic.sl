#!/bin/bash -e
#SBATCH --job-name=gbminimaphic # Job name (shows up in the queue)
#SBATCH --time=20:00:00      # Walltime (HH:MM:SS) 48h
#SBATCH --mem=32G            # Memory in MB
#SBATCH --account=uoo02831
#SBATCH --cpus-per-task=16

module load minimap2/2.24-GCC-11.3.0
module load SAMtools/1.16.1-GCC-11.3.0

minimap2 \
    -t 16 -ax map-hifi \
    GB_full_HIC.p_ctg.fa gbrev_hifi_reads.fq.gz \
    --secondary=no | samtools sort -m 5G -o hic_asm_minimap_align.bam -T temp.ali \
    2> minimap2_hic_errors.log

echo "alignment and file conversion complete"

#minimap maps raw reads to asm, samtools converts to sorted bam?

##Batch job 52147351

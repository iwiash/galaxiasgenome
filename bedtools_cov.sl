#!/bin/bash
#SBATCH --job-name=coverage_job        # Job name
#SBATCH --output=coverage_job.out      # Output file
#SBATCH --error=coverage_job.err       # Error file
#SBATCH --cpus-per-task=16             # Number of threads (adjust if needed)
#SBATCH --mem=32G                      # Memory per node (adjust based on estimate)
#SBATCH --time=24:00:00                # Max time for the job (adjust based on your estimate)

# Load necessary modules
module load BEDTools
module load SAMtools

# Run the bedtools coverage command
bedtools coverage -a purged_genome_windows.bed \
                  -b align_rerun.bam \
                  -mean \
                  > coverage_20k_windows.txt \
                  2> coverage_errors.log

echo "coverage finished"

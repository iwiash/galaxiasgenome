# galaxiasgenome

Code and file involved in the assembly of a Tasmanian *Galaxias brevipinnis* reference genome using PacBio HiFi sequence data

[1.Initial_gbrev_assembly.md](1.Initial_gbrev_assembly.md) - all code for raw read preprocessing and intial hifiasm assembly of draft *Galaxias brevipinnis* reference genome

  [hifiasm.sl](hifiasm.sl) - slurm script for running hifiasm assembly on PacBio sequence data and conversion to fasta

  [hifiasmHIC.sl](hifiasmHIC.sl) - slurm script for hifiasm assembly on PacBio alongside HiC data

[2.gbrev_assembly_qc](2.gbrev_assembly_QC.md) - quality control steps undertaken on genome includes purge_dups, jellyfish, purge_haplotigs, BUSCO

  [gbminimap2.sl](gbminimap2.sl) - script to run minimap2 read alignment to assembly for use in purge_dups/haplotigs
  
  [minimap_paf.sl](minimap_paf.sl) - script - reran to output as a .paf file rather than SAM output


also various note files - dw abt them

#!/bin/bash
#module load miniconda3
#SBATCH -t 2:00:00
#you need to have the miniconda moduel loaded in the base shell which calls this

snakemake -j 20 --use-conda --cluster-config config/slurm_cfg.json --cluster "sbatch --mem={cluster.mem} -t {cluster.time} -c {threads}"

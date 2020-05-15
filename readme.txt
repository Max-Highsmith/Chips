This currently works to identify peaks from chip-seq data starting with SRA
There is an error in prefetching SRA files, but if the SRA files are added initially then the pipeline will run through to MACS2 peak identification

USE Instructions:
	1. edit config/slurm_cfg.json to set REF_INDEX and other parameters specific to your cluster
	2. edit Snakefile small_chip_SRAs to have the proper SRA numbers corresponding to analyzed chip data
	3. run "sbatch runall.sh"
	

TODO:
	1. move small_chip_SRAs to config
	2. Incoporate deduping

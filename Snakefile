#  rep 2 untreated H3k27ac  SRR11551734
#  rep 2 untreated h3k4me3  SRR11551735 
#  day 3 H3K27ac SRR11551736
#  day 3 H3K4me3
#  drug removal H3K27ac
#  drug removal H3K4me3
#  rep 1 untreated H3k427ac
#  rep 1 untreated H3K4me3
#  day 32 H3rKk27Ac
#  day 32 H3K4Me3 SRR11551743 

configfile: "config/slurm_cfg.json"

Chip_SRAs       = [11551734, 11551735, 11551736, 11551737, 11551738, 11551739, 11551740, 11551741, 11551742, 11551743]
small_chip_SRAs = [11551734, 11551735, 11551736]

rule all:
	input:
		#expand("FAST_Q/SRR{SRAs}.fastq", SRAs=small_chip_SRAs)
		#expand("Align/{SRAs}/Aligned.sortedByCoord.out.bam", SRAs=small_chip_SRAs)
		expand("MACS/{SRAs}_peaks.narrowPeak", SRAs=small_chip_SRAs)

rule get_sra_num:
	conda:
		"workflow/envs/chip_env.yml"
	output:
		sra_file="SRR{sra_num}/SRR{sra_num}.sra"
	threads:1
	shell:'''
		prefetch SRR{wildcards.sra_num}
		'''

rule get_fast_q:
	conda:
		"workflow/envs/chip_env.yml"
	input:
		sra_file="SRR{sra_num}/SRR{sra_num}.sra"
	output:
		fq="FAST_Q/SRR{sra_num}.fastq"
	threads:1
	shell:'''
		fastq-dump {input.sra_file} -O FAST_Q
		'''
rule align:
	conda:
		"workflow/envs/star.yml"

	input:
		fq="FAST_Q/SRR{sra_num}.fastq"
	params:
		core=config['CORES'],
		ref=config['REF_INDEX']

	output:
		"Align/{sra_num}/Aligned.sortedByCoord.out.bam"
	threads:
		int(config["CORES"])
	shell:
		'''STAR --genomeDir {params.ref} --runThreadN {params.core} --readFilesIn {input.fq} --outFileNamePrefix Align/{wildcards.sra_num}/ --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outSAMattributes Standard'''

rule peak_macs:
	conda:
		"workflow/envs/macs.yml"
	input:
		bam="Align/{sra_num}/Aligned.sortedByCoord.out.bam"
	output:
		"MACS/{sra_num}_peaks.narrowPeak"
	threads: 1
	shell:'''
		macs2 callpeak -t {input.bam} -f BAM -n {wildcards.sra_num} --outdir MACS
		'''
		







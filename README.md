# atac-seq
Pipeline to analyze ATAC-seq data on the HPCC using SLURM.

## Steps
1. Create a directory for analysis.
2. Prepare a samplesheet table in csv format. (ex: samplesheet.csv)
3. Make a Nextflow config file.
4. Download the reference genome and file in your directory.
5. Write a bash script to run the pipeline using SLURM.
6. Run the pipeline from your ATAC-seq directory.

## Create a directory
Login to your HPCC account using OnDemand. Navigate to your home directory by clicking 'Files' in the navigation bar. Select 'Home Directory'.

Create a directory for your analysis by clicking 'New Directory'. Name your directory (ex: atacseq). Navigate to the newly created ATAC-seq directory.

Make sure to upload your data (FASTQ files) into this directory.

## Make a samplesheet table
In your ATAC-seq directory, click 'New File'. Name the file 'samplesheet.csv'. Click the `⋮` symbol and select edit. Create the samplesheet table FOR YOUR DATA. Below is a template:
```
sample,fastq_1,fastq_2,replicate
CONTROL,AEG588A1_S1_L002_R1_001.fastq.gz,AEG588A1_S1_L002_R2_001.fastq.gz,1
CONTROL,AEG588A1_S1_L003_R1_001.fastq.gz,AEG588A1_S1_L003_R2_001.fastq.gz,2
CONTROL,AEG588A1_S1_L004_R1_001.fastq.gz,AEG588A1_S1_L004_R2_001.fastq.gz,3
```
Note: the samplesheet above is an example to show the required format. You will still need to make a samplesheet FOR YOUR DATA.

Save the samplesheet.csv file and return to your ATAC-seq directory.

## Make a Nextflow configuration file to use SLURM as the process executor
In your ATAC-seq directory, click `New File`. Name the file 'nextflow.config'. Click the `⋮` symbol and select edit. Create the Nextflow config file:
```
process {
    executor = 'slurm'
}
```
Save the nextflow.config file and return to your ATAC-seq directory.

## Find your reference genome in ICER common-data OR download the reference genome and gtf files in your directory
The following organisms have updated reference genomes and gtf/gff3 files in common-data: human, mouse, rat, zebrafish, and Arabidopsis. The paths to those files can be found [here](https://github.com/johnvusich/reference-genomes).

In your directory, click `Open in Terminal` to enter a development node. Download the most recent genome primary assembly and gtf for the organism of interest from [Ensembl](https://ensembl.org/). Follow the instructions [here](https://github.com/johnvusich/reference-genomes) to download the reference genome for your organism of interest. This may take more than a few minutes. For example:
```
wget https://ftp.ensembl.org/pub/release-108/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

wget https://ftp.ensembl.org/pub/release-108/gtf/homo_sapiens/Homo_sapiens.GRCh38.108.gtf.gz
```
Note: If you do not download the genome and gtf for the organism that the RNA-seq data is derived from, this pipeline will not work correctly.

## Write a bash script to run the pipeline using SLURM
In your ATAC-seq directory, click `New File`. Name the file 'run_atacseq.sb;. Write the bash script, using #SBATCH directives to set resources, for example:
```
#!/bin/bash

#SBATCH --job-name=$jobname_atacseq
#SBATCH --time=24:00:00
#SBATCH --mem=24GB
#SBATCH --cpus-per-task=8

cd $HOME/atacseq
module load Nextflow/23.10.0

nextflow pull nf-core/atacseq
nextflow run nf-core/atacseq -r 2.1.2 --input ./samplesheet.csv  -profile singularity --outdir ./atacseq_results --fasta ./Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz --gtf ./Homo_sapiens.GRCh38.108.gtf.gz -work-dir $SCRATCH/atacseq_work -c ./nextflow.config
```
Save the run_atacseq.sb file and return to your ATAC-seq directory.

## Run the pipeline
In your ATAC-seq directory, click `Open in Terminal` to enter a development node. Run jobs on the SLURM cluster:
```
sbatch run_atacseq.sb
```
Check the status of your pipeline job:
```
squeue -u $username
```
Note: replace $username with your username

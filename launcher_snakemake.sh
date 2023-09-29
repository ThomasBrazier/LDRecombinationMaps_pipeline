#!/bin/bash
#SBATCH --mail-user=thomas.brazier@univ-rennes1.fr
#SBATCH --mail-type=all
#SBATCH --mem=360GB
#SBATCH --cpus-per-task=16
#SBATCH --time=25-60:00:00
#SBATCH --job-name=LDmap

# Load env
. /local/env/envsnakemake-6.0.5.sh
. /local/env/envsingularity-3.8.5.sh
. /local/env/envconda.sh

dataset=${1}
chrom=${2}
ncores=$(nproc)

export OMP_NUM_THREADS=$ncores


echo "Run pipeline"
snakemake -s Snakefile -p -j $ncores --configfile data/${dataset}/config.yaml --use-conda --nolock --rerun-incomplete --printshellcmds --config dataset=${dataset} chrom=${chrom} cores=$ncores
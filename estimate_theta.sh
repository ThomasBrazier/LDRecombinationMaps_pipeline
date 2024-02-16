#!/bin/bash
#SBATCH --mail-user=thomas.brazier@univ-rennes1.fr
#SBATCH --mail-type=all
#SBATCH --time=12-60:00:00
#SBATCH --job-name=theta

. /local/env/envsnakemake-6.0.5.sh
. /local/env/envsingularity-3.8.5.sh
. /local/env/envconda.sh
snakemake -s estimate_theta.snake -p -j 16 --configfile data/${1}/config.yaml --use-conda --use-singularity --nolock --rerun-incomplete -F

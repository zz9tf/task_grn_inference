#!/bin/bash
#SBATCH --job-name=scprint
#SBATCH --output=logs/%j.out
#SBATCH --error=logs/%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=5:00:00
#SBATCH --mem=64GB
#SBATCH --partition=cpu
#SBATCH --qos long
#SBATCH --mail-type=END,FAIL      
#SBATCH --mail-user=jalil.nourisa@gmail.com  

method="scprint"

source "src/utils/parse_args.sh"
parse_arguments "$@"

# Set up lamindb instance locally (bionty module required by scprint)
_lamin_storage=$(mktemp -d /tmp/lamin_storage_XXXXXX)
/home/zz/miniconda3/envs/genernbi/bin/lamin init --storage ${_lamin_storage} --modules bionty 2>/dev/null || true

/home/zz/miniconda3/envs/genernbi/bin/python src/methods/${method}/script.py \
    --rna $rna --prediction $prediction --tf_all ${tf_all:-resources/grn_benchmark/prior/tf_all.csv}

rm -rf ${_lamin_storage}
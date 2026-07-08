#!/bin/bash

#SBATCH --nodes 1
#SBATCH --job-name test
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --partition gpu
#SBATCH --gres=gpu:1
#SBATCH --reservation=dsu

executable=$1

#Edit according to CUDA Environment
# source env_script.sh

# hostname

# nvidia-smi

#nvcc test.cu -o test
time ./$executable

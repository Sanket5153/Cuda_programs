#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40
#SBATCH --time=1-00:00:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --job=Sanket_GPU_Test
#SBATCH --error=%j.err
#SBATCH --output=%j.out
##SBATCH --reservation=aicte_pune

executable=$1

source source_env.sh

#nvcc test.cu -o test
time ./$executable

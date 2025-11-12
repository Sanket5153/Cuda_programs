#!/bin/bash

#SBATCH -N 2
#SBATCH -J test
#SBATCH -p gpu
#SBATCH --qos=gpumultinode    #(for two gpu)
#SBATCH --gres=gpu:1
##SBATCH --qos=nsm            # (for cpu, hm, and 1 gpu)
#SBATCH --reservation=hpcws

executable=$1

#Edit according to CUDA Environment
source source_env.sh

#nvcc test.cu -o test
time ./$executable



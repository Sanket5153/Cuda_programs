#!/bin/bash
#SBATCH --nodes=1
#SBATCH --job-name=a.out
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --time=1:00:00
#SBATCH --gres=gpu:1


./a.out

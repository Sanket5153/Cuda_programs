#!/bin/bash

#SBATCH --job-name=Sanket_GPU_Test
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH --time=00:15:00
#SBATCH --output=%j.out
#SBATCH --error=%j.err

echo "=========================================="
echo "SLURM JOB INFORMATION"
echo "=========================================="

echo "Job ID       : $SLURM_JOB_ID"
echo "Job Name     : $SLURM_JOB_NAME"
echo "Node         : $SLURM_NODELIST"
echo "Partition    : $SLURM_JOB_PARTITION"
echo "CPUs         : $SLURM_CPUS_ON_NODE"
echo "CUDA Device  : $CUDA_VISIBLE_DEVICES"

echo
echo "=========================================="
echo "HOST INFORMATION"
echo "=========================================="

hostname

echo
echo "=========================================="
echo "GPU INFORMATION"
echo "=========================================="

nvidia-smi

echo
echo "=========================================="
echo "CUDA INFORMATION"
echo "=========================================="

which nvcc
nvcc --version

echo
echo "=========================================="
echo "JOB COMPLETED"
echo "=========================================="

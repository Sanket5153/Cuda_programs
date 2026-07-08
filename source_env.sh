#!/bin/bash

. /home/apps/spack/share/spack/setup-env.sh
spack load cuda/kr6npmd

echo "CUDA loaded into ENV"

nvcc --version

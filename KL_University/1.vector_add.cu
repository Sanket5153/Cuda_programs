#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#define SIZE 1024

// CUDA Kernel
__global__ void vectorAdd(int *A, int *B, int *C)
{
    int i = threadIdx.x;

    C[i] = A[i] + B[i];
}

int main()
{
    int *h_A, *h_B, *h_C;
    int *d_A, *d_B, *d_C;

    int size = SIZE;
    int bytes = size * sizeof(int);

    // =========================================================
    // Step 1: CPU Initialization
    // =========================================================

    h_A = (int *)malloc(bytes);
    h_B = (int *)malloc(bytes);
    h_C = (int *)malloc(bytes);

    // Initialize CPU arrays
    for (int i = 0; i < size; i++)
    {
        h_A[i] = i;
        h_B[i] = size - i;
    }

    // =========================================================
    // Step 2: GPU Initialization
    // =========================================================

    cudaMalloc((void **)&d_A, bytes);
    cudaMalloc((void **)&d_B, bytes);
    cudaMalloc((void **)&d_C, bytes);

    // =========================================================
    // Step 3: Copy Data from CPU to GPU
    // =========================================================

    cudaMemcpy(d_A, h_A, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, bytes, cudaMemcpyHostToDevice);

    // =========================================================
    // Step 4: Launch CUDA Kernel
    // 1 Block and 1024 Threads
    // =========================================================

    vectorAdd<<<1, 1025>>>(d_A, d_B, d_C);

    // Wait for GPU to complete kernel execution
   // cudaDeviceSynchronize();

    // =========================================================
    // Step 5: Copy Result from GPU to CPU
    // =========================================================

    cudaMemcpy(h_C, d_C, bytes, cudaMemcpyDeviceToHost);

    // =========================================================
    // Step 6: Print Results
    // =========================================================

    for (int i = 0; i < 5; i++)
    {
        printf("A[%d] = %d, B[%d] = %d + C[%d] = %d\n",
               i, h_A[i],
               i, h_B[i],
               i, h_C[i]);
    }

    // =========================================================
    // Step 7: Free GPU Memory
    // =========================================================

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    // =========================================================
    // Step 8: Free CPU Memory
    // =========================================================

    free(h_A);
    free(h_B);
    free(h_C);

    return 0;
}

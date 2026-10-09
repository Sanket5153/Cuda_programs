#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>

// =========================================================
// Total vector size
//
// Elements = 1536 * 1024 * 1024
//
// One vector = 6 GiB
//
// A + B + C = 18 GiB GPU Memory
//
// Kaggle GPU ≈ 15 GiB
// Therefore GPU memory allocation will fail
// =========================================================

#define SIZE (1536ULL * 1024 * 1024)

#define BLOCK_SIZE 1024


// =========================================================
// CUDA Kernel
// =========================================================

__global__ void add(int* a, int* b, int* c,
                    unsigned long long N)
{
    unsigned long long index =
        threadIdx.x +
        (unsigned long long)blockIdx.x * blockDim.x;

    if (index < N)
    {
        c[index] = a[index] + b[index];
    }
}


// =========================================================
// Function to populate vector with random integers
// =========================================================

void random_ints(int* x, unsigned long long size)
{
    for (unsigned long long i = 0; i < size; i++)
    {
        x[i] = rand() % 100;
    }
}


// =========================================================
// Main
// =========================================================

int main(void)
{
    int* a;
    int* b;
    int* c;

    int* d_a = NULL;
    int* d_b = NULL;
    int* d_c = NULL;

    cudaError_t err;

    size_t size =
        (size_t)SIZE * sizeof(int);


    // =========================================================
    // Display Memory Information
    // =========================================================

    size_t freeMemory;
    size_t totalMemory;

    cudaMemGetInfo(&freeMemory, &totalMemory);


    printf("\n========================================\n");
    printf("      WITHOUT CHUNKING DEMO\n");
    printf("========================================\n");


    printf("\nNumber of Elements = %llu\n",
           (unsigned long long)SIZE);


    printf("Memory per Vector = %.2f GiB\n",
           (double)size /
           (1024.0 * 1024.0 * 1024.0));


    printf("Memory Required for 3 Vectors = %.2f GiB\n",
           (double)(size * 3) /
           (1024.0 * 1024.0 * 1024.0));


    printf("\nGPU Total Memory = %.2f GiB\n",
           (double)totalMemory /
           (1024.0 * 1024.0 * 1024.0));


    printf("GPU Free Memory = %.2f GiB\n",
           (double)freeMemory /
           (1024.0 * 1024.0 * 1024.0));


    // =========================================================
    // Allocate A on GPU
    // =========================================================

    err = cudaMalloc((void**)&d_a, size);

    printf("\nd_a Allocation : %s\n",
           cudaGetErrorString(err));


    if (err != cudaSuccess)
    {
        printf("\nGPU OUT OF MEMORY\n");
        return 1;
    }


    // =========================================================
    // Allocate B on GPU
    // =========================================================

    err = cudaMalloc((void**)&d_b, size);

    printf("d_b Allocation : %s\n",
           cudaGetErrorString(err));


    if (err != cudaSuccess)
    {
        printf("\nGPU OUT OF MEMORY\n");

        cudaFree(d_a);

        return 1;
    }


    // =========================================================
    // Allocate C on GPU
    // =========================================================

    err = cudaMalloc((void**)&d_c, size);

    printf("d_c Allocation : %s\n",
           cudaGetErrorString(err));


    if (err != cudaSuccess)
    {
        printf("\n========================================\n");
        printf("GPU OUT OF MEMORY\n");
        printf("18 GiB Required but GPU has only ~15 GiB\n");
        printf("========================================\n");

        cudaFree(d_a);
        cudaFree(d_b);

        return 1;
    }


    // =========================================================
    // Host Allocation
    // This part will execute only if GPU allocation succeeds
    // =========================================================

    a = (int*)malloc(size);
    b = (int*)malloc(size);
    c = (int*)malloc(size);


    random_ints(a, SIZE);
    random_ints(b, SIZE);


    // =========================================================
    // Copy Data CPU -> GPU
    // =========================================================

    cudaMemcpy(
        d_a,
        a,
        size,
        cudaMemcpyHostToDevice
    );


    cudaMemcpy(
        d_b,
        b,
        size,
        cudaMemcpyHostToDevice
    );


    // =========================================================
    // Calculate Blocks
    // =========================================================

    unsigned int blocks =
        (SIZE + BLOCK_SIZE - 1) / BLOCK_SIZE;


    // =========================================================
    // Launch Kernel
    // =========================================================

    add<<<blocks, BLOCK_SIZE>>>(
        d_a,
        d_b,
        d_c,
        SIZE
    );


    // =========================================================
    // Copy Result GPU -> CPU
    // =========================================================

    cudaMemcpy(
        c,
        d_c,
        size,
        cudaMemcpyDeviceToHost
    );


    // =========================================================
    // Print Results
    // =========================================================

    for (int i = 0; i < 10; i++)
    {
        printf(
            "Element ID = %d ----> %d + %d = %d\n",
            i,
            a[i],
            b[i],
            c[i]
        );
    }


    // =========================================================
    // Free GPU Memory
    // =========================================================

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);


    // =========================================================
    // Free CPU Memory
    // =========================================================

    free(a);
    free(b);
    free(c);


    return 0;
}

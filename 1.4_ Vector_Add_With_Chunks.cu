#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>


// =========================================================
// Total Vector
//
// One complete vector = 6 GiB
//
// Divide into 8 chunks:
//
// One chunk = 6 / 8
//           = 0.75 GiB
//
// GPU Memory:
//
// d_a = 0.75 GiB
// d_b = 0.75 GiB
// d_c = 0.75 GiB
//
// Total = 2.25 GiB GPU Memory
// =========================================================

#define TOTAL_SIZE (1536ULL * 1024 * 1024)

#define NUM_CHUNKS 8

#define CHUNK_SIZE (TOTAL_SIZE / NUM_CHUNKS)

#define BLOCK_SIZE 1024


// =========================================================
// CUDA Kernel
// =========================================================

__global__ void add(int* a, int* b, int* c,
                    unsigned long long chunkSize)
{
    unsigned long long index =
        threadIdx.x +
        (unsigned long long)blockIdx.x * blockDim.x;


    if (index < chunkSize)
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
    int* d_a;
    int* d_b;
    int* d_c;


    int* chunk_a;
    int* chunk_b;
    int* chunk_c;


    cudaError_t err;


    // =========================================================
    // Calculate Chunk Size
    // =========================================================

    size_t chunkSizeBytes =
        (size_t)CHUNK_SIZE * sizeof(int);


    size_t totalSizeBytes =
        (size_t)TOTAL_SIZE * sizeof(int);


    printf("\n========================================\n");
    printf("        WITH CHUNKING DEMO\n");
    printf("========================================\n");


    printf("\nTotal Elements = %llu\n",
           (unsigned long long)TOTAL_SIZE);


    printf("Total Size per Vector = %.2f GiB\n",
           (double)totalSizeBytes /
           (1024.0 * 1024.0 * 1024.0));


    printf("Number of Chunks = %d\n",
           NUM_CHUNKS);


    printf("Elements per Chunk = %llu\n",
           (unsigned long long)CHUNK_SIZE);


    printf("Memory per Chunk Vector = %.2f GiB\n",
           (double)chunkSizeBytes /
           (1024.0 * 1024.0 * 1024.0));


    printf("GPU Memory Required = %.2f GiB\n",
           (double)(chunkSizeBytes * 3) /
           (1024.0 * 1024.0 * 1024.0));


    // =========================================================
    // Display GPU Memory
    // =========================================================

    size_t freeMemory;
    size_t totalMemory;


    cudaMemGetInfo(
        &freeMemory,
        &totalMemory
    );


    printf("\nGPU Total Memory = %.2f GiB\n",
           (double)totalMemory /
           (1024.0 * 1024.0 * 1024.0));


    printf("GPU Free Memory = %.2f GiB\n",
           (double)freeMemory /
           (1024.0 * 1024.0 * 1024.0));


    // =========================================================
    // Allocate Memory for ONE Chunk on GPU
    // =========================================================

    err = cudaMalloc(
        (void**)&d_a,
        chunkSizeBytes
    );


    printf("\nd_a Allocation : %s\n",
           cudaGetErrorString(err));


    if (err != cudaSuccess)
        return 1;


    err = cudaMalloc(
        (void**)&d_b,
        chunkSizeBytes
    );


    printf("d_b Allocation : %s\n",
           cudaGetErrorString(err));


    if (err != cudaSuccess)
        return 1;


    err = cudaMalloc(
        (void**)&d_c,
        chunkSizeBytes
    );


    printf("d_c Allocation : %s\n",
           cudaGetErrorString(err));


    if (err != cudaSuccess)
        return 1;


    // =========================================================
    // Allocate Memory for ONE Chunk on Host
    // =========================================================

    chunk_a =
        (int*)malloc(chunkSizeBytes);


    chunk_b =
        (int*)malloc(chunkSizeBytes);


    chunk_c =
        (int*)malloc(chunkSizeBytes);


    // =========================================================
    // Calculate Number of Blocks
    // =========================================================

    unsigned int numBlocks =
        (CHUNK_SIZE + BLOCK_SIZE - 1)
        / BLOCK_SIZE;


    printf("\nThreads per Block = %d\n",
           BLOCK_SIZE);


    printf("Blocks per Chunk = %u\n",
           numBlocks);


    // =========================================================
    // Process Complete Vector Chunk by Chunk
    // =========================================================

    for (unsigned long long offset = 0;
         offset < TOTAL_SIZE;
         offset += CHUNK_SIZE)
    {

        // =====================================================
        // Calculate Current Chunk Size
        // =====================================================

        unsigned long long currentChunkSize =
            (TOTAL_SIZE - offset < CHUNK_SIZE)
            ? TOTAL_SIZE - offset
            : CHUNK_SIZE;


        printf("\n========================================\n");

        printf("Processing Chunk %llu of %d\n",
               (offset / CHUNK_SIZE) + 1,
               NUM_CHUNKS);


        printf("Offset = %llu\n",
               offset);


        printf("Starting Element = %llu\n",
               offset);


        printf("Ending Element = %llu\n",
               offset + currentChunkSize - 1);


        printf("========================================\n");


        // =====================================================
        // Generate Random Data for Current Chunk
        // =====================================================

        random_ints(
            chunk_a,
            currentChunkSize
        );


        random_ints(
            chunk_b,
            currentChunkSize
        );


        // =====================================================
        // Copy Chunk A CPU -> GPU
        // =====================================================

        cudaMemcpy(
            d_a,
            chunk_a,
            (size_t)currentChunkSize * sizeof(int),
            cudaMemcpyHostToDevice
        );


        // =====================================================
        // Copy Chunk B CPU -> GPU
        // =====================================================

        cudaMemcpy(
            d_b,
            chunk_b,
            (size_t)currentChunkSize * sizeof(int),
            cudaMemcpyHostToDevice
        );


        // =====================================================
        // Launch Kernel
        // =====================================================

        add<<<numBlocks, BLOCK_SIZE>>>(
            d_a,
            d_b,
            d_c,
            currentChunkSize
        );


        cudaDeviceSynchronize();


        // =====================================================
        // Copy Result GPU -> CPU
        // =====================================================

        cudaMemcpy(
            chunk_c,
            d_c,
            (size_t)currentChunkSize * sizeof(int),
            cudaMemcpyDeviceToHost
        );


        // =====================================================
        // Print First 5 Elements from Current Chunk
        // =====================================================

        for (int i = 0; i < 5; i++)
        {
            printf(
                "Element ID = %llu ----> %d + %d = %d\n",
                offset + i,
                chunk_a[i],
                chunk_b[i],
                chunk_c[i]
            );
        }


        printf("\nChunk %llu Completed Successfully\n",
               (offset / CHUNK_SIZE) + 1);
    }


    // =========================================================
    // Free GPU Memory
    // =========================================================

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);


    // =========================================================
    // Free Host Memory
    // =========================================================

    free(chunk_a);
    free(chunk_b);
    free(chunk_c);


    printf("\n========================================\n");
    printf("ALL 8 CHUNKS COMPLETED SUCCESSFULLY\n");
    printf("========================================\n");


    return 0;
}

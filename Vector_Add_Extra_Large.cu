#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define SIZE 1024*1024*1024


__global__ void add(int* a, int* b, int* c, int N)
{
    int index = threadIdx.x + blockIdx.x * blockDim.x;

    c[index] = a[index] + b[index];
}


// Function to populate a vector with random integers

void random_ints(int* x, int size)
{
    for (int i = 0; i < size; i++)
    {
        x[i] = rand() % 100;
    }
}


int main(void)
{
    int* a, *b, *c;          // host copies of a, b, c
    int* d_a, *d_b, *d_c;    // device copies of a, b, c


    // IMPORTANT:
    // Use size_t because total memory size is 4 GB
    size_t size = (size_t)SIZE * sizeof(int);


    printf("\nHello 00\n");

    printf("Number of Elements = %d\n", SIZE);
    printf("Memory per Vector  = %zu bytes\n", size);


    // Allocate space for device copies of a, b, c

    cudaMalloc((void**)&d_a, size);
    cudaMalloc((void**)&d_b, size);
    cudaMalloc((void**)&d_c, size);

    printf("\nHello 01\n");


    // Allocate space for host copies of a, b, c
    // and setup input values

    a = (int*)malloc(size);
    random_ints(a, SIZE);

    b = (int*)malloc(size);
    random_ints(b, SIZE);

    c = (int*)malloc(size);

    printf("\nHello 02\n");


    // Copy inputs to device

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);

    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);


    // Launch Kernel

    add<<<1024 * 1024, 1024>>>(d_a, d_b, d_c, SIZE);


    // Copy result back to host

    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);


    // Print Results

    for (int i = 0; i < 100; i++)
    {
        printf("Element ID = %d  ---->  %d + %d = %d\n",
               i, a[i], b[i], c[i]);
    }


    // Cleanup

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    free(a);
    free(b);
    free(c);

    return 0;
}

#include <stdio.h>
#include <cuda_runtime.h>

// TODO: Implement a kernel that prints the structural block index and thread index of each executing thread.
__global__ void multiThreadHello() {
    // Hint: Use built-in variables blockIdx.x and threadIdx.x
    // Your code here:
}

int main() {
    printf("Host: Launching parallel threads...\n");

    // TODO: Launch the kernel with 2 blocks, each containing 4 threads (8 total threads)
    // Your code here:


    cudaDeviceSynchronize();
    return 0;
}

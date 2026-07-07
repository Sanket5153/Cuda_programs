#include <stdio.h>
#include <cuda_runtime.h>

__global__ void multiThreadHello() {
    printf("Hello from Block %d, Thread %d\n", blockIdx.x, threadIdx.x);
}

int main() {
    printf("Host: Launching parallel threads...\n");

    // Launch configuration: 2 blocks, 4 threads per block
    multiThreadHello<<<2, 4>>>();
    
    cudaDeviceSynchronize();
    return 0;
}

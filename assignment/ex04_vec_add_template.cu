#include <stdio.h>
#include <cuda_runtime.h>

#define N 5

// TODO: Complete the vector addition kernel
__global__ void vecAdd(float *A, float *B, float *C) {
    // Calculate global thread ID sequence index
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    
    // TODO: Write the boundary check and addition operation
}

int main() {
    float h_A[N] = {1.0, 2.0, 3.0, 4.0, 5.0};
    float h_B[N] = {10.0, 20.0, 30.0, 40.0, 50.0};
    float h_C[N];

    float *d_A, *d_B, *d_C;
    size_t size = N * sizeof(float);

    // TODO: Allocate explicit global memory space on the GPU (d_A, d_B, d_C) using cudaMalloc
    // Your code here:


    // TODO: Copy input vectors h_A and h_B from host memory over to the allocated device locations
    // Your code here:


    // TODO: Launch vecAdd kernel dynamically to match 'N' element processing parameters
    // Your code here:


    // TODO: Pull down the completed results out of d_C back onto host memory h_C
    // Your code here:


    // Verification loop
    for(int i = 0; i < N; i++) {
        printf("C[%d] = %f\n", i, h_C[i]);
    }

    // TODO: Free device memory targets to avoid leakage errors using cudaFree
    // Your code here:

    return 0;
}

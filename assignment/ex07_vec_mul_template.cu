#include <stdio.h>
#include <cuda_runtime.h>

#define N 4

// TODO: Complete the kernel to perform element-wise multiplication: C[i] = A[i] * B[i]
__global__ void vecMultiply(float *A, float *B, float *C, int n) {
    // 1. Calculate thread ID
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    
    // 2. TODO: Add boundary check and multiply A and B into C
    // Your code here:

}

int main() {
    float h_A[N] = {2.0, 4.0, 6.0, 8.0};
    float h_B[N] = {0.5, 0.5, 2.0, 2.0};
    float h_C[N];

    float *d_A, *d_B, *d_C;
    size_t size = N * sizeof(float);

    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_C, size);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    // TODO: Launch the kernel
    // Your code here:


    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

    // Verification (Expected: 1, 2, 12, 16)
    for(int i = 0; i < N; i++) {
        printf("C[%d] = %f\n", i, h_C[i]);
    }

    cudaFree(d_A); cudaFree(d_B); cudaFree(d_C);
    return 0;
}

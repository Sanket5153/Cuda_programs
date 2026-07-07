#include <stdio.h>
#include <cuda_runtime.h>

#define N 6

// TODO: Complete the kernel to multiply each element of array A by the scalar factor
__global__ void vecScale(float *A, float factor, int n) {
    // 1. Calculate the global thread ID
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    
    // 2. TODO: Add a boundary check and perform the multiplication in-place
    // Your code here:

}

int main() {
    float h_A[N] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0};
    float factor = 5.0f;
    float *d_A;
    size_t size = N * sizeof(float);

    cudaMalloc((void**)&d_A, size);
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);

    // TODO: Launch the kernel with 1 block and N threads
    // Your code here:


    cudaMemcpy(h_A, d_A, size, cudaMemcpyDeviceToHost);

    // Verification (Expected: 5, 10, 15, 20, 25, 30)
    for(int i = 0; i < N; i++) {
        printf("A[%d] = %f\n", i, h_A[i]);
    }

    cudaFree(d_A);
    return 0;
}

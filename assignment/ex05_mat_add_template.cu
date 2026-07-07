#include <stdio.h>
#include <cuda_runtime.h>

#define ROWS 2
#define COLS 3

// TODO: Complete the 2D matrix addition kernel
__global__ void matAdd(float *A, float *B, float *C, int rows, int cols) {
    // 1. Calculate the global 2D column index (X dimension) and row index (Y dimension)
    // Hint: Use blockIdx, blockDim, and threadIdx for both x and y
    int col = // Your code here
    int row = // Your code here
    
    // 2. Perform boundary checks and calculate the 1D flattened index
    if (row < rows && col < cols) {
        int idx = row * cols + col;
        // TODO: Perform element addition
        
    }
}

int main() {
    float h_A[ROWS*COLS] = {1, 2, 3,  4, 5, 6};
    float h_B[ROWS*COLS] = {10, 20, 30,  40, 50, 60};
    float h_C[ROWS*COLS];
    
    float *d_A, *d_B, *d_C;
    size_t size = ROWS * COLS * sizeof(float);
    
    cudaMalloc(&d_A, size); cudaMalloc(&d_B, size); cudaMalloc(&d_C, size);
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
    
    // TODO: Define a 2D block structure (e.g., 2x2 threads) using dim3
    dim3 threadsPerBlock(2, 2);
    
    // TODO: Calculate the grid size dynamically based on matrix dimensions
    dim3 numBlocks( // Your code here
                    // Your code here );
                   
    // Launch Kernel
    matAdd<<<numBlocks, threadsPerBlock>>>(d_A, d_B, d_C, ROWS, COLS);
    
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);
    for(int i = 0; i < ROWS * COLS; i++) printf("MatAdd[%d] = %f\n", i, h_C[i]);
    
    cudaFree(d_A); cudaFree(d_B); cudaFree(d_C);
    return 0;
}

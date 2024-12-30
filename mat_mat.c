#include <stdio.h>
#include <stdlib.h>

#define N 2000 // Matrix size (NxN)

void matrix_multiply(float *A, float *B, float *C, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            C[i * n + j] = 0.0f; // Initialize result
            for (int k = 0; k < n; k++) {
                C[i * n + j] += A[i * n + k] * B[k * n + j];
            }
        }
    }
}

int main() {
    int size = N * N;
    float *A, *B, *C;

    // Allocate memory
    A = (float *)malloc(size * sizeof(float));
    B = (float *)malloc(size * sizeof(float));
    C = (float *)malloc(size * sizeof(float));

    // Initialize matrices
    for (int i = 0; i < size; i++) {
        A[i] = 1; // Example values
        B[i] = 2;
    }

    // Perform matrix multiplication
    matrix_multiply(A, B, C, N);

    // Print one result element (e.g., C[0][0])
    printf("C[0][0] = %f\n", C[0]);

    // Free memory
    free(A);
    free(B);
    free(C);

    return 0;
}

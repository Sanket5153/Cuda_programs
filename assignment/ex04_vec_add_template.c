#include <stdio.h>

#define N 5

// CPU function for vector addition
void vecAdd(float *A, float *B, float *C)
{
    for (int i = 0; i < N; i++)
    {
        C[i] = A[i] + B[i];
    }
}

int main()
{
    float h_A[N] = {1.0, 2.0, 3.0, 4.0, 5.0};
    float h_B[N] = {10.0, 20.0, 30.0, 40.0, 50.0};
    float h_C[N];

    // Perform vector addition
    vecAdd(h_A, h_B, h_C);

    // Print the result
    for (int i = 0; i < N; i++)
    {
        printf("C[%d] = %.2f\n", i, h_C[i]);
    }

    return 0;
}

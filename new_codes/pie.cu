#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<sys/time.h>

#define N 99999999

__global__ void calc_area(double dx, double *aread)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    double x, y;
    if (i < N)
    {
        x = i * dx;
        y = sqrt(1 - x * x);
        aread[i] = y * dx;
    }
}

int main()
{
    int i;
    double total_area, pi, *area, *aread;
    double dx;
    double exe_time;
    struct timeval stop_time, start_time;

    dx = 1.0 / N;
    total_area = 0.0;

    gettimeofday(&start_time, NULL);

    int num_threads_per_block = 256;
    int num_blocks = (N + num_threads_per_block - 1) / num_threads_per_block;

    area = (double *)malloc(N * sizeof(double));
    if (area == NULL)
    {
        printf("Error allocating memory for area on host\n");
        return -1;
    }

    cudaError_t err = cudaMalloc(&aread, N * sizeof(double));
    if (err != cudaSuccess)
    {
        printf("Error allocating memory on device: %s\n", cudaGetErrorString(err));
        free(area);
        return -1;
    }

    calc_area<<<num_blocks, num_threads_per_block>>>(dx, aread);

    err = cudaGetLastError();
    if (err != cudaSuccess)
    {
        printf("Error in kernel execution: %s\n", cudaGetErrorString(err));
        cudaFree(aread);
        free(area);
        return -1;
    }

    err = cudaMemcpy(area, aread, N * sizeof(double), cudaMemcpyDeviceToHost);
    if (err != cudaSuccess)
    {
        printf("Error copying memory from device to host: %s\n", cudaGetErrorString(err));
        cudaFree(aread);
        free(area);
        return -1;
    }

    for (i = 0; i < N; i++)
    {
        total_area += area[i];
    }

    gettimeofday(&stop_time, NULL);
    exe_time = (stop_time.tv_sec + (stop_time.tv_usec / 1000000.0)) - (start_time.tv_sec + (start_time.tv_usec / 1000000.0));

    pi = 4.0 * total_area;
    printf("\n Value of pi is = %.16lf\n Execution time is = %lf seconds\n", pi, exe_time);

    free(area);
    cudaFree(aread);

    return 0;
}


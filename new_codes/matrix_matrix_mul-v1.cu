
#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>

#define VECTORSIZE      20000
#define NUM_THDS        256

__global__ void matmul(int *A, int *B, int *C)
{
        int myid = blockIdx.x*blockDim.x+threadIdx.x;
        int i = myid / VECTORSIZE;
        int j = myid % VECTORSIZE;
        int k;
        int sum = 0;
        if(myid < (VECTORSIZE*VECTORSIZE))
        {
                for(k=0;k<VECTORSIZE;k++)
                {
                        sum = sum + A[i*VECTORSIZE+k]*B[k*VECTORSIZE+j];
                }
                C[i*VECTORSIZE+j] =  sum;
        }
}

int main(int argc, char **argv)
{
        int i, j;
        int *A, *B, *C, *Ad, *Bd, *Cd;
        double exe_time;
        struct timeval stop_time, start_time;

        //Allocate and initialize the arrays
        A = (int *)malloc(VECTORSIZE*VECTORSIZE*sizeof(int));
        B = (int *)malloc(VECTORSIZE*VECTORSIZE*sizeof(int));
        C = (int *)malloc(VECTORSIZE*VECTORSIZE*sizeof(int));

        //Initialize data to some value
        for(i=0;i<VECTORSIZE;i++)
        {
                for(j=0;j<VECTORSIZE;j++)
                {
                        A[i*VECTORSIZE+j] = 1;
                        B[i*VECTORSIZE+j] = 2;
                        C[i*VECTORSIZE+j] = 0;
                }
        }

        //print the data
        /*printf("\nInitial data: \n");
        printf("\n A matrix:\n");
        for(i=0;i<VECTORSIZE;i++)
        {
                for(j=0;j<VECTORSIZE;j++)
                {
                        printf("\t%d ", A[i*VECTORSIZE+j]);
                }
                printf("\n");
        }
        printf("\n B matrix:\n");
        for(i=0;i<VECTORSIZE;i++)
        {
                for(j=0;j<VECTORSIZE;j++)
                {
                        printf("\t%d ", B[i*VECTORSIZE+j]);
                }
                printf("\n");
        }*/

        gettimeofday(&start_time, NULL);

        int total_threads = VECTORSIZE*VECTORSIZE;
        int num_thds_per_block = NUM_THDS;
        int num_blocks = total_threads / num_thds_per_block + 1;

        cudaMalloc(&Ad, VECTORSIZE*VECTORSIZE*sizeof(int));
        cudaMemcpy(Ad, A, VECTORSIZE*VECTORSIZE*sizeof(int), cudaMemcpyHostToDevice);

        cudaMalloc(&Bd, VECTORSIZE*VECTORSIZE*sizeof(int));
        cudaMemcpy(Bd, B, VECTORSIZE*VECTORSIZE*sizeof(int), cudaMemcpyHostToDevice);

        cudaMalloc(&Cd, VECTORSIZE*VECTORSIZE*sizeof(int));

        matmul<<<num_blocks,num_thds_per_block>>>(Ad,Bd,Cd);

        cudaMemcpy(C, Cd, VECTORSIZE*VECTORSIZE*sizeof(int), cudaMemcpyDeviceToHost);

        /*for(i=0;i<VECTORSIZE;i++)
        {
                for(j=0;j<VECTORSIZE;j++)
                {
                        sum = 0;
                        for(k=0;k<VECTORSIZE;k++)
                        {
                                sum = sum + A[i*VECTORSIZE+k]*B[k*VECTORSIZE+j];
                        }
                        C[i*VECTORSIZE+j] =  sum;
                }
        }*/

        gettimeofday(&stop_time, NULL);
        exe_time = (stop_time.tv_sec+(stop_time.tv_usec/1000000.0)) - (start_time.tv_sec+(start_time.tv_usec/1000000.0));

        //print the data
        /*printf("\n C matrix:\n");
        for(i=0;i<VECTORSIZE;i++)
        {
                for(j=0;j<VECTORSIZE;j++)
                {
                        printf("\t%d ", C[i*VECTORSIZE+j]);
                }
                printf("\n");
        }*/

        printf("\nC[5*VECTORSIZE+5] = %d ", C[5*VECTORSIZE+5]);

        printf("\n Execution time is = %lf seconds\n", exe_time);

        printf("\nProgram exit!\n");

        //Free arrays
        free(A);
        free(B);
        free(C);
        cudaFree(Ad);
        cudaFree(Bd);
        cudaFree(Cd);
}

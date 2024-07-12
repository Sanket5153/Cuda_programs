#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>

#define VECTORSIZE 5000

__global__ void matrix_vec_mul(int *A, int *B, int *C)
{
        int i = blockIdx.x*blockDim.x + threadIdx.x;
        int j;
        int sum = 0;
        if(i<VECTORSIZE)
        {
                for(j=0;j<VECTORSIZE;j++)
                {
                        sum = sum + A[i*VECTORSIZE+j]*B[i];
                }
                C[i] =  sum;
        }
}


int main(int argc, char **argv)
{
        int myid, size;
        int i, j, sum;
        int *A, *B, *C, *Ad, *Bd, *Cd;
        double exe_time;
        struct timeval stop_time, start_time;

        //Allocate and initialize the arrays
        A = (int *)malloc(VECTORSIZE*VECTORSIZE*sizeof(int));
        B = (int *)malloc(VECTORSIZE*sizeof(int));
        C = (int *)malloc(VECTORSIZE*sizeof(int));

        //Initialize data to some value
        for(i=0;i<VECTORSIZE;i++)
        {
                for(j=0;j<VECTORSIZE;j++)
                {
                        A[i*VECTORSIZE+j] = 1;
                }
                B[i] = 1;
        }

        //print the data
        /*printf("\nInitial data: \n");
        for(i=0;i<VECTORSIZE;i++)
        {
                for(j=0;j<VECTORSIZE;j++)
                {
                        printf("\t%d ", A[i*VECTORSIZE+j]);
                }
                printf("\n");
        }
        printf("\n");
        for(i=0;i<VECTORSIZE;i++)
        {
                printf("\t%d", B[i]);
        }*/

        gettimeofday(&start_time, NULL);

        /*for(i=0;i<VECTORSIZE;i++)
        {
                sum = 0;
                for(j=0;j<VECTORSIZE;j++)
                {
                        sum = sum + A[i*VECTORSIZE+j]*B[i];
                }
                C[i] =  sum;
        }*/

        cudaMalloc(&Ad,VECTORSIZE*VECTORSIZE*sizeof(int));
        cudaMalloc(&Bd,VECTORSIZE*sizeof(int));
        cudaMalloc(&Cd,VECTORSIZE*sizeof(int));

        cudaMemcpy(Ad,A,VECTORSIZE*VECTORSIZE*sizeof(int),cudaMemcpyHostToDevice);
        cudaMemcpy(Bd,B,VECTORSIZE*sizeof(int),cudaMemcpyHostToDevice);

        int Total_num_Threads = VECTORSIZE;
        int num_threads_per_block = 5;
        int numblocks = Total_num_Threads/num_threads_per_block + 1;

        matrix_vec_mul<<<numblocks,num_threads_per_block>>>(Ad,Bd,Cd);

        cudaMemcpy(C,Cd,VECTORSIZE*sizeof(int),cudaMemcpyDeviceToHost);

        gettimeofday(&stop_time, NULL);
        exe_time = (stop_time.tv_sec+(stop_time.tv_usec/1000000.0)) - (start_time.tv_sec+(start_time.tv_usec/1000000.0));

        //print the data
        printf("\n Matrix-Vector Multiplication output: \n");
        for(i=0;i<VECTORSIZE;i++)
        {
                printf("\t%d", C[i]);
        }
        printf("\n Execution time is = %lf seconds\n", exe_time);

        printf("\nProgram exit!\n");


        cudaFree(Ad);
        cudaFree(Bd);
        cudaFree(Cd);

        //Free arrays
        free(A);
        free(B);
        free(C);
}

%%writefile square_test.cu

#include<stdio.h>
#include<stdlib.h>

__device__ int calc_square(int val)
{
	int val_square;
	val_square = val*val;
	return val_square;
}

__global__ void calc(int *aa, int *a , int problem_size)
{
    int i=0;
    if ( i < problem_size)
    {
        int i = blockIdx.x * blockDim.x + threadIdx.x;
        aa[i] = calc_square(a[i]);
    } 
}

int main()
{
	int size = 400 * sizeof(int);
	int a[400],aa[400],*ad,*aad;
	int i=0;
    int blocks=10;
    int threads=40;

    //GPU Memory Allocation
    cudaMalloc(&ad,size);
    cudaMalloc(&aad,size);
	
	//Initialize the vectors
	for(i=0; i<400; i++ )
	{
		a[i] = i;
	}



    //cudaMemcpy(dst, src , size , operation); 
    // Data Transfer from CPU to GPU
    cudaMemcpy(ad,a,size,cudaMemcpyHostToDevice);

    calc<<<blocks,threads>>>(aad,ad,400);

    cudaMemcpy(aa,aad,size,cudaMemcpyDeviceToHost);

	// print the output
	for(i=0; i<5 ; i++ )
	{
		printf("\t%d",aa[i]);
	}	
}

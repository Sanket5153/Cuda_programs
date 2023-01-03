
#include<stdio.h>
#include<stdlib.h>

__device__ int calc_square(int val)
{
        int val_square;
        val_square = val*val;
        return val_square;
}

__global__ void calc_square(int* da,int* daa)
{
        int i = blockIdx.x*blockDim.x + threadIdx.x;
        daa[i] = calc_square(da[i]);
}


int main()
{
        int size = 400 * sizeof(int);
        int a[400], aa[400],*da, *daa;
        int i=0;

        for(i=0; i<400; i++ )
        {
                a[i] = i;

        }

        cudaMalloc(&da, size);
        cudaMemcpy(da, a, size, cudaMemcpyHostToDevice);


        cudaMalloc(&daa, size);

        dim3   DimGrid(1, 1);
        dim3   DimBlock(400, 1);


        calc_square<<< DimGrid,DimBlock >>>(da,daa);

        cudaMemcpy(aa, daa, size, cudaMemcpyDeviceToHost);

        for(i=0; i<400; i++ )
        {
                printf("\t%d",aa[i]);
        }

        cudaFree(da);
        cudaFree(daa);

}

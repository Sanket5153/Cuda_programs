
#include<stdio.h>
#include<stdlib.h>

void my_cudasafe( cudaError_t error, char* message)
{
        if(error!=cudaSuccess)
        {
                fprintf(stderr,"ERROR: %s : %s\n",message,cudaGetErrorString(error));
                exit(-1);
        }
}

__global__ void arradd(int* md, int* nd, int* pd, int size)
{
        int myid = blockIdx.x*blockDim.x + threadIdx.x;

        pd[myid] = md[myid] + nd[myid];
}


int main()
{
        int size = 2000 * sizeof(int);
        int m[2000], n[2000], p[2000],*md, *nd,*pd;
        int i=0;


        for(i=0; i<2000; i++ )
        {
                m[i] = i;
                n[i] = i;
                p[i] = 0;
        }

        my_cudasafe(cudaMalloc(&md, size),"Cuda malloc : md");
        my_cudasafe(cudaMemcpy(md, m, size, cudaMemcpyHostToDevice),"Cuda memcopy H2D: md");

        my_cudasafe(cudaMalloc(&nd, size),"Cuda malloc : nd");
        my_cudasafe(cudaMemcpy(nd, n, size, cudaMemcpyHostToDevice),"Cuda memcopy H2D: nd");

        my_cudasafe(cudaMalloc(&pd, size),"Cuda malloc : pd");

        dim3   DimGrid(100, 1);
        dim3   DimBlock(200, 1);


        arradd<<< DimGrid,DimBlock >>>(md,nd,pd,size);
        my_cudasafe(cudaGetLastError(), "arradd kernel");

        my_cudasafe(cudaMemcpy(p, pd, size, cudaMemcpyDeviceToHost),"My error: pd error ala");
//      my_cudasafe(cudaMemcpy(p, pd, size, cudaMemcpyDeviceToHost),"Cuda memcopy D2H: pd");
        my_cudasafe(cudaFree(md),"cudaFree md");
        my_cudasafe(cudaFree(nd),"cudaFree nd");
        my_cudasafe(cudaFree(pd),"cudaFree pd");

        for(i=0; i<2000; i++ )
        {
                printf("\t%d",p[i]);
        }
}


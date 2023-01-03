#include<stdio.h>
#include<stdlib.h>

__global__ void arradd(int* md, int* nd, int* pd)
{
        int myid = blockIdx.x*blockDim.x + threadIdx.x;

        pd[myid] = md[myid] + nd[myid];
}


int main()
{
        int size = 200 * sizeof(int);
        int m[200], n[200], p[200],*md, *nd,*pd;
        int i=0;

        for(i=0; i<200; i++ )
        {
                m[i] = i;
                n[i] = i;
                p[i] = 0;
        }

        cudaMalloc(&md, size);
        cudaMemcpy(md, m, size, cudaMemcpyHostToDevice);

        cudaMalloc(&nd, size);
        cudaMemcpy(nd, n, size, cudaMemcpyHostToDevice);

        cudaMalloc(&pd, size);

        dim3   DimGrid(1, 1);
        dim3   DimBlock(200, 1);


        arradd<<< DimGrid,DimBlock >>>(md,nd,pd);

        cudaMemcpy(p, pd, size, cudaMemcpyDeviceToHost);

        for(i=0; i<200; i++ )
        {
                printf("\t%d",p[i]);
        }

        cudaFree(md);
        cudaFree(nd);
        cudaFree(pd);
}

#include<stdio.h>
#include<stdlib.h>

__constant__ int md[200], nd[200];

__global__ void arradd(int* pd, int size)
{
        int myid = threadIdx.x;

        pd[myid] = md[myid] + nd[myid];
}

int main()
{
        int size = 200 * sizeof(int);
        int m[200], n[200], p[200],*pd;
        int i=0;


        for(i=0; i<200; i++ )
        {
                m[i] = i;
                n[i] = i;
                p[i] = 0;
        }

        cudaMemcpyToSymbol(md, m, size);
        cudaMemcpyToSymbol(nd, n, size);

        cudaMalloc(&pd, size);

        dim3   DimGrid(1, 1);
        dim3   DimBlock(200, 1);


        arradd<<< DimGrid,DimBlock >>>(pd,size);

        cudaMemcpy(p, pd, size, cudaMemcpyDeviceToHost);

        cudaFree(pd);

        for(i=0; i<200; i++ )
        {
                printf("\t%d",p[i]);
        }

}

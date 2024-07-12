#include<stdio.h>
#include<stdlib.h>

__global__ void arradd(int* md, int* nd, int* pd)
{
        int myid = threadIdx.y * blockDim.x + threadIdx.x;

        pd[myid] = md[myid] + nd[myid];
}


int main()
{
        int size = 20 *20* sizeof(int);
        int m[20][20], n[20][20], p[20][20],*md, *nd,*pd;
        int i=0,j=0;


        for(i=0; i<20; i++ )
        {
                for(j=0; j<20; j++ )
                {
                        m[i][j] = i;
                        n[i][j] = i;
                        p[i][j] = 0;
                }
        }

        cudaMalloc(&md, size);
        cudaMemcpy(md, m, size, cudaMemcpyHostToDevice);

        cudaMalloc(&nd, size);
        cudaMemcpy(nd, n, size, cudaMemcpyHostToDevice);

        cudaMalloc(&pd, size);

        dim3   DimGrid(1, 1);
        dim3   DimBlock(20, 20);


        arradd<<< DimGrid,DimBlock >>>(md,nd,pd);

        cudaMemcpy(p, pd, size, cudaMemcpyDeviceToHost);
        cudaFree(md);
        cudaFree(nd);
        cudaFree (pd);

        for(i=0; i<20; i++ )
        {
                for(j=0; j<20; j++ )
                {
                        printf("\t%d",p[i][j]);
                }
                printf("\n");
        }



}

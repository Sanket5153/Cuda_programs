
#include<stdio.h>
#include<stdlib.h>

__global__ void arradd(double* md, double* nd, double* pd, double  alpha)
{
        int myid = blockIdx.x*blockDim.x + threadIdx.x;

        pd[myid] = md[myid] + (alpha*nd[myid]);
}


int main()
{
        double size = 400 * sizeof(double);
        double m[400], n[400], p[400],*md, *nd,*pd;
        double alpha = 0.001;
        int i=0;

        for(i=0; i<400; i++ )
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
        //cudaMalloc(&alpha, size);

        dim3   DimGrid(1, 1);
        dim3   DimBlock(400, 1);


        arradd<<< DimGrid,DimBlock >>>(md,nd,pd,alpha);

        cudaMemcpy(p, pd, size, cudaMemcpyDeviceToHost);

        for(i=0; i<400; i++ )
        {
                printf("\n%lf",p[i]);
        }

        cudaFree(md);
        cudaFree(nd);
        cudaFree(pd);
}

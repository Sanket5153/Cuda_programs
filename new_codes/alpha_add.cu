

#include<stdio.h>
#include<stdlib.h>

__global__ void calc(double *c, double *a, double *b, double alpha)
{
        int i = blockIdx.x*blockDim.x + threadIdx.x;
        c[i] = a[i] + alpha*b[i];
}

int main()
{
        int size = 40 * sizeof(double);
        double a[40], b[40], c[40], *ad, *bd, *cd, alpha;
        int i=0;

        alpha = 10;

        for(i=0; i<40; i++ )
        {
                a[i] = i;
                b[i] = i;
                c[i] = 0;
        }

        cudaMalloc(&ad, size);
        cudaMalloc(&bd, size);
        cudaMalloc(&cd, size);

        cudaMemcpy(ad,a,size,cudaMemcpyHostToDevice);
        cudaMemcpy(bd,b,size,cudaMemcpyHostToDevice);

        //for(i=0; i<400; i++ )
        //{
        //      c[i] = a[i] + alpha*b[i];
        //}

        dim3 blocks(10,1);
        dim3 threads(4,1);

        calc<<<blocks,threads>>>(cd,ad,bd,alpha);

        cudaMemcpy(c,cd,size,cudaMemcpyDeviceToHost);

        for(i=0; i<40; i++ )
        {
                printf("\t%lf",c[i]);
        }
}



#include<stdio.h>
#include<stdlib.h>

int calc_square(int val)
{
        int val_square;
        val_square = val*val;
        return val_square;
}

int main()
{
        int size = 400 * sizeof(int);
        int a[400], aa[400];
        int i=0;



        for(i=0; i<400; i++ )
        {
                a[i] = i;
        }


        for(i=0; i<400; i++ )
        {
                aa[i] = calc_square(a[i]);
        }


        for(i=0; i<400; i++ )
        {
                printf("\t%d",aa[i]);
        }
}

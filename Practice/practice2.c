#include<stdio.h>
#include<stdlib.h>

int main()
{
	int size = 400 * sizeof(int);
	double a[400], b[400], c[400], alpha;
	int i=0;
	
	alpha = 0.001;

	for(i=0; i<400; i++ )
	{
		a[i] = i;
		b[i] = i;
		c[i] = 0;
	}

	for(i=0; i<400; i++ )
	{
		c[i] = a[i] + alpha*b[i];		
	}

	for(i=0; i<400; i++ )
	{
		printf("\t%lf",c[i]);
	}	
}





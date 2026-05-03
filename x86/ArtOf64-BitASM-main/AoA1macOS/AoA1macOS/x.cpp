#include <stdio.h>
static long long int i=5;
static long long int *j=&i;
int main()
{
	printf( "%p\n", j );
}
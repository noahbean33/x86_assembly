#include <stdio.h>
#include <errno.h>


struct x_t
{
	char b[128];
};

int func( int i0, int i1, int i2, int i3, int i4, int i5, int i6, int i7, char c1, char c2, short s1, int i8 )
{
	return 0;
}
int main( int argc, char **argv)
{
	struct x_t x;
	int i;
	i=func( 0,1,2,3,4,5,6,7,8,9,10,11 );
	printf( "errno=%d\n", errno );
	switch( i )
	{
		case 0:
			printf( "0" );
			break;
			
		case 1:
			printf( "1" );
			break;
			
		case 2:
			printf( "2" );
			break;
			
		case 3:
			printf( "3" );
			break;
			
		case 4:
			printf( "4" );
			break;
			
		case 5:
			printf( "5" );
			break;
			
		case 6:
			printf( "6" );
			break;
			
		case 7:
			printf( "7" );
			break;
			
		case 8:
			printf( "8" );
			break;
			
		case 9:
			printf( "9" );
			break;
			
		default:
			printf( "default" );
			break;
		}
			
		
	
}

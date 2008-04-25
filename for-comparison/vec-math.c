#include <stdlib.h>

typedef double float_type;
typedef float_type* vector_type;

vector_type
vs( float_type _aa, vector_type _vv )
{
    vector_type dd = (vector_type)malloc( 4 * sizeof(float_type) );
    int ii;
    for ( ii=0; ii < 4; ++ii ) {
	dd[ ii ] = _vv[ ii ] * _aa;
    }
}

int
main( void )
{
    float_type aa = (float_type)3;
    vector_type vv = (vector_type)malloc( 4 * sizeof(float_type) );
    unsigned int ii;

    vv[0] = (float_type)0;
    vv[1] = (float_type)1;
    vv[2] = (float_type)3;
    vv[3] = (float_type)5;


    for ( ii=0; ii < 10000000; ++ii ) {
	vs( aa, vv );
    }

    return 0;
}

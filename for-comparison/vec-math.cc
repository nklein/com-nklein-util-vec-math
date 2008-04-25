#include <vector>

typedef double float_type;
typedef std::vector< float_type > vector_type;

void
vs( float_type _aa, vector_type& _vv, vector_type& _ret )
{
    unsigned int ii;
    for ( ii=0; ii < _vv.size(); ++ii ) {
	_ret[ ii ] = _vv[ ii ] * _aa;
    }
}

int
main( void )
{
    float_type aa = (float_type)3;
    vector_type vv(4);
    unsigned int ii;

    vv[0] = (float_type)0;
    vv[1] = (float_type)1;
    vv[2] = (float_type)3;
    vv[3] = (float_type)5;


    for ( ii=0; ii < 10000000; ++ii ) {
	vector_type dd( vv.size() );
	vs( aa, vv, dd );
    }

    return 0;
}

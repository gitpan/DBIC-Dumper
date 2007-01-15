#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'DBIC::Dumper' );
}

diag( "Testing DBIC::Dumper $DBIC::Dumper::VERSION, Perl $], $^X" );

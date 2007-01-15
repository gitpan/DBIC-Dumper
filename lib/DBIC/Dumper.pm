package DBIC::Dumper;

use warnings;
use strict;

=head1 NAME

DBIC::Dumper - The great new DBIC::Dumper!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

DBIC::Dumper exports database data to yaml,xml or json.

Dumping data with DBIC::Dumper::YAML

    package MyDB::Schema;
    use base qw/DBIx::Class::Schema::Loader/;
    __PACKAGE__->loader_options(relationships => 1, debug => 0);

    my $db = MyDB::Schema->connect('SQLite:./somedb.db');

    if(!defined $db) {
      print "Can't connect to database!\n";
      exit(0);
    }

    use DBIC::Dumper::YAML;

    my $dumper = DBIC::Dumper::YAML->new();
    
    # make sure to have the fixtures directory present
    $dumper->dump_all($db,'fixtures');
    
    # or you can export an individual DBIx::Class instance
    
    $dumper->dump($db->resultset('SomeDB::Articles')->first());
    
Loading Data with DBIC::Dumper::YAML

    package MyDB::Schema;
    use base qw/DBIx::Class::Schema::Loader/;
    __PACKAGE__->loader_options(relationships => 1, debug => 0);

    my $db = MyDB::Schema->connect('SQLite:./somedb.db');

    if(!defined $db) {
      print "Can't connect to database!\n";
      exit(0);
    }

    use DBIC::Dumper::YAML;

    my $dumper = DBIC::Dumper::YAML->new();

    # make sure fixtures directory is present.
    $dumper->load($db,'fixtures');


=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 new

=cut

sub new {
    my $class = shift;
    my $self  = {};
    bless( $self, $class );
    return $self;
}

=head2 process_table_columns

=cut

sub process_table_columns {
    my $self = shift;
    my $db   = shift;
    
    my @table = ();
    while( my ($key,$val) = each(%{$db->{class_mappings}}) ) {
        push @table, $val;
    }
    
    return @table;
}

=head2 build_hash

=cut
sub build_hash {
    my $self = shift;
    my @rs   = @_;

    my $hash;
    
    eval {
        my ($entry) = @rs;
        $hash->{name}                  = ucfirst( $entry->result_source->from );
        $hash->{statistics}->{rows}    = scalar(@rs);
        $hash->{statistics}->{columns} = scalar( $entry->result_source->columns );

        foreach my $entry (@rs) {
            foreach my $name ( $entry->result_source->columns ) {
                $hash->{data}->{ $entry->id }->{$name} = $entry->$name();
            }
        }
    };
    
    if ($@) {
      # some error or table is empty
      return undef;
    } 
    else {
     return $hash;   
    }
}

=head2 dump

=cut
sub dump {
    my $self = shift;
    return $self->build_hash(@_);
}

=head1 AUTHOR

Victor Igumnov, C<< <victori at lamer0.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-dbic-dumper at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DBIC-Dumper>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DBIC::Dumper

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DBIC-Dumper>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DBIC-Dumper>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DBIC-Dumper>

=item * Search CPAN

L<http://search.cpan.org/dist/DBIC-Dumper>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Victor Igumnov, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of DBIC::Dumper

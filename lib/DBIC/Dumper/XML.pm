package DBIC::Dumper::XML;
use base qw/DBIC::Dumper/;
use XML::Simple;

=head2 read_file

=cut
sub read_file {
    my $self = shift;
    my $file = shift;

    open( DAT, $file );
    my @lines;
    while ( my $line = <DAT> ) {
        push @lines, $line;
    }
    close(DAT);

    return join( '', @lines );
}

=head2 load

=cut
sub load {
    my ( $self, $db, $indir ) = @_;

    use Path::Class qw(dir);
    my $dir = dir($indir);
    while ( my $file = $dir->next ) {
        if ( $file =~ /xml$/ ) {
            my $fixture = XMLin( $self->read_file($file) );
            while ( my ( $key, $val ) = each(%$fixture) ) {
                for my $k (%$val) {
                    if ( defined $fixture->{data}->{$k} ) {
                        $fixture->{data}->{$k}->{name} = $k;
                        $db->resultset( $fixture->{name} )
                          ->update_or_create( $fixture->{data}->{$k} );
                    }
                }
            }
        }
    }
}

=head2 dump

=cut
sub dump {
    my $self = shift;
    my $out  = $self->build_hash(@_);
    return XMLout($out);
}

=head2 dump_all

=cut
sub dump_all {
    my ($self,$db,$path) = @_;
    
    my @tables = $self->process_table_columns($db);
    foreach my $class (@tables) {
        open (DAT, ">$path/$class.xml");
        print DAT $self->dump($db->resultset($class)->all) . "\n";
        close(DAT);
    }
}

1;

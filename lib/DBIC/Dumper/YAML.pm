package DBIC::Dumper::YAML;
use base qw/DBIC::Dumper/;
use YAML::Syck;

=head2 dump

=cut
sub dump {
    my $self = shift;
    my $out  = $self->build_hash(@_);
    return Dump($out);
}

=head2 load

=cut
sub load {
    my ($self,$db,$indir) = @_;
    
    use Path::Class qw(dir);
    my $dir = dir($indir);
    while ( my $file = $dir->next ) {
        if ( $file =~ /yml$/ ) {
            my $fixture = LoadFile($file);
            while ( my ( $key, $val ) = each(%$fixture) ) {
                for my $k (%$val) {
                    if ( defined $fixture->{data}->{$k} ) {
                        $db->resultset( $fixture->{name} )
                          ->update_or_create( $fixture->{data}->{$k} );
                    }
                }
            }
        }
    }
}

=head2 dump_all

=cut
sub dump_all {
    my ($self,$db,$path) = @_;
    
    my @tables = $self->process_table_columns($db);
    foreach my $class (@tables) {
        open (DAT, ">$path/$class.yml");
        print DAT $self->dump($db->resultset($class)->all) . "\n";
        close(DAT);
    }
}

1;

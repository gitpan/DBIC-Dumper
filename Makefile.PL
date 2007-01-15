use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'DBIC::Dumper',
    AUTHOR              => 'Victor Igumnov <victori@lamer0.com>',
    VERSION_FROM        => 'lib/DBIC/Dumper.pm',
    ABSTRACT_FROM       => 'lib/DBIC/Dumper.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'JSON::Syck' => 0,
        'XML::Simple' => 0,
        'YAML::Syck' => 0,
        'DBIx::Class' => 0,
        'DBIx::Class::Schema::Loader' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'DBIC-Dumper-*' },
);

use lib 'inc';
require ExtUtils::Depends;

use strict;
use ExtUtils::MakeMaker;

require ExtUtils::Depends;
my $bc = ExtUtils::Depends->new("B::OPCheck", "B::Utils");

WriteMakefile(
    'NAME'              => 'B::OPCheck',
    'VERSION_FROM'      => 'lib/B/OPCheck.pm', # finds $VERSION
     $bc->get_makefile_vars,
);
__END__

# XXX: get M::I to support ExtUtils::MakeMaker

use inc::Module::Install 0.75;
name        'B-OPCheck';
all_from    'lib/B/OPCheck.pm';

requires 'Scope::Guard';
requires 'XSLoader';

sign; WriteAll;

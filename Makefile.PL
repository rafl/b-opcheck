use strict;
use ExtUtils::Depends;
use inc::Module::Install 0.91;

name        'B-OPCheck';
all_from    'lib/B/OPCheck.pm';

configure_requires 'B::Utils';
configure_requires 'ExtUtils::Depends';

requires 'B::Utils';
requires 'Scope::Guard';
requires 'XSLoader';

my $bc = ExtUtils::Depends->new("B::OPCheck", "B::Utils");
makemaker_args($bc->get_makefile_vars);

sign; WriteAll;

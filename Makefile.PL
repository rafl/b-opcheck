use strict;
use ExtUtils::Depends;
use inc::Module::Install 0.91;

name        'B-OPCheck';
all_from    'lib/B/OPCheck.pm';

configure_requires 'B::Utils' => 0.08;
#minimum version that depends on ExtUtils::Depends 0.302
configure_requires 'ExtUtils::Depends' => 0.302; #minimum version that works on Win32+gcc

requires 'B::Utils' => 0.08;
requires 'Scope::Guard';
requires 'XSLoader';
build_requires 'Test::More';

repository 'git://github.com/rafl/b-opcheck.git';

my $bc = ExtUtils::Depends->new("B::OPCheck", "B::Utils");
makemaker_args($bc->get_makefile_vars);

sign; WriteAll;

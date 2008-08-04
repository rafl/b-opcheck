package B::OPCheck;

use 5.008;

use strict;
use warnings;

use Carp;
use XSLoader;
use Scalar::Util;
use Scope::Guard;

our $VERSION = '0.26';

XSLoader::load 'B::OPCheck', $VERSION;

sub import {
    my ($class, $opname, $mode, $sub) = @_;

    $^H |= 0x120000; # set HINT_LOCALIZE_HH + an unused bit to work around a %^H bug

    my $by_opname = $^H{OPCHECK_leavescope} ||= {};
    my $guards = $by_opname->{$opname} ||= [];
    push @$guards, Scope::Guard->new(sub {
        leavescope($opname, $sub);
    });

    enterscope($opname, $sub );
}

sub unimport {
    my ($class, $opname) = @_;

    if ( defined $opname ) { 
        my $by_opname = $^H{OPCHECK_leavescope};
        delete $by_opname->{$opname};
        return if scalar keys %$by_opname; # don't delete other things
    }

    delete $^H{OPCHECK_leavescope};
    $^H &= ~0x120000;
}


1;

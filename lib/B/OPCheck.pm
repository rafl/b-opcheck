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

    my $leave_scope = sub {
        leavescope();
    };

    my $sg = Scope::Guard->new($leave_scope);
    $^H{OPCHECK_leavescope} = $sg;

    enterscope($opname, $sub );
}

sub unimport {
    my ($class) = @_;
    $^H &= ~0x120000;
}


1;

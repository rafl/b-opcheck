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
        leavescope($opname, $mode, $sub);
    });

    enterscope($opname, $mode, $sub);
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

__END__

=pod

=head1 NAME

B::OPCheck - PL_check hacks using Perl callbacks

=head1 SYNOPSIS

    use B::Generate; # to change things

    use B::OPCheck entersub => check => sub {
        my $op = shift; # op has been checked by normal PL_check
        sodomize($op);
    };

    foo(); # this entersub will have the callback triggered

=head1 DESCRIPTION

PL_check is an array indexed by opcode number (op_type) that contains function
pointers invoked as the last stage of optree compilation, per op.

This hook is called in bottom up order, as the code is parsed and the optree is
prepared.

This is how modules like L<autobox> do their magic

This module provides an api for registering PL_check hooks lexically, allowing
you to alter the behavior of certain ops using L<B::Generate> from perl space.

=head1 CHECK TYPES

=over 4

=item check

Called after normal PL_checking. The return value is ignored.

=item after

Not yet implemented.

Allows you to return a processed B::OP. The op has been processed by PL_check
already.

=item before

Not yet implemented.

Allows you to return a processed B::OP to be passed to normal PL_check.

=item replace

Not yet implemented.

Allows you to return a processed B::OP yourself, skipping normal PL_check
handling completely.

=back

=head1 AUTHORS

Chia-liang Kao E<lt>clkao@clkao.orgE<gt>
Yuval Kogman E<lt>nothingmuch@woobling.orgE<gt>

=head1 COPYRIGHT

Copyright 2008 by Chia-liang Kao, Yuval Kogman

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut


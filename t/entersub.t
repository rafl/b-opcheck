use Test::More tests => 1;

sub foo {

}

my @results;

sub dothis {
    my $op = $_[0];
    push @results, $_[0]->name
}

{
    use B::OPCheck entersub => 'replace', \&dothis;
    foo(1,2);
    no B::OPCheck;
    foo(2,3);
}

is_deeply(\@results, ['entersub']); # XXX: need to ignore the leavescope call
warn Dumper(\@results);use Data::Dumper;

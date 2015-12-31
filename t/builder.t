use v6;
use lib 'lib';
use Test;

use Dist::Wocky::Dist::Builder;

my $builder = Dist::Wocky::Dist::Builder.new-from-config-file('t/corpus/Dist-Test1/dist.ini');

my %expect-attr = (
    name             => 'Dist-Test1',
    copyright-year   => 2012,
    copyright-holder => 'Foo Corp.',
    author           => Array[Str].new('Jane Doe <jane.doe@example.com>'),
);
for %expect-attr.keys.sort -> $k {
    is-deeply( $builder."$k"(), %expect-attr{$k}, $k );
}

my @plugins = $builder.plugins;
is( @plugins.elems, 2, 'has 2 plugins' );
for <Dist::Wocky::Plugin::AutoPrereqs Dist::Wocky::Plugin::MetaInfo> -> $p {
    is( @plugins.map( { .^name } ).one, $p, "has one $p plugin");
}

my $auto-prereqs = @plugins.first( { $_.isa('Dist::Wocky::Plugin::AutoPrereqs') } );
for <Foo::Bar Foo Foodie Bad::Module> -> $m {
    cmp-ok(
        $m,
        '~~',
        any( $auto-prereqs.skip ),
        "AutoPrereqs would skip $m"
    );
}
for <NotFoo Badder::Module> -> $m {
    cmp-ok(
        $m,
        '!~~',
        any( $auto-prereqs.skip ),
        "AutoPrereqs would not skip $m"
    );
}

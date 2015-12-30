use v6;

use Dist::Wocky::Dist;

unit class Dist::Wocky::Dist::Builder does Dist::Wocky::Dist;

use Dist::Wocky::Logger;

submethod BUILD (
    Str(Any) :$!name?,
    :$version?,
    Int(Any) :$!copyright-year?,
    Str(Any) :$!copyright-holder?,
    :$author?,
    :%!plugin-config = {},
    Dist::Wocky::Logger :$!logger?,
) {
    $!version = Version.new($version)
        if $version.defined;
    if $author.defined {
        @!author = $author ~~ Positional ?? $author !! ($author);
    }
}

use v6;

use Dist::Wocky::Action::PrereqProvider;

unit class Dist::Wocky::Plugin::AutoPrereqs does Dist::Wocky::Action::PrereqProvider;

has @.skip;

submethod BUILD (:$skip?) {
    return unless $skip;
    @!skip =
        ( $skip ~~ Positional ?? $skip !! ($skip) ).map(
        {
            / ^ <[ \w : ]>+ $ /
            ?? $_
            !! rx{ <$_> }
        }
    );
}

method provide-prereqs returns Hash {
    my %runtime = self!prereqs-from-files-matching( / '.pm' '6'? / );
    my %test = self!prereqs-from-files-matching( / '.t' '6'? / );

    return %(
        runtime => %runtime,
        test    => %test,
    );
}

method !prereqs-from-files-matching (Regex:D $re) {
    state %ignore = (
        :MONKEY-SEE-NO-EVAL,
        :lib,
        :v6,
    );

    my %prereqs;
    for $!wocky.files.grep( { .basename ~~ $re } ).map( { .IO.lines } ) -> $line {
        next unless $line ~~ / \s* [ 'use' | 'require' ] \s+ $<module> = \S+ /;
        next if %ignore{ $<module> };
        next $<module> ~~ any(@!skip);

        %prereqs{ $<module>.Str } = 1;
    }
    return %prereqs;
}

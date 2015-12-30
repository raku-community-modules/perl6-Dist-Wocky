use v6;

use Dist::Wocky::File::InMemory;

unit role Dist::Wocky::TemplateFiller;

sub !fill-template (Str $template, %vars) {
    my $filled = $template;
    for %vars.keys -> $k {
        $filled = $template.subst( rx{ "{$k}" }, %vars{$k} );
    }
    return $filled;
}

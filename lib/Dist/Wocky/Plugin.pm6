use v6;

unit role Dist::Wocky::Plugin;

# Circular use simply not allowed right now :(

#use Dist::Wocky::Dist;

has
#Dist::Wocky::Dist
    $!wocky;

submethod BUILD (:$!wocky) { }

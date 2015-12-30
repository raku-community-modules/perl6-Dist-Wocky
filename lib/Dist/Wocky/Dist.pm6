use v6;

unit role Dist::Wocky::Dist;

use Dist::Wocky::Logger;
use Dist::Wocky::Plugin;

use Config::INI;

# These are expected to come from config:
has Str $.name;
has Version $!version;
has Int $.copyright-year;
has Str $.copyright-holder;
has Str @.author;
has Hash %!plugin-config;

# These are built internally:
has Dist::Wocky::Logger $!logger = Dist::Wocky::Logger.new;
has Dist::Wocky::Plugin @!plugins;
has IO::Path @!files;

method new-from-config-file ($class: Str(Any) $file) {
    my %config = Config::INI::parse_file($file);

    my %args;
    for %config<_>.keys -> $k {
        %args{$k} = %config<_>{$k};
    }

    for %config.keys.grep( { $_ ne q{_} } ) -> $k {
        %args<plugin-config>{$k} = %config{$k};
    }

    return $class.new(|%args);
}

method plugins {
    return @!plugins ||=
        %!plugin-config.keys.map(
        {
            my $class = self!maybe-expand-plugin-name($_);
            require ::($class);
            ::($class).new( |%!plugin-config{$_}, wocky => self );
        }
    );
}

method files returns Array[IO::Path] {
    return @!files //= self!find-all-files;
}

method !find-all-files returns Array[IO::Path] {
    my @files;
    for self!plugins-for-action(:FileFinder) -> $plugin {
        @files.append: $plugin.find-files;
    }
}

method !plugins-for-action ($action) returns Array[Dist::Wocky::Plugin] {
    my $full-name = self!maybe-expand-plugin-name( $action.keys[0] );
    return self.plugins.grep( { .does($full-name) } );
}

method !maybe-expand-plugin-name (Str $name) {
    if $name ~~ / ^ '+' / {
        return $name.subst( / ^ '+' /, q{} );
    }
    return 'Dist::Wocky::Plugin::' ~ $name;
}

method version {
    return $!version //= self.plugins-for-action(:VersionProvider).map( { .version } ).first;
}

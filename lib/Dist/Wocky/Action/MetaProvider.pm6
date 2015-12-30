use v6;

use Dist::Zilla::Plugin;

unit role Dist::Wocky::Action::MetaProvider does Dist::Zilla::Plugin;

method provide-meta returns Hash { ... }

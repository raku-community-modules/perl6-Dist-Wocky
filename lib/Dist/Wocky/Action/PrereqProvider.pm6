use v6;

use Dist::Wocky::Plugin;

unit role Dist::Wocky::Action::PrereqProvider does Dist::Wocky::Plugin;

method provide-prereqs returns Hash { ... }

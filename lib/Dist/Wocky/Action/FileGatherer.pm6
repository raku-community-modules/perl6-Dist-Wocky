use v6;

use Dist::Zilla::Plugin;

unit role Dist::Wocky::Action::FileGatherer does Dist::Zilla::Plugin;

method gather-files returns List[Dist::Wocky::File] { ... }

use v6;

unit role Dist::Wocky::Logger;

method log (Str:D(Any:D) $msg) {
    say "[{self.what}] $msg";
}

method log-fatal (Str:D(Any:D) $msg) {
    die "[{self.what}] $msg";
}

use v6;

unit role Dist::Wocky::File;

subset Content where * ~~ Str || * ~~ Buf;

has IO::Path $!filename;
has Content $!content;

submethod BUILD (IO::Path :$!filename = (IO::Path), Content :$!content = (Content))  {
    $!filename //= self!build-filename;
    $!content  //= self!build-content;
}

method !build-filename returns IO::Path {
    die "You must provide a filename parameter when constructing a {self.WHAT} object";
}

method !build-content returns Content {
    die "You must provide a content parameter when constructing a {self.WHAT} object";
}

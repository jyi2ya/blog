#!/usr/bin/env perl
use 5.036;
use utf8;
use warnings 'all';
use autodie ':all';
use open qw/:std :utf8/;
utf8::decode($_) for @ARGV;

system qw#ikiwiki --setup ./jyi.setup#;
system qw#ikiwiki-calendar ./jyi.setup#;
chdir '../jyi2ya.github.io/';
system qw/git checkout --orphan temp/;
system qw/git add --all/;
system qw/git commit -m/, 'update site';
system qw/git branch -D main/;
system qw/git branch -m main/;
system qw/git push -f origin main/;

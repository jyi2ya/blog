#!/usr/bin/env perl
use 5.036;
use utf8;
use warnings 'all';
use autodie ':all';
utf8::decode($_) for @ARGV;

use FindBin;
use Getopt::Long;
use Env qw/@PERL5LIB @PATH/;

my %option;

GetOptions (
    \%option,
    'deploy',
) or die;

chdir "$FindBin::Bin/..";

unshift @PATH, "$FindBin::Bin/../local/bin";
unshift @PERL5LIB, './local/lib/perl5';
unshift @PERL5LIB, './local/lib64/perl5/5.44';
unshift @PERL5LIB, './local/lib64/perl5/5.44/x86_64-linux';
unshift @PERL5LIB, './plugins/ikiplugins/';
unshift @PERL5LIB, './plugins/jyi/';

system qw#scripts/mtime-restore.pl#;
system qw#./local/bin/ikiwiki --setup ./jyi.setup#;
system qw#./local/bin/ikiwiki-calendar ./jyi.setup#;
system 'cp -r plugins/l2d/ ../jyi2ya.github.io/';

if ($option{deploy}) {
    chdir '../jyi2ya.github.io/';
    system qw/git checkout --orphan temp/;
    system qw/git add --all/;
    system qw/git commit -m/, 'update site';
    system qw/git branch -D main/;
    system qw/git branch -m main/;
    system qw/git push -f origin main/;
}

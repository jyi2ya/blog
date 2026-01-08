#!/usr/bin/perl

package IkiWiki::Plugin::gettitle;

use warnings;
use strict;
use IkiWiki 2.00;

sub import {
    hook(type => "filter", id => "gettitle", call => \&filter);
}

sub filter(@) {
    my %params = @_;
    my $page = $params{page};
    my $content = $params{content};

    my $title = do {
        if ($content =~ /^=head1\s+(.+)/m) {
            $1
        } elsif ($content =~ /^#\s+(.+)/m) {
            $1
        } elsif ($content =~ /^title:\s*(.+)/m) {
            $1
        } else {
            undef
        }
    };

    if ($title) {
        $pagestate{$page}{meta}{title} = $title;
    }

    return $content;
}

1


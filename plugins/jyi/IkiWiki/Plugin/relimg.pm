#!/usr/bin/perl
package IkiWiki::Plugin::relimg;

use warnings;
use strict;
use IkiWiki 3.00;

sub import {
	hook(type => "getsetup", id => "relimg", call => \&getsetup);
	hook(type => "sanitize", id => "relimg", call => \&sanitize);
}

sub getsetup () {
	return
		plugin => {
			safe => 1,
			rebuild => 1,
			section => "widget",
		};
}

sub sanitize (@) {
	my %params=@_;
	my $page=$params{page};
	my $destpage=$params{destpage};
	my $content=$params{content};

	return $content if !defined $page || !defined $destpage;
	return $content if $page eq $destpage;

	my $rel = IkiWiki::abs2rel(
		IkiWiki::dirname(IkiWiki::htmlpage($page)),
		IkiWiki::dirname(IkiWiki::htmlpage($destpage))
	);

	$rel .= '/' if length $rel && $rel !~ m{/$};

	my $rewrite = sub {
		my ($quote, $url) = @_;
		return "src=$quote$url$quote" if $url =~ m{^[a-z]+://|^/|^#}i;
		$url =~ s{^\./}{};
		return "src=$quote${rel}${url}$quote";
	};

	$content =~ s{src="((?![a-z]+://)[^"]+)"}{ $rewrite->('"', $1) }gie;
	$content =~ s{src='((?![a-z]+://)[^']+)'}{ $rewrite->("'", $1) }gie;

	return $content;
}

1

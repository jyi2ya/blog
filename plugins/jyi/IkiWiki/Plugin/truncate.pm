#!/usr/bin/perl
package IkiWiki::Plugin::truncate;

use warnings;
use strict;
use IkiWiki 3.00;

sub import {
	hook(type => "getsetup", id => "truncate", call => \&getsetup);
	hook(type => "format", id => "truncate", call => \&format, last => 1);
}

sub getsetup () {
	return plugin => { safe => 1, rebuild => 1, section => "widget" },
		truncate_length => { type => "integer", example => 500,
			description => "approximate character limit for inline content preview (CSS-based, 0 to disable)",
			safe => 1, rebuild => 1 },
		truncate_suffix => { type => "string", example => "...",
			description => "link text for the read-more link",
			safe => 1, rebuild => 1 },
	;
}

sub format (@) {
	my %params=@_;
	my $content=$params{content};

	my $maxlen = $IkiWiki::config{truncate_length} // 0;
	return $content if !$maxlen || $maxlen <= 0;

	my $suffix = $IkiWiki::config{truncate_suffix} // '...';
	my $maxem = int($maxlen / 30) + 3;

	my $css = qq{
<style>
.inlinepage .inlinecontent {
	max-height: ${maxem}em;
	overflow: hidden;
}
</style>
};

	$content =~ s{(</head>)}{$css$1};

		$content =~ s{(<div class="inlinepage">\s*<div class="inlineheader">.*?<a href="([^"]+)">.*?<div class="inlinecontent">)(.*?)(</div>)(\s*<div class="inlinefooter")}{$1$3$4<p><a class="readmore" href="$2">$suffix</a></p>$5}gs;

	return $content;
}

1

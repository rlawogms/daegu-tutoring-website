#!/usr/bin/perl
use strict; use warnings;
use utf8; binmode STDOUT, ":encoding(UTF-8)";

my $path = "index.html";
open(F, "<:encoding(UTF-8)", $path) or die $!;
local $/; my $c = <F>; close F;
my $orig_len = length($c);

sub cut_between {
  my ($start_marker, $end_marker_incl, $label) = @_;
  my $start_pos = index($c, $start_marker);
  my $end_pos = index($c, $end_marker_incl, $start_pos);
  if ($start_pos == -1 || $end_pos == -1) {
    print "WARN [$label]: markers not found (start=$start_pos end=$end_pos)\n";
    return;
  }
  my $cut_end = $end_pos + length($end_marker_incl);
  substr($c, $start_pos, $cut_end - $start_pos) = '';
}

# 1. CSS for school modal/backdrop (not needed anymore; daegu-regions.html has its own simpler CSS)
cut_between(
  q(.school-backdrop {),
  q(.school-empty { font-size: 13px; color: #999; text-align: center; padding: 20px 0; }
),
  "css-school-modal"
);

# 2. modal HTML block
cut_between(
  q(<div class="school-backdrop" id="schoolBackdrop" onclick="closeRegionModal()"></div>),
  q(  <div id="schoolModalBody"></div>
</div>
),
  "html-school-modal"
);

# 3. modal JS block
cut_between(
  q(<script>
  var TYPE_LABELS = { e: '초등학교', m: '중학교', h: '고등학교', o: '특수·기타학교' };),
  q(</script>
<script src="school-data.js"></script>
),
  "js-school-modal"
);

open(OUT, ">:encoding(UTF-8)", $path) or die $!;
print OUT $c;
close OUT;
print "stage5 done. length $orig_len -> " . length($c) . "\n";

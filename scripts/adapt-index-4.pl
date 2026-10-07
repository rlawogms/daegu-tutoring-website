#!/usr/bin/perl
use strict; use warnings;
use utf8; binmode STDOUT, ":encoding(UTF-8)";

my $path = "index.html";
open(F, "<:encoding(UTF-8)", $path) or die $!;
local $/; my $c = <F>; close F;
my $orig_len = length($c);

# 1. Replace giant nationwide region <select> with 대구-only options
{
  my $start_marker = q{<select name="시도" id="regionSelect" required>
        <option value="" disabled selected>지역 선택</option>};
  my $end_marker = q{</optgroup>
      </select>
      <input type="text" name="상세지역"};
  my $start_pos = index($c, $start_marker);
  my $end_pos = index($c, $end_marker);
  if ($start_pos == -1 || $end_pos == -1) {
    print "WARN [region-select]: markers not found (start=$start_pos end=$end_pos)\n";
  } else {
    my $replacement = q{<select name="시도" id="regionSelect" required>
        <option value="" disabled selected>지역 선택</option>
        <option>대구광역시 군위군</option>
        <option>대구광역시 남구</option>
        <option>대구광역시 달서구</option>
        <option>대구광역시 달성군</option>
        <option>대구광역시 동구</option>
        <option>대구광역시 북구</option>
        <option>대구광역시 서구</option>
        <option>대구광역시 수성구</option>
        <option>대구광역시 중구</option>
      </select>
      <input type="text" name="상세지역"};
    substr($c, $start_pos, ($end_pos + length($end_marker)) - $start_pos) = $replacement;
  }
}

open(OUT, ">:encoding(UTF-8)", $path) or die $!;
print OUT $c;
close OUT;
print "stage4 done. length $orig_len -> " . length($c) . "\n";

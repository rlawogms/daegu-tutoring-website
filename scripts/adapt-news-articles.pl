#!/usr/bin/perl
use strict; use warnings;
use utf8; binmode STDOUT, ":encoding(UTF-8)";

my @files = glob("news/*.html");
for my $f (@files) {
  open(F, "<:encoding(UTF-8)", $f) or die $!;
  local $/; my $c = <F>; close F;

  $c =~ s/https:\/\/alltutoring-website\.co\.kr/https:\/\/daegu-tutoring-website.co.kr/g;
  $c =~ s/ - 전과목 일대일 맞춤 과외/ - 대구 전과목 일대일 맞춤 과외/g;
  $c =~ s/"name":"전과목 일대일 맞춤 과외"/"name":"대구 전과목 일대일 맞춤 과외"/g;
  $c =~ s/alt="전과목 일대일 과외"><span>전과목 일대일 과외<\/span>/alt="대구 전과목 일대일 과외"><span>대구 전과목 일대일 과외<\/span>/;

  my $old_nav = q(    <a href="../academy-finder.html" class="nav-link">근처 학원 찾기</a>
    <a href="../검정고시-과외.html" class="nav-link">검정고시 과외</a>
    <a href="../국제학교-과외.html" class="nav-link">국제학교 과외</a>
    <a href="../regions.html" class="nav-link">지역 및 지역 학교 확인하기</a>);
  my $new_nav = q(    <a href="../daegu-regions.html" class="nav-link">지역별 과외 안내</a>);
  my $cnt = () = $c =~ /\Q$old_nav\E/g;
  if ($cnt == 1) { $c =~ s/\Q$old_nav\E/$new_nav/; }
  else { print "WARN [$f] nav block count=$cnt\n"; }

  open(OUT, ">:encoding(UTF-8)", $f) or die $!;
  print OUT $c;
  close OUT;
  print "done: $f\n";
}

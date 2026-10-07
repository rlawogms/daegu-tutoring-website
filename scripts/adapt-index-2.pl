#!/usr/bin/perl
use strict; use warnings;
use utf8; binmode STDOUT, ":encoding(UTF-8)";

my $path = "index.html";
open(F, "<:encoding(UTF-8)", $path) or die $!;
local $/; my $c = <F>; close F;
my $orig_len = length($c);

sub repl {
  my ($old, $new, $label) = @_;
  my $count = () = $c =~ /\Q$old\E/g;
  if ($count != 1) {
    print "WARN [$label]: found $count occurrences (expected 1)\n";
  }
  $c =~ s/\Q$old\E/$new/;
}

# A. navbar links
repl(
  q{    <a href="academy-finder.html" class="nav-link">근처 학원 찾기</a>
    <a href="검정고시-과외.html" class="nav-link">검정고시 과외</a>
    <a href="국제학교-과외.html" class="nav-link">국제학교 과외</a>
    <a href="regions.html" class="nav-link">지역 및 지역 학교 확인하기</a>},
  q{    <a href="daegu-regions.html" class="nav-link">지역별 과외 안내</a>},
  "navbar-links"
);

# B. hero badge/h1/p
repl(
  q{  <div class="hero-badge">✦ 전국 어디서나, 대면·비대면 모두 가능</div>
  <h1>우리 아이만을 위한<br><span>일대일 맞춤 과외</span>, 전국 어디서나</h1>
  <p>국어 · 영어 · 수학 · 과학 · 사회 전 과목<br>방문 대면 수업 + 화상 비대면 수업, 원하는 방식으로 자유롭게</p>},
  q{  <div class="hero-badge">✦ 대구 9개 구·군 전 지역, 대면·비대면 모두 가능</div>
  <h1>우리 아이만을 위한<br><span>일대일 맞춤 과외</span>, 대구 전 지역에서</h1>
  <p>국어 · 영어 · 수학 · 과학 · 사회 전 과목<br>방문 대면 수업 + 화상 비대면 수업, 원하는 방식으로 자유롭게</p>},
  "hero"
);

# C. stats-row
repl(
  q{<div class="stat-item"><span class="stat-num">전국</span><div class="stat-label">광역시·시·구·군·읍·면</div></div>},
  q{<div class="stat-item"><span class="stat-num">대구</span><div class="stat-label">9개 구·군 전 지역</div></div>},
  "stats-row"
);

# D. remove giant region-groups section -> compact 대구 chip summary linking to daegu-regions.html
{
  my $start_marker = q{<section class="section">
  <div class="accent-line"></div>
  <h2 class="section-title">전국 어디서나 매칭 가능</h2>};
  my $end_marker = q{</section>

<section class="section-bg">
  <div class="accent-line"></div>
  <h2 class="section-title">왜 저희 과외를 선택해야 할까요</h2>};
  my $start_pos = index($c, $start_marker);
  my $end_pos = index($c, $end_marker);
  if ($start_pos == -1 || $end_pos == -1 || $end_pos < $start_pos) {
    print "WARN [region-section]: markers not found properly (start=$start_pos end=$end_pos)\n";
  } else {
    my $replacement = q{<section class="section">
  <div class="accent-line"></div>
  <h2 class="section-title">대구 전 지역 매칭 가능</h2>
  <div class="section-sub">군위군·남구·달서구·달성군·동구·북구·서구·수성구·중구, 대구광역시 9개 구·군 어디서나 맞춤 수업을 진행할 수 있습니다</div>
  <div class="region-groups">
    <div class="region-group" style="flex:1 1 100%;">
      <div class="region-group-title">대구광역시</div>
      <div class="region-chips">
        <a href="daegu-regions.html#card-군위군" class="region-chip" style="text-decoration:none;">군위군</a>
        <a href="daegu-regions.html#card-남구" class="region-chip" style="text-decoration:none;">남구</a>
        <a href="daegu-regions.html#card-달서구" class="region-chip" style="text-decoration:none;">달서구</a>
        <a href="daegu-regions.html#card-달성군" class="region-chip" style="text-decoration:none;">달성군</a>
        <a href="daegu-regions.html#card-동구" class="region-chip" style="text-decoration:none;">동구</a>
        <a href="daegu-regions.html#card-북구" class="region-chip" style="text-decoration:none;">북구</a>
        <a href="daegu-regions.html#card-서구" class="region-chip" style="text-decoration:none;">서구</a>
        <a href="daegu-regions.html#card-수성구" class="region-chip" style="text-decoration:none;">수성구</a>
        <a href="daegu-regions.html#card-중구" class="region-chip" style="text-decoration:none;">중구</a>
      </div>
    </div>
  </div>
  <div class="region-note">💡 대면 수업은 지역별 선생님 배정 상황에 따라 매칭 가능 여부가 달라질 수 있으며, 비대면 화상 수업은 대구 전 지역에서 동일하게 진행 가능합니다.</div>
  <div class="region-more-wrap">
    <a href="daegu-regions.html" class="region-more-btn">우리 동네·학교 찾아보기 <i class="ti ti-chevron-right"></i></a>
  </div>
}; # note: trailing </section> intentionally kept from original end_marker split below
    substr($c, $start_pos, $end_pos - $start_pos) = $replacement;
  }
}

open(OUT, ">:encoding(UTF-8)", $path) or die $!;
print OUT $c;
close OUT;
print "stage2a done. length $orig_len -> " . length($c) . "\n";

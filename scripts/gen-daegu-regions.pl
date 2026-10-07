#!/usr/bin/perl
use strict; use warnings;
use utf8; binmode STDOUT, ":encoding(UTF-8)";
use JSON::PP;

open(F, "<:encoding(UTF-8)", "school-data.js") or die $!;
local $/; my $c = <F>;
close F;
$c =~ s/^window\.SCHOOL_DATA\s*=\s*//;
$c =~ s/;\s*$//;
my $data = JSON::PP->new->utf8(0)->decode($c);

my @guns = ('군위군','남구','달서구','달성군','동구','북구','서구','수성구','중구');
my %typeLabel = (e=>'초등학교', m=>'중학교', h=>'고등학교', o=>'기타');
my %typeOrder = (e=>0, m=>1, h=>2, o=>3);

my $total = 0;
my @cards;
for my $gun (@guns) {
  my $key = "대구광역시|$gun";
  my $schools = $data->{$key} || [];
  my $cnt = scalar(@$schools);
  $total += $cnt;

  # distinct dong list, preserving first-seen order
  my %seen; my @dongs;
  for my $s (@$schools) {
    my $d = $s->{d};
    next unless $d;
    next if $seen{$d}++;
    push @dongs, $d;
  }

  # group schools by type
  my %byType;
  for my $s (@$schools) {
    push @{$byType{$s->{t}}}, $s;
  }

  my $dongChips = join('', map { qq{<span class="dong-tag">$_</span>} } @dongs[0..($#dongs < 11 ? $#dongs : 11)]);
  my $dongMore = scalar(@dongs) > 12 ? sprintf(' <span class="dong-tag dong-more">외 %d개 동</span>', scalar(@dongs) - 12) : '';

  my $schoolListHtml = '';
  for my $t (sort { $typeOrder{$a} <=> $typeOrder{$b} } keys %byType) {
    my @names = sort map { $_->{n} } @{$byType{$t}};
    $schoolListHtml .= qq{<div class="school-type-group"><div class="school-type-label">$typeLabel{$t} (} . scalar(@names) . qq{)</div><div class="school-list">} . join('', map { qq{<span class="school-item">$_</span>} } @names) . qq{</div></div>};
  }

  my $dataSearch = "$gun 대구 $gun " . join(' ', @dongs) . ' ' . join(' ', map { $_->{n} } @$schools) . " 대구 $gun 과외 대구 $gun 수학과외 대구 $gun 영어과외 대구 $gun 국어과외 대구 $gun 과학과외 대구 $gun 사회과외 대구 $gun 일대일과외 대구 $gun 비대면과외 대구 $gun 방문과외";

  my $card = qq{
    <div class="center-card" data-name="$gun" data-search="$dataSearch">
      <div class="card-front">
        <div class="card-top-row">
          <div class="center-brand brand-wawa">대구 $gun</div>
        </div>
        <div class="center-name">대구광역시 $gun</div>
        <div class="center-reg">관할 학교 $cnt\개 기준 서비스 가능 지역</div>
        <div class="center-addr filled">$dongChips$dongMore</div>
        <details class="school-details">
          <summary>이 지역 학교 목록 보기</summary>
          $schoolListHtml
        </details>
        <a href="index.html#consult" class="detail-btn"><i class="ti ti-message-circle-2"></i> 이 지역 과외 상담 신청</a>
      </div>
    </div>};
  push @cards, $card;
}

my $cardsHtml = join("\n", @cards);

open(my $out, ">:encoding(UTF-8)", "daegu-regions-cards.html.part") or die $!;
print $out $cardsHtml;
close $out;

print "Total schools: $total\n";
print "Cards generated: " . scalar(@cards) . "\n";

#!/usr/bin/perl
use strict; use warnings;
use utf8; binmode STDOUT, ":encoding(UTF-8)";

my $path = "index.html";
open(F, "<:encoding(UTF-8)", $path) or die $!;
local $/; my $c = <F>; close F;
my $orig_len = length($c);

my $start_marker = q(var SITE_SEARCH_INDEX = [);
my $end_marker = q(];
function renderSiteSearch() {);
my $start_pos = index($c, $start_marker);
my $end_pos = index($c, $end_marker);
if ($start_pos == -1 || $end_pos == -1) {
  print "WARN [site-search-index]: markers not found (start=$start_pos end=$end_pos)\n";
} else {
  my $replacement = q(var SITE_SEARCH_INDEX = [
  { title: '개설 과목 - 국어', desc: '문학·비문학 독해, 논술 및 서술형 대비', url: '#subjects', kw: '국어 과목 문학 비문학 독해 논술 서술형' },
  { title: '개설 과목 - 영어', desc: '회화·문법·독해·내신 목표별 집중 수업', url: '#subjects', kw: '영어 과목 회화 문법 독해 내신' },
  { title: '개설 과목 - 수학', desc: '개념 완성부터 심화까지 단계별 맞춤 커리큘럼', url: '#subjects', kw: '수학 과목 개념 내신 수능' },
  { title: '개설 과목 - 과학', desc: '물리·화학·생명·지구과학 개념·내신 집중 대비', url: '#subjects', kw: '과학 과목 물리 화학 생명 지구과학' },
  { title: '개설 과목 - 사회', desc: '역사·지리·일반사회 개념 학습', url: '#subjects', kw: '사회 과목 역사 지리 일반사회' },
  { title: '수업 방식 안내', desc: '대면 방문 수업과 비대면 화상 수업 안내', url: '#about', kw: '수업 방식 대면 비대면 화상 방문' },
  { title: '대구 지역별 과외 안내', desc: '대구광역시 9개 구·군 지역별 학교 정보 확인', url: 'daegu-regions.html', kw: '대구 지역 학교 구 군 확인 군위 남구 달서구 달성군 동구 북구 서구 수성구 중구' },
  { title: '선생님 소개', desc: '전직교사·현직교사·명문대 출신 선생님 매칭 안내', url: 'teachers.html', kw: '선생님 소개 전직교사 현직교사 명문대' },
  { title: '수강료 안내', desc: '대면·비대면 수업 시간당 수강료 확인', url: '#tuition', kw: '수강료 비용 가격 시간당 요금' },
  { title: '학부모 후기', desc: '학부모·학생들의 후기', url: 'reviews.html', kw: '후기 리뷰 평가 학부모 만족도' },
  { title: '무료 상담 신청', desc: '전화 또는 온라인 폼으로 상담 신청', url: '#consult', kw: '상담 신청 문의 전화 매칭' },
  { title: '자주 묻는 질문', desc: '과외비, 전직교사 매칭, 대구 지역 신청 가능 여부 등 FAQ', url: '#faq', kw: 'FAQ 자주 묻는 질문 과외비 전직교사 문의' },
  { title: '입시뉴스 - 과외비 책정 기준', desc: '비대면·대면 수업 시간당 과외비 기준 안내', url: 'news/과외비-기준.html', kw: '과외비 시간당 비용 기준 시세' },
  { title: '입시뉴스 - 선생님 궁합 상담', desc: '학습 궁합이 안 맞을 때 담당 매니저와 상의하는 방법', url: 'news/선생님-궁합-상담.html', kw: '선생님 궁합 재매칭 상담' },
  { title: '입시뉴스 - 10월 전국연합학력평가 일정', desc: '10월 20일 고1·고2·고3 동시 응시, 시험 시간표 안내', url: 'news/10월학력평가-일정.html', kw: '10월 학력평가 모의고사 일정 고1 고2 고3' }
];
function renderSiteSearch() {);
  substr($c, $start_pos, ($end_pos + length($end_marker)) - $start_pos) = $replacement;
}

open(OUT, ">:encoding(UTF-8)", $path) or die $!;
print OUT $c;
close OUT;
print "stage6 done. length $orig_len -> " . length($c) . "\n";

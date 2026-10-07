#!/usr/bin/perl
use strict; use warnings;
use utf8; binmode STDOUT, ":encoding(UTF-8)";

my $path = "index.html";
open(F, "<:encoding(UTF-8)", $path) or die $!;
local $/; my $c = <F>; close F;

# 1. remove naver/google site verification (not valid for new domain)
$c =~ s/\n?<meta name="naver-site-verification"[^>]*\/>\n?//;
$c =~ s/\n?<meta name="google-site-verification"[^>]*\/>\n?//;

# 2. title/meta/canonical/og
$c =~ s/<title>.*?<\/title>/<title>대구 전과목 일대일(1:1) 과외 | 대구 9개 구·군 전 지역 - 대면·비대면<\/title>/s;
$c =~ s/<meta name="description" content="[^"]*" \/>\n<meta name="keywords"[^>]*\/>/<meta name="description" content="대구광역시 군위군·남구·달서구·달성군·동구·북구·서구·수성구·중구 전 지역, 국어·영어·수학·과학·사회 전 과목을 전직교사·현직교사·명문대 출신 선생님과 대면·비대면 중 선택해 일대일로 배우세요." \/>\n<meta name="keywords" content="대구 과외, 대구 일대일 과외, 대구 1:1 과외, 대구 전과목 과외, 대구 수학과외, 대구 영어과외, 대구 국어과외, 대구 과학과외, 대구 사회과외, 대구 비대면 과외, 대구 방문과외, 대구 초등 과외, 대구 중등 과외, 대구 고등 과외, 수성구 과외, 달서구 과외, 남구 과외, 동구 과외, 북구 과외, 서구 과외, 중구 과외, 달성군 과외, 군위군 과외" \/>/s;
$c =~ s{<link rel="canonical" href="https://alltutoring-website\.co\.kr/" />}{<link rel="canonical" href="https://daegu-tutoring-website.co.kr/" />};
$c =~ s{<meta property="og:title" content="[^"]*" />}{<meta property="og:title" content="대구 전과목 일대일 맞춤 과외 - 대구 전 지역, 대면·비대면" />};
$c =~ s{<meta property="og:description" content="[^"]*" />}{<meta property="og:description" content="대구광역시 9개 구·군 전 지역, 국어·영어·수학·과학·사회 전 과목을 대면·비대면으로" />};
$c =~ s{https://alltutoring-website\.co\.kr}{https://daegu-tutoring-website.co.kr}g;

# 3. JSON-LD EducationalOrganization: rename, drop aggregateRating (no real review data yet for new site)
$c =~ s{"name": "전과목 일대일 맞춤 과외",\n  "alternateName": \[[^\]]*\],}{"name": "대구 전과목 일대일 맞춤 과외",\n  "alternateName": ["대구 일대일 맞춤 과외", "대구 전과목 1:1 맞춤 과외", "대구 전과목 1:1 과외"],}s;
$c =~ s{"description": "국어·영어·수학·과학·사회 전 과목, 전국 시·구·군·읍·면·동 어디서나 대면·비대면 일대일 맞춤 과외 매칭 서비스",}{"description": "국어·영어·수학·과학·사회 전 과목, 대구광역시 9개 구·군 전 지역에서 대면·비대면 일대일 맞춤 과외 매칭 서비스",}s;
$c =~ s{\n  "areaServed": "KR",\n  "aggregateRating": \{\n    "\@type": "AggregateRating",\n    "ratingValue": "4\.9",\n    "bestRating": "5",\n    "reviewCount": "184"\n  \}\n}{\n  "areaServed": "대구광역시"\n};

# 4. FAQ: "전국 어디서나 신청할 수 있나요?" -> 대구 ver
my $old_faq = q{"name": "전국 어디서나 신청할 수 있나요?",
      "acceptedAnswer": { "@type": "Answer", "text": "네, 광역시·도부터 시·구·군·읍·면·동 단위까지 전국 모든 지역에서 매칭이 가능합니다. 비대면 화상 수업은 지역에 상관없이 원하는 선생님과 수업할 수 있습니다." }};
my $new_faq = q{"name": "대구 전 지역 어디서나 신청할 수 있나요?",
      "acceptedAnswer": { "@type": "Answer", "text": "네, 대구광역시 9개 구·군(군위군·남구·달서구·달성군·동구·북구·서구·수성구·중구) 전 지역에서 매칭이 가능합니다. 비대면 화상 수업은 지역에 상관없이 원하는 선생님과 수업할 수 있습니다." }};
$c =~ s/\Q$old_faq\E/$new_faq/;

# 5. web3forms 신청 경로 label
$c =~ s{'신청 경로': 'rlawogms\.github\.io/alltutoring-website'}{'신청 경로': 'daegu-tutoring-website.co.kr'};

open(OUT, ">:encoding(UTF-8)", $path) or die $!;
print OUT $c;
close OUT;
print "stage1 done, length=" . length($c) . "\n";

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
  if ($count != 1) { print "WARN [$label]: found $count occurrences (expected 1)\n"; return; }
  $c =~ s/\Q$old\E/$new/;
}

# features-grid card
repl(
  q{    <div class="feature-card">
      <div class="feature-icon-wrap"><i class="ti ti-map-pin"></i></div>
      <div class="feature-title">전국 어디서나 매칭</div>
      <div class="feature-text">광역시부터 읍·면 단위까지, 전국 모든 지역에서 학생 조건에 맞는 선생님을 찾아드립니다.</div>
    </div>},
  q{    <div class="feature-card">
      <div class="feature-icon-wrap"><i class="ti ti-map-pin"></i></div>
      <div class="feature-title">대구 전 지역 매칭</div>
      <div class="feature-text">대구광역시 9개 구·군 어디서나, 학생 조건에 맞는 선생님을 찾아드립니다.</div>
    </div>},
  "features-grid"
);

# teacher-card inline preview -> placeholder (content to be filled in later)
repl(
  q{  <div class="teacher-card">
    <div class="teacher-avatar av-blue">김</div>
    <div>
      <div class="teacher-badge">전직 고등 교사</div>
      <div class="teacher-name">김○○ 선생님 · 수학</div>
      <div class="teacher-desc">전직 고등학교 수학 교사 · 임용 경력 9년<br>내신 출제 경향과 수능 연계 학습에 강점, 방문·화상 수업 모두 가능</div>
    </div>
  </div>
  <div class="teacher-card">
    <div class="teacher-avatar av-amber">박</div>
    <div>
      <div class="teacher-badge">전직 대형학원 강사</div>
      <div class="teacher-name">박○○ 선생님 · 영어</div>
      <div class="teacher-desc">전직 대형 어학원 대표강사 · 경력 12년<br>회화·문법·독해 전 영역 지도, 원어민 발음 교정 및 내신·수능 병행 지도</div>
    </div>
  </div>
  <div class="teacher-card">
    <div class="teacher-avatar av-teal">이</div>
    <div>
      <div class="teacher-badge">명문대 재학생</div>
      <div class="teacher-name">이○○ 선생님 · 국어</div>
      <div class="teacher-desc">서울 소재 국어국문학과 재학 · 수능 국어 만점<br>또래 눈높이에 맞춘 친근한 수업 진행, 비대면 화상 수업 전문</div>
    </div>
  </div>},
  q{  <div style="background:#F5F7FB;border-radius:12px;padding:32px 24px;text-align:center;color:#888;font-size:14px;line-height:1.8;">
    대구 지역 선생님 프로필은 준비 중입니다.<br>무료 상담 신청 시 담당 매니저가 과목·지역에 맞는 선생님을 바로 안내해드립니다.
  </div>},
  "teacher-card-preview"
);

# review-card inline preview + section-sub rating claim -> placeholder
repl(
  q{  <div class="section-sub">★ 4.9 / 5.0 · 후기 184건+</div>
  <div class="review-card">
    <div class="review-stars">★★★★★</div>
    <div class="review-text">지방이라 좋은 선생님 구하기 힘들었는데, 화상 수업으로 서울권 선생님께 배울 수 있어서 좋았어요. 아이 수준에 맞춰 진도를 조절해주셔서 만족도가 높습니다.</div>
    <div class="review-author">중2 학부모 · 비대면 수학 수강 5개월</div>
  </div>
  <div class="review-card">
    <div class="review-stars">★★★★★</div>
    <div class="review-text">방문 선생님이 정말 꼼꼼하게 봐주세요. 학원과 달리 아이만을 위한 진도라 부족한 부분을 바로바로 채울 수 있었고, 성적이 확실히 올랐어요.</div>
    <div class="review-author">고1 학부모 · 대면 영어 수강 7개월</div>
  </div>
  <div class="review-card">
    <div class="review-stars">★★★★☆</div>
    <div class="review-text">필요한 과목을 매칭해주셔서 편했습니다. 선생님마다 스타일이 달라 처음엔 고민했는데 무료수업을 잘 맞춰주셨어요.</div>
    <div class="review-author">중3 학부모 · 비대면 국어·과학 수강 3개월</div>
  </div>},
  q{  <div class="section-sub">대구 지역 후기가 곧 업데이트됩니다</div>
  <div style="background:#F5F7FB;border-radius:12px;padding:32px 24px;text-align:center;color:#888;font-size:14px;line-height:1.8;">
    아직 등록된 후기가 없습니다.<br>첫 수업을 시작하시면 가장 먼저 소개해드릴게요.
  </div>},
  "review-card-preview"
);

# visible FAQ "전국 어디서나" question
repl(
  q{    <details class="faq-item">
      <summary>전국 어디서나 신청할 수 있나요?</summary>
      <div class="faq-answer">네, 광역시·도부터 시·구·군·읍·면·동 단위까지 전국 모든 지역에서 매칭이 가능합니다. 비대면 화상 수업은 지역에 상관없이 원하는 선생님과 수업할 수 있습니다.</div>
    </details>},
  q{    <details class="faq-item">
      <summary>대구 전 지역 어디서나 신청할 수 있나요?</summary>
      <div class="faq-answer">네, 대구광역시 9개 구·군(군위군·남구·달서구·달성군·동구·북구·서구·수성구·중구) 전 지역에서 매칭이 가능합니다. 비대면 화상 수업은 지역에 상관없이 원하는 선생님과 수업할 수 있습니다.</div>
    </details>},
  "faq-visible"
);

open(OUT, ">:encoding(UTF-8)", $path) or die $!;
print OUT $c;
close OUT;
print "stage3 done. length $orig_len -> " . length($c) . "\n";

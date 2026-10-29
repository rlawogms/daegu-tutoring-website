use strict; use warnings;
use utf8; binmode STDOUT, ":encoding(UTF-8)";

my @files = ("news/수능D20-과외점검.html", "news/수능일정확정-논술겹침주의.html", "news/지방의대경쟁률-상승분석.html");

for my $f (@files) {
  open(my $fh, "<:encoding(UTF-8)", $f) or die $!;
  local $/; my $c = <$fh>; close $fh;

  $c =~ s{https://gwangju-tutoring\.co\.kr}{https://daegu-tutoring.co.kr}g;
  $c =~ s{gwangju-tutoring\.co\.kr}{daegu-tutoring.co.kr}g;
  $c =~ s/전남광주/대구/g;

  my $old_nav = q(    <a href="../index.html" class="nav-link">홈</a>
    <a href="../index.html#about" class="nav-link">수업 방식</a>
    <a href="../gwangju-academy-finder.html" class="nav-link">학원도 함께 보기</a>
    <a href="../검정고시-과외.html" class="nav-link">검정고시 과외</a>
    <a href="../국제학교-과외.html" class="nav-link">국제학교 과외</a>
    <a href="../gwangju-regions.html" class="nav-link">지역별 과외 안내</a>
    <a href="../news.html" class="nav-link active">입시뉴스</a>
    <a href="../reviews.html" class="nav-link">후기</a>);
  my $new_nav = q(    <a href="../index.html" class="nav-link">홈</a>
    <a href="../index.html#about" class="nav-link">수업 방식</a>
    <a href="../daegu-regions.html" class="nav-link">지역별 과외 안내</a>
    <a href="../daegu-academy-finder.html" class="nav-link">대구 학원 찾기</a>
    <a href="../news.html" class="nav-link active">입시뉴스</a>
    <a href="../reviews.html" class="nav-link">후기</a>);
  my $cnt = () = $c =~ /\Q$old_nav\E/g;
  if ($cnt == 1) { $c =~ s/\Q$old_nav\E/$new_nav/; }
  else { print "WARN [$f] nav block count=$cnt\n"; }

  open(my $out, ">:encoding(UTF-8)", $f) or die $!;
  print $out $c;
  close $out;
  print "adapted: $f\n";
}

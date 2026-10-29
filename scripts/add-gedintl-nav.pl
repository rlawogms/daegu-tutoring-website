use strict; use warnings;
use utf8; binmode STDOUT, ":encoding(UTF-8)";

my @root_files = ("index.html", "consult.html", "reviews.html", "daegu-regions.html", "daegu-academy-finder.html", "news.html");
my @news_files = glob("news/*.html");

sub process {
  my ($f, $prefix) = @_;
  open(my $fh, "<:encoding(UTF-8)", $f) or die $!;
  local $/; my $c = <$fh>; close $fh;
  my $orig = $c;

  # already has it? skip
  if ($c =~ /검정고시-과외\.html/) { return; }

  my $count = ($c =~ s{(<a href="\Q$prefix\Edaegu-academy-finder\.html" class="nav-link[^"]*">대구 학원 찾기</a>\n)}
                       {$1    <a href="${prefix}검정고시-과외.html" class="nav-link">검정고시 과외</a>\n    <a href="${prefix}국제학교-과외.html" class="nav-link">국제학교 과외</a>\n}g);

  if ($count) {
    open(my $out, ">:encoding(UTF-8)", $f) or die $!;
    print $out $c;
    close $out;
    print "fixed: $f\n";
  } else {
    print "WARN no match: $f\n";
  }
}

for my $f (@root_files) { process($f, ""); }
for my $f (@news_files) { process($f, "../"); }

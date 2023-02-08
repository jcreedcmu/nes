#!/usr/bin/perl

while (<>) {
  chomp;
  s/#.*//;
  push @info, split;
  last if @info >= 4;
}

my ($P, $w, $h, $max) = @info;
die unless $P eq "P6";
die unless $max eq "255";
die unless $w eq "256";
die unless $h eq "224";

{local $/; $data = <>}

$ccounter = 0;
%colors = ();

my @rawdata = unpack "C*", $data;
for $y (0..223) { # 224 pixels down
  for $x (0..255) { # 256 pixels across
    my $rgb = join " ", splice @rawdata, 0, 3;
    my $cindex = $colors{$rgb};
    $cindex = $colors{$rgb} = $ccounter++ unless defined $cindex;
    $data[$y][$x] = $cindex;
  }
}

for (sort {$colors{$a} <=> $colors{$b}} keys %colors) {
  print "color $colors{$_} = $_\n"
}

$tcounter = 0;
%tiles = ();


for $yt (0..27) { # 28 tiles down
  for $xt (0..31) { # 32 tiles across
    my $tile = join "\n", map {
      my $y = $_;
      join " ", map {
	my $x = $_;
	$data[$y + $yt * 8][$x + $xt * 8]
      } (0..7)
    } (0..7); # y
    my $tindex = $tiles{$tile};
    $tindex = $tiles{$tile} = $tcounter++ unless defined $tindex;
    $chrdata[$yt][$xt] = $tindex;
  }
}

for (sort {$tiles{$a} <=> $tiles{$b}} keys %tiles) {
  print "tile $tiles{$_} =\n$_\n"
}

print "chrdata =\n";
print map {
  (join "", map {sprintf "% 4d", $_} @{$chrdata[$_]}) . "\n"
} (0..27);

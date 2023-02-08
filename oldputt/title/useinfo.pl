#!/usr/bin/perl

if ($ARGV[0] eq "-pattern") { # pattern table data
  shift;
  $pattern = 1;
}
elsif ($ARGV[0] eq "-name") { # name table data
  shift;
  $name = 1;
}

# defaults to outputting a ppm of the whole image

while (<>) {
  chomp;
  if (/color (\w+) = (\d+) (\d+) (\d+)/) {
    $colors{$1} = [$2, $3, $4];
    if ($1 > $maxcolor) { $maxcolor = $1 }
  }
  elsif (/tile (\w+) =/) {
    my $tindex = $1;
    my $tile = [];
    for (0..7) {
      my $line = <>;
      push @$tile, [split " ", $line];
    }
    $tiles{$tindex} = $tile;
  }
  elsif (/chrdata =/) {
    @chrdata = ();
    for (0..27) { # 28 tiles down
      my $line = <>;
      $chrdata[$_] = [split " ", $line];
    }
  }
}

if ($name) {
  print pack "C*", map {@$_} @chrdata;
  exit;
}

$components = 3;

if ($pattern) {
  $components = 1; # grayscale
  @chrdata = map {[$_*8..$_ * 8+7]} (0..31);
  $colors{0} = [0];
  for (1..$maxcolor) {
    $colors{$_} = ([85],
		   [170],
		   [255])[($_-1) % 3];
  }
}

my $h = 8 * @chrdata;
my $w = 8 * @{$chrdata[0]};

for $y (0..$h-1) {
  for $x (0..$w-1) {
    my $tindex = $chrdata[$y >> 3][$x >> 3];
    my $tile = $tiles{$tindex};
    my @add = @{$colors{$tile->[$y & 7][$x & 7]}};
    if (@add != $components) {
      # warn "can't look up pixel ($x, $y) (tile $tindex)\n";
      @add = (0) x $components;
    }
    push @rawdata, @add;
  }
}

if ($pattern) {
  print "P5 $w $h 255\n";
}
else {
  print "P6 $w $h 255\n";
}
print pack "C*", @rawdata;


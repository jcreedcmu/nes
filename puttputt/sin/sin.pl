#!/usr/bin/perl

print "sin_tab:\n";

for (0..255) {
  push @s, int(0.5 + 127 * sin(2 * 3.1415926535 * $_ / 256));
}
while (@a = splice(@s, 0, 8)) {
  for (@a) {
    $_ += 256 if $_ < 0;
  }
  print " .db ", (join ", ", @a), "\n";
}


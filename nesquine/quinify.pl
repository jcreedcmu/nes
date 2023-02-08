#!/usr/bin/perl

print "q:\n";
for (<>) {
  for (split //) {
    print " .db ", ord, "\n";
  }
}
print " .db 0\n";

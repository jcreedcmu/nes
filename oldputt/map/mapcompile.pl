#!/usr/bin/perl

for (0..31) { # invisible row
  print chr(0);
}

while (<>) {
  for (split) {
    if (/[1-9]/) {
      print chr(32 + $_);
    }
    if (/[a-j]/) {
      print chr(32 + 10 + ord() - ord("a"));
    }
    if (/[A-Z]/) {
      print chr(65 + ord() - ord("A"));
    }
    if (/\./) {
      print chr(32);
    }
    if (/x/) {
      print chr(0);
    }
    if (/o/) {
      print chr(1);
    }

  }
}

for (0..31) { # invisible row
  print chr(0);
}

for (0..59) { # attribute table
  print chr(0);
}

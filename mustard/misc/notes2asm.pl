#!/usr/bin/perl

sub pitchtofreq {
  my ($p) = @_;
  my $freq = 440 * (2 ** ($p / 12));
  my $b = (1.79e6 / 16) / $freq;
  int($b)
}

sub durtodelay {
  $_[0];
}

while (<>) {
  chomp;
  my @n = split;
  if ($n[0] eq "BEGIN_REPEAT") {
    print "repeat:\n\there\n";
    next
  }
  if ($n[0] eq "END_REPEAT") {
    print "\tjmp repeat\n";
    next
  }
  if ($n[0] eq "BEGIN_SONG") {
    print "pat_$n[1]\t.macro\n\there\n";
    next
  }
  if ($n[0] eq "END_SONG") {
    print "\t.endm\n\n";
    next
  }
  if ($n[0] eq "NOTE") {
    my ($f, $d) = (pitchtofreq($n[2]), durtodelay($n[1]));
    print "\tmf noted, $f, $d\n";
    next
  }
  if ($n[0] eq "REST") {
    my ($d) = (durtodelay($n[1]));
    print "\tmf rest, $d\n";
    next
  }
  if ($n[0] eq "SPECIAL") {
    my ($d) = (durtodelay($n[1]));
    print "\tmf special$n[2], $d\n";
    next
  }

}

#!/usr/bin/perl

%pitch_table =
  (
   "C" => 3,
   "D" => 5,
   "E" => 7,
   "F" => 8,
   "G" => 10,
   "A" => 12,
   "B" => 14,
   "c" => 15,
   "d" => 17,
   "e" => 19,
   "f" => 20,
   "g" => 22,
   "a" => 24,
   "b" => 26,
  );

sub nice {
  local $_ = $_[0];
  s/\s+/_/g;
  tr/A-Z/a-z/;
  s/[^_a-z0-9]//g;
  $_
}

sub vblanks {
  # input is length in "beats"
  $conv * $_[0]
}

sub set_tempo {
  my ($unit, $freq) = @_;
  $vblanksperbeat =
    59.94         # vblanks / sec
    * 60          # sec / min
    * (1 / $freq) # min
    * (1 / $unit) # 1 / whole note
}

sub parse_length_expr {
  my ($e) = @_;
  $e eq "" and return 1;
  $e eq "/" and return 1/2;
  $e =~ m(/(\d+)) and return 1/$1;
  $e =~ m((\d+)) and return $1;
  $e =~ m((\d+)/(\d+)) and return $1/$2;
  die "weird length expression '$e'"
}

sub parse_line {
  local $_ = $_[0];
  s/%.*//;
  my %acc;

  my @result;
  while ($_ =~ /\S/) {
    s/^\s+//;
    if (s/^\|://) {
      push @result, ["BEGIN_REPEAT"];
      next
    }
    if (s/^:\|//) {
      push @result, ["END_REPEAT"];
      next
    }
    if (s/^\|//) {
      %acc = ();
      next
    }
    if (s/^\"[^\"]*\"//) {
      next
    }
    if (s/^\(//) {
      push @result, ["BEGIN_TIE"];
      next
    }
    if (s/^\)//) {
      push @result, ["END_TIE"];
      next
    }
    if (s/^([_^=]?)([a-gA-G])([',]*)(\d*\/?\d*)//) {
      my ($acc, $note, $oct, $le) = ($1,$2,$3,$4);
      my $pitch = $pitch_table{$note};
      my $length = vblanks(parse_length_expr($le));
      if ($acc) {
	$acc{lc $note} = ${{"=" => 0, "^" => 1, "_" => -1}}{$acc}
      }
      defined $acc{lc $note} and $pitch += $acc{lc $note};
      for (split //, $oct) {
	$pitch += 12 * ($_ eq "," ? -1 : 1);
      }
      push @result, ["NOTE", $length, $pitch];
      next
    }
    if (s/^([h-yH-Y])(\d*\/?\d*)//) {
      my ($code, $le) = ($1,$2);
      my $length = vblanks(parse_length_expr($le));
      push @result, ["SPECIAL", $length, $code];
      next
    }

    if (s/^z(\d*\/?\d*)//) {
      my ($le) = ($1);
      my $length = vblanks(parse_length_expr($le));
      push @result, ["REST", $length];
      next
    }
    die "don't know how to parse '$_'";
  }
  @result
}

my @e;

while (<>) {
  chomp;
  if (/([A-Z])\s*:\s*(.*)/) {
    my ($k, $v) = ($1, $2);
    if ($k eq "Y") {
      # maximum division factor of a default length
      # this must come last!
      $max_div = $v;
      die unless defined $default_length;
      die unless defined $vblanksperbeat;
      $conv = $max_div * int (0.5 + $default_length * $vblanksperbeat / $max_div);
      print STDERR "conversion factor is $conv \n";
    }
    if ($k eq "Q") {
      if ($v =~ /(.*)\s*=\s*(.*)/) {
	set_tempo(parse_length_expr($1), $2);
      }
      elsif ($info{"L"}) {
	set_tempo($info{"L"}, $v);
      }
      else {
	set_tempo(1/4, $v);
      }

    }
    if ($k eq "T") {
      if ($info{"T"}) {
	push @e, ["END_SONG", nice($info{"T"})]
      }
      push @e, ["BEGIN_SONG", nice($v)]
    }
    if ($k eq "L") {
      $default_length = parse_length_expr($v);
    }
    $info{$k} = $v;
  }
  else {
    push @e, parse_line($_);
  }
}

if ($info{"T"}) {
  push @e, ["END_SONG", nice($info{"T"})]
}

my @e2;
my $n;

for (@e) {
  if ($_->[0] eq "BEGIN_TIE") {
    $tie = 1;
    next
  }
  if ($_->[0] eq "END_TIE") {
    $tie = 0;
    push @e2, $n;
    undef $n;
    next
  }
  if ($tie) {
    if (defined $n) {
      $n->[1] += $_->[1];
    }
    else {
      $n = [@$_];
    }
  }
  else {
   push @e2, [@$_];
  }
}

print map {join (" ", @$_) . "\n"} @e2;

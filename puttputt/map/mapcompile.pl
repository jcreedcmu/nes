#!/usr/bin/perl

my $name = $ARGV[0];
$name =~ s/\.map//;
$name =~ s/.*\///;

for (0..31) { # invisible row
  push(@b, 32);
}

while (<>) {
  for (split) {
    if (/[1-9]/) {
      push(@b, 32 + $_);
    }
    if (/[a-j]/) {
      push(@b, 32 + 10 + ord() - ord("a"));
    }
    if (/[A-Z]/) {
      push(@b, 65 + ord() - ord("A"));
    }
    if (/\./) {
      push(@b, 32);
    }
    if (/x/) {
      push(@b, 0);
    }
    if (/o/) {
      push(@b, 1);
    }

  }
}

for (0..31) { # invisible row
  push(@b, 32);
}

for (0..59) { # attribute table
  push(@b, 0);
}

# my $last;
# my $count = 0;

# for (@b) {
#   if ($count == 0) {
#     $count = 1;
#     $last = $_;
#   }
#   elsif ($count == 255) {
#     push @rle, $count, $last;
#     $count = 0;
#     redo
#   }
#   elsif ($_ == $last) {
#     $count++;
#   }
#   else {
#     push @rle, $count, $last;
#     $count = 0;
#     redo
#   }
# }

# push @rle, $count, $last, 0;

@data = @b;
# @data = @rle;



print "mapdata_${name}_start:\n";
while (@data) {
  my (@a) = splice @data, 0, 8;
  print "\t.db ", join(", ", @a), "\n";
}
print "mapdata_${name}_end:\n";


use strict;
use warnings;
use Fcntl qw(O_RDWR SEEK_SET);

use constant YEAR_VALUE_START => 2100;
use constant YEAR_POS         => 0x036c;

sub patch_save {
  my ($save_filename, $year) = @_;

  if (not defined $save_filename) { die "no save filename" }
  if (not defined $year) { die "no target year" }
  if ($year =~ /\D/) { die "target year is non-numeric" }
  if ($year < YEAR_VALUE_START) { die "target year is less than " . YEAR_VALUE_START }

  $year -= YEAR_VALUE_START;
  my $year_le_short = pack('v', $year);

  sysopen(my $save_fh, $save_filename, O_RDWR) or die "can't open $save_filename: $!";
  binmode($save_fh) or die $!;
  seek($save_fh, YEAR_POS, SEEK_SET) or die $!;
  syswrite($save_fh, $year_le_short, 2) or die $!;
  close($save_fh) or die $!;

  print "All done.\n";
  return 1;
}

patch_save(@ARGV);

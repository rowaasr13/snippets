# Adds print("line N") after each function definition.
# Very naive pattern matching, no more than one definition per line.

use strict;
use warnings;

while (defined (my $line = <>)) {
    if ($line =~ /^(.*)(function[^(]*?\([^)]*?\))(.*)$/s) {
        print "$1$2 print('line $.') $3";
    } else {
        print $line;
    }
}

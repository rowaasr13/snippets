# git hash-object __FILE__ equivalent

require Digest::SHA1;

open(my $fh, '<:raw', __FILE__) or die $!;

my $sha1 = Digest::SHA1->new;

$sha1->add('blob ');
$sha1->add(-s $fh);
$sha1->add("\x00");
$sha1->addfile($fh);
close($fh);

STDOUT->say($sha1->hexdigest);

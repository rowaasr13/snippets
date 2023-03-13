# git hash-object __FILE__ equivalent
use strict;
use warnings;
use utf8;

# utf8 тест

sub with_FILE {
    require Digest::SHA1;

    open(my $fh, '<:raw', __FILE__) or die $!;

    my $sha1 = Digest::SHA1->new;

    $sha1->add('blob ');
    $sha1->add(-s $fh);
    $sha1->add("\x00");
    $sha1->addfile($fh);
    close($fh);

    STDOUT->say($sha1->hexdigest);
}

sub with_DATA {
    require Digest::SHA1;
    require Fcntl;

    my $fh = \*DATA;
    unless (ref $fh eq 'GLOB') { return } # if there's no actual __DATA__ token in file, there will be no glob

    my $sha1 = Digest::SHA1->new;

    my $whence = $fh->tell();
    $fh->seek(0, Fcntl::SEEK_SET());
    $sha1->add('blob ');
    $sha1->add(-s $fh);
    $sha1->add("\x00");
    $sha1->addfile($fh);
    $fh->seek($whence, Fcntl::SEEK_SET());

    STDOUT->say($sha1->hexdigest);
}

sub with_git {
    system('git', 'hash-object', __FILE__);
}

with_FILE();
with_DATA();
with_git();

__DATA__

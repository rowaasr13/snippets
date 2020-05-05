use strict;
use warnings;
use Capture::Tiny qw(capture);
use File::Spec::Functions qw(catfile);
use File::Temp;

my $git_config = catfile('.git', 'config');

sub main {
    check_if_we_are_in_git_repo();
    check_git_version() or exit(1);
    check_plink_version();
    try_plink_connect();
    patch_git_config();

    print "All done.\n";
    exit(0);
}

sub check_if_we_are_in_git_repo {
    if (-w $git_config) { return 1 }

    return
}

sub check_git_version {
    my ($stdout, $stderr, $exit) = capture {
        system('git', '--version')
    };

    unless ($stdout =~ /^git version (\d+)\.(\d+)/) { return }
    if ($1 >= 2 and $2 >= 10) { return 1 }

    return
}

sub check_plink_version {

}

sub try_plink_connect {

}

sub patch_git_config {
    # TODO: if there's no changes, don't overwrite old config

    my $in;
    unless(open($in, '<', $git_config)) { return }

    my $tmp_out = File::Temp->new(
        TEMPLATE => 'config.new.XXXXXXXXXX',
        DIR => '.git',
        SUFFIX => '.tmp'
    );

    my $url;

    my $current_section = '';
    while (my $line = <$in>) {
        my ($key, $val);
        if ($line =~ /^\[(.+)\]$/) {
            $current_section = $1;
        } elsif ($line =~ /^\s*(\S+)\s*=\s*(\S.+)/) {
            ($key, $val) = ($1, $2);
        }

        if ($current_section eq 'remote "origin"' and $key and $key eq 'url') {
            $url = $val;
            next;
        }
        if ($current_section eq 'user' and $key and $key eq 'email') { next }
        if ($current_section eq 'user' and $key and $key eq 'name') { next }
        if ($current_section eq 'core' and $key and $key eq 'sshCommand') { next }

        $tmp_out->print($line);
    }

    $url =~ m!^(?:https://github\.com/|git\@github\.com:)([^/]+)/(.+)!;
    my ($user, $repo) = ($1, $2);
    $repo =~ s/\.git$//;

    $tmp_out->print(map { $_, "\n" } (
        '[remote "origin"]',
        "   url = git\@github.com:$user/$repo.git",
        '[user]',
        "   email = rowaasr13\@gmail.com",
        "   name = (rowaasr13) Oleg V. Volkov",
        '[core]',
        "   sshCommand = C:/bin/PuTTY/PLINK.EXE -v",
    ));

    close($in);
    close($tmp_out);
    rename($tmp_out, $git_config) or die "rename: $!";

    return 1;
}

main();
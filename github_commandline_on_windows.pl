use strict;
use warnings;
use Capture::Tiny qw(capture);
use File::Spec::Functions qw(catfile);
use File::Temp;
use Win32::Console::ANSI;
use Term::ANSIColor qw(colored);

my $git_config = catfile('.git', 'config');

sub do_steps_array {
    my $steps = shift;

    my $env = {};

    for (my $idx = 0; $idx < scalar(@$steps); $idx += 2) {
        my ($name, $sub) = @{$steps}[$idx, $idx + 1];

        my ($res, $message) = $sub->($env);
        if (defined $res) {
            print '[', colored(' OK ', 'green'), "] $name\n";
        } elsif ($message and $message eq 'TODO') {
            print '[', colored('TODO', 'white'), "] $name\n";
        } else {
            print '[', colored('FAIL', 'red'  ), "] $name\n";
            exit(($idx / 2) + 1);
        }
    }
}

sub main {
    do_steps_array([
        check_if_we_are_in_git_repo => \&check_if_we_are_in_git_repo,
        check_git_version           => \&check_git_version,
        read_json_config            => \&read_json_config,
        check_plink_version         => \&check_plink_version,
        try_plink_connect           => \&try_plink_connect,
        patch_git_config            => \&patch_git_config,
    ]);

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

sub read_json_config {
    my $env = shift;

    use FindBin qw($Bin $Script);
    use JSON qw(decode_json);
    my $json_config = $Script;
    $json_config =~ s/\.pl$/.json/i;
    $json_config = catfile($Bin, $json_config);

    open(my $fh, '<:utf8', $json_config) or die;
    my $json_text;
    while (defined (my $line = <$fh>)) { $json_text .= $line }
    $env->{config} = decode_json($json_text);

    return 1;
}

sub check_plink_version {
    return undef, "TODO";
}

sub try_plink_connect {
    return undef, "TODO";
}

sub patch_git_config {
    my $env = shift;

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
        "   email = $env->{config}{user}{email}",
        "   name = $env->{config}{user}{name}",
        '[core]',
        "   sshCommand = $env->{config}{core}{sshCommand}",
    ));

    close($in);
    close($tmp_out);
    rename($tmp_out, $git_config) or die "rename: $!";

    return 1;
}

main();
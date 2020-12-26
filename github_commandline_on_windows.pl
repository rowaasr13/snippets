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
        my $need_exit;

        if (defined $res) {
            print '[', colored(' OK ', 'green'), "] ";
        } elsif ($message and $message eq 'TODO') {
            print '[', colored('TODO', 'white'), "] ";
            undef $message
        } else {
            print '[', colored('FAIL', 'red'  ), "] ";
            $need_exit = ($idx / 2) + 1;
        }

        print "$name\n";
        if (defined $message) {
            print "\t $message\n";
        }
        if ($need_exit) { exit ($need_exit) }
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

    my $in;
    unless(open($in, '<', $git_config)) { return }

    my $tmp_out = File::Temp->new(
        TEMPLATE => 'config.new.XXXXXXXXXX',
        DIR => '.git',
        SUFFIX => '.tmp'
    );

    my $current_section = '';
    my @line_parts;
    my $val_idx;
    my $changed;

    # replace existing values in-place
    while (my $line = <$in>) {
        my ($key, $val);
        if ($line =~ /^\[(.+)\]$/) {
            $current_section = $1;
            $tmp_out->print($line);
            next;
        } elsif ($line =~ /^(\s*)(\S+)(\s*=\s*)(\S.+)(\s*)$/) {
            @line_parts = ($1, $2, $3, $4, $5);
            $val_idx = 3;
            ($key, $val) = @line_parts[1, $val_idx];
        } else {
            $tmp_out->print($line);
            next;
        }

        if ($current_section eq 'remote "origin"' and $key and $key eq 'url') {
            my $url = $val;
            if ($url =~ m!^(?:https://github\.com/|git\@github\.com:)([^/]+)/(\S+)(\s*)$!) {
                my ($user, $repo, $whitespace) = ($1, $2, $3);
                $repo =~ s/\.git$//;
                $url = "git\@github.com:$user/$repo.git$whitespace";
                $env->{config}{$current_section}{$key} = $url;
            }
        }

        my $new_val;
        if (defined $env->{config}{$current_section}) {
            $new_val = delete $env->{config}{$current_section}{$key};
            if (defined($new_val) and ($new_val eq $val)) { undef $new_val }
        }

        if (defined $new_val) {
            $line_parts[$val_idx] = $new_val;
            $tmp_out->print(@line_parts);
            $changed = 1;
        } else {
            $tmp_out->print($line);
        }
    }

    close($in);

    # write additional values
    my $extra_newline_printed;
    while (my ($section, $keys) = each %{$env->{config}}) {
        unless (scalar keys %$keys) { next }

        unless ($extra_newline_printed) { $tmp_out->print("\n"); $extra_newline_printed++ }

        $tmp_out->print("[$section]\n");
        $changed = 1;
        while (my ($key, $val) = each %$keys) {
            $tmp_out->print("\t$key = $val\n");
        }
    }

    close($tmp_out);
    if ($changed) {
        rename($tmp_out, $git_config) or die "rename: $!";
    }

    return (1, "$git_config is " . ($changed ? 'changed' : 'unchanged'));
}

main();
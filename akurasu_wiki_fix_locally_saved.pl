use strict;
use warnings;
use File::Slurp;
use File::Copy;

sub monitor_replacement {
    my $real_sub = shift;

    require Data::Dumper;
    print "In: ", Data::Dumper::Dumper(\@_);
    my @out = $real_sub->(@_);
    print "Out: ", Data::Dumper::Dumper(\@out);

    return @out;
}

sub fix_css_links {
    my ($link_tag) = @_;

    if ($link_tag =~ / href="([^"]+)"/ and $1 =~ /\?/) { return '' }

    unless ($link_tag =~ / rel="stylesheet"/) { return $link_tag }

    #print "1: $link_tag\n";
    my $orig_link_tag = $link_tag;
    unless ($link_tag =~ s/ href="([^"]+_files\/[^"\\]+)"/ href="$1.css"/) { return $link_tag }
    my $orig_name = $1;
    #print "2: $link_tag $orig_name\n";
    if ($orig_name =~ /\.css$/) { return $orig_link_tag }

    copy($orig_name, $orig_name . '.css');
    return $link_tag;
}

sub fix_locally_saved {
    my ($args) = @_;

    my $content = read_file($args->{in});

    $content =~ s/(<link [^>]+?>)/fix_css_links($1)/ge;
#    $content =~ s/(<link [^>]+?>)/monitor_replacement(\&fix_css_links, $1)/ge;

    $content =~ s/$args->{pattern}/$1<script src="$args->{inject}"><\/script>$2/;

    write_file($args->{out}, $content);
}

fix_locally_saved({
    inject  => 'akurasu_wiki_only_body.js',
    pattern => qr|(</div>)(</body>)|,
    in  => 'Secrets.html',
    out => 'Secrets_clean.html',
});

fix_locally_saved({
    inject  => 'akurasu_wiki_only_body.js',
    pattern => qr|(</div>)(</body>)|,
    in  => 'Complete Chart.html',
    out => 'Complete Chart_clean.html',
});
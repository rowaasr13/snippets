package Counters;
use strict;
use warnings;

sub new {
    my ($class, $limits) = @_;

    my $self = {
        limits => $limits,
    };
    bless $self, __PACKAGE__;
    $self->reset;

    return $self;
}

sub reset {
    my ($self) = @_;

    @{$self->{data}} = (0) x scalar @{$self->{limits}};
}

sub add {
    my ($self, $digit, $value) = @_;

    my $data = $self->{data};
    my $limits = $self->{limits};

    if ($digit >= scalar @$limits) {
        $data->[$digit] += $value;
        return
    }

    my $current = $data->[$digit];
    my $limit = $limits->[$digit];
    $current += $value;

    if ($current > $limit) {
        my $remainder = $current % ($limit + 1);
        my $overflow = ($current - $remainder) / ($limit + 1);

        $data->[$digit] = $remainder;
        $self->add($digit + 1, $overflow)
    } else {
        $data->[$digit] = $current;
    }
}

sub add_iterative {
    my ($self, $digit, $value) = @_;

    my $data = $self->{data};
    my $limits = $self->{limits};

    while (1) {
        # overflow register
        if ($digit >= scalar @$limits) {
            $data->[$digit] += $value;
            last;
        }

        my $current = $data->[$digit];
        my $limit = $limits->[$digit];
        $current += $value;

        if ($current > $limit) {
            my $remainder = $current % ($limit + 1);
            my $overflow = ($current - $remainder) / ($limit + 1);

            $data->[$digit] = $remainder;
            $digit++;
            $value = $overflow;
            next;
        } else {
            $data->[$digit] = $current;
            last;
        }
    }
}


sub overflowed {
    my ($self) = @_;

    return defined $self->{data}[scalar @{$self->{limits}}];
}

my $obj = __PACKAGE__->new([1, 2, 3, 4, 5]);

# use Data::Dumper; warn Dumper $obj;

# $obj->add(0, 5);

# use Data::Dumper; warn Dumper $obj;

while (not $obj->overflowed) {
    print(join("  ", @{$obj->{data}}), "\n");
    $obj->add(0, 1);
}
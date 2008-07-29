package Hash::RubyLike;
use strict;
use warnings;
use Carp qw(croak);

our $VERSION = '0.01';

### TODO
# リファンスじゃないハッシュもとれるように
# ハッシュの中のハッシュを再帰的にこのクラスでblessする

sub new {
    my ($class, $hash) = @_;
    bless $hash || {}, $class;
}

sub clear {
    my $self = shift;
    $self->each_key(
        sub {
            my $key = shift;
            $self->delete($key);
        }
    );
    $self;
}

sub delete {
    my ($self, $key) = @_;
    delete $self->{$key};
}

sub dup {
    my $self = shift;
    my $class = ref $self;
    $class->new({ map { $_ => $self->{$_} } keys %$self});
}

*clone = \&dup;

sub each {
    my ($self, $code) = @_;
    croak q{Coderef must be passed in}
        if ref $code ne 'CODE';
    while (my ($key, $value) = CORE::each %$self) {
        $code->($key, $value);
    }
    $self;
}

sub each_key {
    my ($self, $code) = @_;
    croak q{Coderef must be passed in}
        if ref $code ne 'CODE';
    for my $key (keys %$self) {
        $code->($key);
    }
    $self;
}

sub is_empty {
    my $self = shift;
    !!!(keys %$self);
}

### TODO
# リファンスじゃないハッシュもとれるように

sub store {
    my $self = shift;
    croak "You gave me odd numbers of arguments"
        if @_ % 2;
    my %hash = @_;
    while (my ($key, $value) = CORE::each %hash) {
        $self->{$key} = $value;
    }
    $self;
}

1;

__END__

=head1 NAME

Hash::RubyLike - A Perl extension for blah, blah, blah...

=head1 SYNOPSIS

  use Hash::RubyLike;

  my $obj = Hash::RubyLike->new($args);
  my $res = $obj->foo($args);

=head1 DESCRIPTION

Hash::RubyLike is  blah, blah, blah...

=head1 METHODS

=head2 new ( I<$args> )

=over 4

  my $obj = Hash::RubyLike->new($args);

Creates and returns a new Hash::RubyLike object.

=back

=head2 foo ( I<$args> )

=over 4

  my $res = $obj->foo($args);

Description for the method here.

=back

=head1 SEE ALSO

=over 4

=item * item

Desctiption for the item above.

=back

=head1 AUTHOR

Kentaro Kuribayashi E<lt>antipop@hatena.ne.jpE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

package Test::Hash::RubyLike;
use strict;
use warnings;
use base qw(Test::Class Class::Accessor::Fast);
use Test::More;
use Test::Exception;
use Hash::RubyLike;

__PACKAGE__->mk_accessors(qw(hash hash_with_opt));

sub startup : Tests(startup => 1) {
    my $self = shift;
    my $hash = Hash::RubyLike->new({
        foo => 'foo',
        bar => 'bar',
    });
    isa_ok ($hash, 'Hash::RubyLike');
    $self->hash($hash);
}

sub clear : Tests {
    my $self  = shift;
    my $dup   = $self->hash->dup;
    my $clear = $dup->clear;
    isa_ok ($clear, 'Hash::RubyLike');
    is ($dup, $clear);
    ok (!(keys %$dup));
}

sub clone : Tests {
    my $self = shift;
    my $copy = $self->hash;
    is ($self->hash, $copy);
    my $dup  = $self->hash->clone;
    isnt ($self->hash, $dup);
    is_deeply ($self->hash, $dup);
}

sub delete : Tests {
    my $self = shift;
    my $dup  = $self->hash->dup;
    $dup->{to_be_deleted} = 'to_be_deleted';
    is ($dup->{to_be_deleted}, 'to_be_deleted');
    my $deleted = $dup->delete('to_be_deleted');
    ok (!$dup->{to_be_deleted});
    is ($deleted, 'to_be_deleted');
}

sub dup : Tests {
    my $self = shift;
    my $copy = $self->hash;
    is ($self->hash, $copy);
    my $dup  = $self->hash->dup;
    isnt ($self->hash, $dup);
    is_deeply ($self->hash, $dup);
}

sub each : Tests {
    my $self = shift;
    my $hash = {};
    my $ret  = $self->hash->each(
        sub {
            my ($key, $value) = @_;
            $hash->{$key} = $value;
        }
    );
    is_deeply ($self->hash, $hash);
    isa_ok ($ret, 'Hash::RubyLike');
}

sub each_key : Tests {
    my $self = shift;
    my $keys = [];
    my $ret  = $self->hash->each_key(
        sub {
            my $key = shift;
            push @$keys, $key;
        }
    );
    is_deeply ([keys %{$self->hash}], $keys);
    isa_ok ($ret, 'Hash::RubyLike');
}

sub is_empty : Tests {
    my $self = shift;
    my $dup  = $self->hash->dup;
    delete $dup->{$_} for keys %$dup;
    ok ($dup->is_empty);
}

sub store : Tests {
    my $self = shift;
    my $dup  = $self->hash->dup;
    my $ret  =  $dup->store(baz => 'baz', qux => 'qux');
    is ($dup->{baz}, 'baz');
    is ($dup->{qux}, 'qux');
    is ($dup, $ret);
    isa_ok ($ret, 'Hash::RubyLike');
    dies_ok { $dup->store('hoge', fuga => 'fuga') };
}

__PACKAGE__->runtests;

1;

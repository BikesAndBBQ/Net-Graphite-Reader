package Net::Graphite::Reader;
use Moose;
use namespace::autoclean;
our $VERSION = '0.01';

use MooseX::Types::Moose qw(:all);
use MooseX::Types::URI qw(Uri);

use Furl;
use JSON qw(decode_json);
use MIME::Base64 qw(encode_base64);

=head1 NAME

Net::Graphite::Reader - Access to Graphite's raw data

=head1 ATTRIBUTES

=head2 uri

=cut

has 'uri' => (
  is       => 'ro',
  isa      => Uri,
  coerce   => 1,
  required => 1,
);


=head2 username

=cut

has 'username' => (
  is        => 'ro',
  isa       => Str,
  predicate => '_has_username',
);


=head2 password

=cut

has 'password' => (
  is        => 'ro',
  isa       => Str,
  predicate => '_has_password',
);


=head2 furl

=cut

has 'furl' => (
  is      => 'ro',
  isa     => 'Furl',
  lazy    => 1,
  default => sub {
    my ($self) = @_;
    my %parms = ( timeout => 120 );
    if ( $self->_has_username || $self->_has_password ) {
      $parms{headers} = [
        Authorization => 'Basic ' . encode_base64(join(':',
          $self->_has_username ? $self->username : '',
          $self->_has_password ? $self->password : '',
        )),
      ];
    }
    Furl->new(%parms);
  },
);


=head1 METHODS

=head2 get

=cut

sub get {
  my ($self,$args) = @_;

  my $uri = $self->uri->clone;
  $uri->query_form({
    %$args,
    format => 'json',
  });

  my $res = $self->furl->get($uri);
  die $res->status_line unless $res->is_success;

  return decode_json($res->content);
}

__PACKAGE__->meta->make_immutable;

1;

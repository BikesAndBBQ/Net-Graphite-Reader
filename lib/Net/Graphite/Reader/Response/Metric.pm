package Net::Graphite::Reader::Response::Metric;
use Moose;
use namespace::autoclean;

=head1 NAME

Net::Graphite::Reader::Response::Metric - The data for a single metric

=head1 ATTRIBUTES

=head2 target 

The target of the metric

=cut

has 'target' => (
  is       => 'ro',
  isa      => 'Str',
  required => 1,
);

=head2 datapoints

The raw data for this metric returned from Graphite.

=cut

has 'datapoints' => (
  is => 'ro',
  isa => 'ArrayRef',
  traits => ['Array'],
  handles => {
    all_datapoints => 'elements',
  }
);

=head1 METHODS

=head2 non_null_data_points

Return the data points for which Graphite has a value.

=cut

sub non_null_data_points {
  my $self = shift;

  my @metrics = grep { defined $_->[0] } $self->all_datapoints;

  return wantarray ? @metrics : \@metrics;
}

__PACKAGE__->meta->make_immutable;

1;

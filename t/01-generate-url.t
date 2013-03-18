use strict;
use warnings;

use Test::Most;
use Test::MockObject::Extends;

use Net::Graphite::Reader;

my $reader = Net::Graphite::Reader->new(
  uri => 'http://example.com'
);

# Single metric
{
  my $uri = $reader->_build_query_uri({
    target => ['this.is.my.test.metric'],
    from   => '-24hours',
    until  => 'now',
  });

  cmp_ok(
    $uri,
    'cmp',
    'http://example.com/render?from=-24hours&until=now&target=this.is.my.test.metric&format=json',
    'URI for single metric'
  );
}

# Multiple metrics
{
  my $uri = $reader->_build_query_uri({
    target => ['this.is.my.first.metric','this.is.my.second.metric'],
    from   => '-24hours',
    until  => 'now',
  });

  cmp_ok(
    $uri,
    'cmp',
    'http://example.com/render?from=-24hours&until=now&target=this.is.my.test.metric' .
      '&&target=this.is.my.second.metric&format=json',
    'URI for single metric'
  );
}

done_testing();

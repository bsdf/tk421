package twit;
use secrets;
use warnings;
use strict;

use base 'Exporter';

our @EXPORT = qw( $nt );

use Net::Twitter;

our $nt = Net::Twitter->new(
    traits              => [qw/API::REST OAuth/],
    consumer_key        => "c5d1PoYsSoJgFHg5fpsarw",
    consumer_secret     => $secrets{consumer},
    access_token        => "14114455-GSCc80UdJtDQY07tGV5QrIlMejPOg3Ex8o3V6fkI",
    access_token_secret => $secrets{access_token},
);

1;

package twit;

use base 'Exporter';
use secrets;
use Net::Twitter;

our @EXPORT = qw( $nt );

our $nt = Net::Twitter->new(
    traits              => [qw/API::REST OAuth/],
    consumer_key        => "c5d1PoYsSoJgFHg5fpsarw",
    consumer_secret     => $secrets{consumer},
    access_token        => "14114455-GSCc80UdJtDQY07tGV5QrIlMejPOg3Ex8o3V6fkI",
    access_token_secret => $secrets{access_token},
);

1;

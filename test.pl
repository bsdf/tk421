use strict;
use warnings;

use Tk;
use Tk::HList;

my $mw = MainWindow->new();
my $hl = $mw->Scrolled( "HList",
	-scrollbars => 'ow',
)->pack(
	-fill   => 'both',
	-expand => 1,
);

for ( 0..10 ) {
	add_item( $_ );
}

add_item( "asdf\n\nasdf" );

sub add_item {
	my $fr = $hl->Frame()->pack( -expand => 1, -fill => 'x' );
	my $img = $fr->Photo( -file => "$ENV{HOME}/icon.gif" );
	$fr->Label(
		-image => $img,
	)->pack( -side => 'left' );

	$fr->Label(
		-relief => 'raised',
		-borderwidth => 2,
		-text => $_,
	)->pack( -side => 'top', -anchor => 'w', -fill => 'x', -expand => 1 );

	$fr->Label(
		-text => "\@bsdf",
	)->pack( -side => 'bottom', -anchor => 'w' );


	$hl->add( $_,
		-itemtype => 'window',
		-window   => $fr,
	);
}

MainLoop();

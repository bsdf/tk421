use warnings;
use strict;
use secrets;

use Tk;
use Tk::HList;
use Tk::ItemStyle;
use Tk::Dialog;
use Net::Twitter;

my $nt = Net::Twitter->new(
    traits              => [qw/API::REST OAuth/],
    consumer_key        => "c5d1PoYsSoJgFHg5fpsarw",
    consumer_secret     => $secrets{consumer},
    access_token        => "14114455-GSCc80UdJtDQY07tGV5QrIlMejPOg3Ex8o3V6fkI",
    access_token_secret => $secrets{access_token},
);

my $mw = MainWindow->new( -title => 'tX11tter');
$mw->geometry( "320x500" );

my $frame = $mw->Frame(
    -relief      => 'raised',
    -borderwidth => 2,
)->pack( -fill => 'x' );

my $txt = $frame->Text(
    -height => 4,
    -wrap   => 'word',
);

setup_tags();

$txt->bind( '<KeyRelease>', \&text_highlight );

$txt->pack( -side => 'left', -expand => 1, -fill => 'x' );

$frame->Button(
    -text    => 'post',
    -command => \&post_tweet,
)->pack( -side => 'right', -fill => 'both' );


my $hl  = $mw->Scrolled( 'HList', 
    -scrollbars => 'ow',
    -width      => 80,
)->pack(
    -fill   => 'both',
    -expand => 1,
);

my $style = $hl->ItemStyle(
    "text",
    -foreground => "red",
    -background => "green",
    -font       => "Times 24",
);

my $tweet_style = $hl->ItemStyle(
    "imagetext",
    -wraplength => 240,
    -font       => 'Courier -12',
);

my $img = $mw->Photo( -file => "icon.gif" );

get_timeline();

MainLoop();




sub get_timeline {
    eval {
#    	my $statuses = $nt->user_timeline({ screen_name => 'A_b_S_t_R_a_C_t' }); 
        my $statuses = $nt->friends_timeline();
        for my $status ( @$statuses ) {
        	my $id   = $status->{id};
            my $user = $status->{user};
            my $txt  = "$status->{text}\n\@$user->{screen_name}";

            $hl->add(        $id,
                -text     => $txt,
                -itemtype => 'imagetext',
                -image    => $img,
                -style    => $tweet_style,
            );
        }
    };
}

sub post_tweet {
    my $tweet = $txt->get( "1.0", "end" );
	$nt->update({ status => $tweet });
}

sub highlight_pattern {
    my ($pattern, $tag) = @_;

    $txt->tagRemove( $tag, "1.0", "end" );

	$txt->FindAll(
		-regex,
		-nocase,
		$pattern
	);

    if ( $txt->tagRanges('sel') ) {
        my %startfinish = $txt->tagRanges( 'sel' );

        foreach ( sort keys %startfinish ) {
            $txt->tagAdd( $tag, $_, $startfinish{$_} );
        }

        $txt->tagRemove( "sel", "1.0", "end" );
    }
}

sub setup_tags {
    $txt->configure( -cursor => 'left_ptr' );

    $txt->tagConfigure( "atmention",
        -relief      => 'raised',
        -borderwidth => 1,
		-foreground  => 'blue',
    );

    $txt->tagBind(
        'atmention',
        '<ButtonPress>',
        \&username_clicked,
    );

    add_mouseover( 'atmention', 'arrow' );


    $txt->tagConfigure( "hashtag",
        -relief      => 'sunken',
        -borderwidth => 1,
		-foreground  => 'gray60',
    );

    add_mouseover( 'hashtag', 'X_cursor' );
}

sub add_mouseover {
    my ($tag, $enter) = @_;

    $txt->tagBind(
        $tag,
        '<Enter>',
        sub { $txt->configure( -cursor => $enter ); }
    );

    $txt->tagBind(
        $tag,
        '<Leave>',
        sub { $txt->configure( -cursor => 'left_ptr' ); }
    );
}

sub text_highlight {
	highlight_pattern( '\@[^\s]+', 'atmention' );
	highlight_pattern( '#[^\s]+', 'hashtag' );
}

sub username_clicked {
    print "username clicked\n";
}

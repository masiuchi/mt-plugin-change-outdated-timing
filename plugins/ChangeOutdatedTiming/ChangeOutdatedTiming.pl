package MT::Plugin::ChangeOutdatedTiming;
use strict;
use warnings;
use base 'MT::Plugin';

use MT::Session;

our $NAME = ( split /::/, __PACKAGE__ )[-1];
our $VERSION = '0.01';

my $plugin = __PACKAGE__->new(
    {   name        => $NAME,
        id          => lc $NAME,
        key         => lc $NAME,
        version     => $VERSION,
        author_link => 'https://github.com/masiuchi',
        plugin_link =>
            'https://github.com/masiuchi/mt-plugin-change-outdated-timing',
        description => 'Change outdated timing of MT user.',
        registry    => { callbacks => { take_down => \&_take_down, }, },
    }
);
MT->add_plugin($plugin);

sub _take_down {
    my $app = MT->app();

    my $user = $app->user();
    if ($user) {
        my $user_id = $user->id();
        my @sess = MT::Session->load(
            { kind => 'US' },
            { sort => 'start', direction => 'descend' },
        );

        my @grep_sess = grep { $_->get( 'author_id' ) == $user_id } @sess;

        if ( @grep_sess ) {
            my $sess = $grep_sess[0];

            $sess->start(time);
            $sess->update();
        }
    }
}

1;
__END__

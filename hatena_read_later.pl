use strict;
use WebService::Hatena::Bookmark::Lite;
use Data::Dumper::Concise;
use XML::LibXML;
use utf8;
use Encode;
use Net::Twitter::Lite;

my $hatena_conf = require 'conf/hatena_config.pl';

my $bookmark = WebService::Hatena::Bookmark::Lite->new(
    username => $hatena_conf->{username},
    password => $hatena_conf->{password}
);

my $feed = $bookmark->getFeed;
my @entries = $feed->entries;
my $entry = {};
my ($hatena_bookmark_tag,$title,$url);

while (1) {
    $entry = @entries[rand(20)];
    my $dc = XML::Atom::Namespace->new(dc => 'http://purl.org/dc/elements/1.1/');
    $hatena_bookmark_tag = decode('UTF-8',$entry->get($dc, 'subject'));
    $title = $entry->title;
    $url   =$entry->link()->href;
    last if $hatena_bookmark_tag eq 'あとで読む';
}
my $twitter_conf = require 'conf/twitter_config.pl';
my $nt = Net::Twitter::Lite->new(
    consumer_key    => $twitter_conf->{ consumer_key },
    consumer_secret => $twitter_conf->{ consumer_secret },
    ssl             => 1,
);

$nt->access_token( $twitter_conf->{access_token} );
$nt->access_token_secret( $twitter_conf->{access_token_secret} );

my $result = eval { $nt->update(decode('UTF-8',$title) . " " . $url ) };

warn "$@\n" if $@;






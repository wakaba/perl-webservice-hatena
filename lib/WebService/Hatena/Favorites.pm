package WebService::Hatena::Favorites;
use strict;
use warnings;
our $VERSION = '1.0';
use Web::UserAgent::Functions qw(http_get);
use JSON::Functions::XS qw(json_bytes2perl);

sub new {
    my $class = shift;
    return bless {@_}, $class;
}

# $service: a, d, g, s, www
sub favorites {
    my (undef, $url_name, $service) = @_;
    $service ||= 'www';
    
    my ($req, $res) = http_get
        url => sprintf q<http://%s.hatena.ne.jp/%s/favorites.json>,
            $service, $url_name;
    if ($res->is_success) {
        local $@;
        return eval {
            my $json = json_bytes2perl $res->content;
            [map { $_->{name} } @{$json->{favorites} or []}];
        } || do {
            warn $@;
            undef;
        };
    } else {
        return undef;
    }
}

# $service: s
sub friends {
    my (undef, $url_name, $service) = @_;
    $service ||= 's';
    
    my ($req, $res) = http_get
        url => sprintf q<http://%s.hatena.ne.jp/%s/friends.json>,
            $service, $url_name;
    if ($res->is_success) {
        local $@;
        return eval {
            my $json = json_bytes2perl $res->content;
            [map { $_->{name} } @{$json->{friends} or []}];
        } || do {
            warn $@;
            undef;
        };
    } else {
        return undef;
    }
}

1;

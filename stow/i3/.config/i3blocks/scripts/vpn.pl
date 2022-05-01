#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use open qw(:std :utf8);

use JSON::Parse 'parse_json';

my @openvpn = map {
    $_->{unit} =~ /^openvpn-client@(.*)\.service$/;
    $1;
} @{parse_json(`systemctl list-units --output=json --state=active 'openvpn-client@*'`)};

my @wireguard = map { s/^interface: //r } grep { m/^interface: / } split(/\n/, `sudo wg show all`);

my $prefix;
my @conns;
if (@openvpn) {
    $prefix = 'ovpn';
    @conns = @openvpn;
} elsif (@wireguard) {
    $prefix = 'wg';
    @conns = @wireguard;
}
@conns = sort @conns;

if (@conns) {
    print "歷 $prefix " . join(' ', @conns) . "\n";
    print "歷\n";
    print "#00FF00\n";
} else {
    print "轢\n";
    print "轢\n";
    print "#A0A0A0\n";
}

#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use open qw(:std :utf8);

my $sink_volume = `pamixer --get-volume`;
chomp $sink_volume;
my $sink_mute = `pamixer --get-mute`;
chomp $sink_mute;

my $source_volume = `pamixer --default-source --get-volume`;
chomp $source_volume;
my $source_mute = `pamixer --default-source --get-mute`;
chomp $source_mute;

my $sink_icon = '墳';
my $colour = "#FFFFFF";
if ($sink_mute eq 'true' || $sink_volume == 0) {
    $sink_icon = '婢';
    $colour = "#A0A0A0";
} elsif ($sink_volume <= 25) {
    $sink_icon = '奄';
} elsif ($sink_volume <= 50) {
    $sink_icon = '奔';
}

my $source_icon = '';
if ($source_mute eq 'true') {
    $source_icon = '';
}

my $default_sink = `pactl get-default-sink`;
if ($default_sink =~ /^bluez_sink/) {
    $sink_icon = " $sink_icon";
}

print "$sink_icon $sink_volume% $source_icon $source_volume%\n";
print "$sink_icon $sink_volume%\n";
print "$colour\n";

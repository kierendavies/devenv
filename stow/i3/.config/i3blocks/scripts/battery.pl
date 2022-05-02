#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use open qw(:std :utf8);

my $acpi = `acpi --battery`;
$acpi =~ /Battery \d+: (?<status>.+), (?<percentage>\d+)%(?:, (?<time_h>\d+):(?<time_m>\d+):\d+)?/;
my $status = $+{status};
my $percentage = $+{percentage};
my $time_h = ($+{time_h} || 0) + 0;
my $time_m = ($+{time_m} || 0) + 0;

my $icon = '';
my $colour = '#FFFFFF';
if ($status eq 'Discharging') {
	my @icons = qw(          );
	$icon = $icons[$percentage / 10];

    if ($percentage < 10) {
		$colour = '#FF0000';
    } elsif ($percentage < 20) {
		$colour = '#FFAE00';
    } elsif ($percentage < 30) {
		$colour = '#FFF600';
    } else {
		$colour = '#00FF00';
    }
} elsif ($status eq 'Charging') {
	# Nerd Fonts are missing some glyphs >:(
	# https://github.com/ryanoasis/nerd-fonts/issues/279
	my @icons = qw(          );
	$icon = $icons[$percentage / 10];
} elsif ($status eq 'Full') {
    $icon = '';
    $percentage = 100;
    $colour = "#A0A0A0";
}

my $time = '';
if ($time_h > 0) {
    $time = " ${time_h}h";
} elsif ($time_m > 0) {
    $time = " ${time_m}m";
}

print "$icon $percentage%$time\n";
print "$icon\n";
print "$colour\n";

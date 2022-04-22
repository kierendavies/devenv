use strict;
use warnings;

my ($selector, @targets) = @ARGV;

my $ident_re = qr/[0-9A-Za-z\-_]+/;
my $cross_ident_re = qr/[0-9A-Za-z\-_.]+/;
my $cross_inner_re = qr/$cross_ident_re(?:,$cross_ident_re)*/;
my $cross_re = qr/\[$cross_inner_re\]/;
my $segment_cross_re = qr/$ident_re$cross_re?/;
my $segment_cross_prefix_re = qr/$ident_re(?:\[(?:$cross_inner_re[,\]]?)?)?/;
my $selector_prefix_re = qr/($segment_cross_re\.)*$segment_cross_prefix_re?/;

exit 1 unless $selector =~ /^$selector_prefix_re$/;

my $re = '';
my $dot_segment_cross_re = qr/(?:\.|^)(?:$segment_cross_prefix_re$|$segment_cross_re)?/;
for my $dot_segment_cross ($selector =~ /\G$dot_segment_cross_re/g) {
    my ($dot, $segment, $cross) = ($dot_segment_cross =~ /^(\.?)($ident_re?)((?:\[$cross_inner_re?[,\]]?)?)$/);

    my $dot_re .= quotemeta($dot);

    if ($segment eq '__') {
        $re .= qr/(?:$dot_re$segment_cross_re|$cross_re)(?:\.$segment_cross_re)*/;
    } elsif ($segment eq '_') {
        $re .= qr/$dot_re$ident_re|$cross_re/;
    } else {
        $re .= $dot_re . quotemeta($segment);
    }

    if ($cross) {
        my ($opening, $inner, $closing) = ($cross =~ /^(\[)($cross_inner_re,?)(\]?)$/);

        $re .= quotemeta($opening);

        for my $comma_cross_segment ($inner =~ /\G,?$cross_ident_re?/g) {
            my ($comma, $cross_segment) = ($comma_cross_segment =~ /^(,?)($cross_ident_re?)$/);

            $re .= quotemeta($comma);

            if ($cross_segment eq '__') {
                $re .= $cross_inner_re;
            } elsif ($cross_segment eq '_') {
                $re .= $cross_ident_re;
            } else {
                $re .= quotemeta($cross_segment);
            }
        }

        $re .= quotemeta($closing);
    }
}

my %completions;
for my $target (@targets) {
    my $target_prefix = '';
    for my $segment ($target =~ /\G(?:\.?$ident_re|$cross_re)/g) {
        $target_prefix .= $segment;
        if ($target_prefix =~ /^$re(?<rest>.*)$/) {
            my $completion = $selector . $+{rest} . substr($target, length($target_prefix));
            $completions{$completion} = 1;
        }
    }
}

for my $completion (keys %completions) {
    print "$completion\n";
}

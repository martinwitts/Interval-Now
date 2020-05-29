#!usr/bin/perl

use strict;
use feature 'say';
use Test::More 'no_plan';

use lib qw(../);

use Interval::Now qw ( interval_test minute_now );
#test
require_ok( 'Interval::Now' );


#test



my %interval_list = (
    "00:00",  "11:35",
    "19:36",  "23:59",
);

my $time_in = interval_test(\%interval_list);
say $time_in;


my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $time_now = sprintf("%02d:%02d", $hour, $min);

my $minute_of_day = minute_now($time_now);
say $minute_of_day;





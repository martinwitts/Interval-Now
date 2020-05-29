use strict;
use warnings;
package Interval::Now;
=pod
=head1 NAME
Interval::Now
=head1 Author
Martin Witts
=head1 SYNOPSIS

Usage:

=head1 DESCRIPTION
 This script takes a list of time intervals from the database - format('07:00-11:00,11:01-13:00,13:01-14:00), column $schedule.
It gets split by comma and format varified, then passed into %hash and then copied to %interval_list.
It is then passed into module Interval::Now via interval_test and then returned.
Yes/No or true/false or 1/0 will be returned depending if the time now is in a set interval pair.
Intervals may be overlapped.
=cut
use strict;
use warnings;

#put 24hrs into minutes (1440), use time spans in minute spans.
use List::MoreUtils qw{ any };
use DateTime;
use DateTime::Format::Strptime;
use DateTime::Format::Duration;
use DateTime::Format::DateParse;
use feature 'say';
use Data::Dumper;
#---------------------------------------------------------------

require Exporter;
use vars       qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

# set the version for version checking
$VERSION     = 0.04;

@ISA         = qw(Exporter);
@EXPORT      = qw(&interval_test);
%EXPORT_TAGS = ( );


@EXPORT_OK   = qw($in_range $result_now $minute &minute_now &interval_test);

use vars qw(%interval_list);

my $hash_ref1 = \%interval_list;
my $minute = "";
my %convert_hash;
interval_test($hash_ref1);

sub interval_test{
#---------------------------------------------get passed key/value pair
   my $sub_hash_ref1 = shift;
   my %sub_hash1 = %{ $sub_hash_ref1 };
#-----------------New date/time formatter--------------------this format---0001-01-01T23:16:42-----------
      my $parser = DateTime::Format::Strptime->new(
            pattern =>'%H:%M',
            time_zone => 'UTC'
);

#----------------------------------------
my @range;
my $key = '';
#----------------------------------------    
   foreach $key (keys(%sub_hash1))
   {

my $zero = '00:00';
my $int_start = $key;#-------------------------------------hash key
my $int_end = $sub_hash1{$key};


my $span_zero = $parser->parse_datetime($zero);
my $span =  $parser->parse_datetime($int_start);
my $span1 =  $parser->parse_datetime($int_end);
my $pointer = $span->subtract_datetime($span_zero);
my $pointer1 = $span1->subtract_datetime($span_zero);

my $format = DateTime::Format::Duration->new(
    pattern => '%M minutes'
);

my $result = $format->format_duration($pointer);
my $result1 = $format->format_duration($pointer1);


$result =~ s/\D+//gi;
$result1 =~ s/\D+//gi;

my @res=();
@res = ($result..$result1);

#---------------------------------fill the array
unshift @range, @res;

#----------------------------------------------
$convert_hash{"$result"} = "$result1";
#say Dumper $convert_hash{"$result"};
#--------------------------------
}

#-----------------------------------------------sort array numerically
my @range_sorted = sort { $a <=> $b } @range;
#---------------------------------------------------------------------
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $time_now = sprintf("%02d:%02d", $hour, $min);

#---------------------------------------------------
      my $parser3= DateTime::Format::Strptime->new(
            pattern =>'%H:%M',
            time_zone => 'UTC'
);
#say "Time now is - ".$time_now;
#----------------------------------------
my $int_start = $time_now;#-----------------------------

my $z_ref = $parser3->parse_datetime('00:00');
my $span3 =  $parser3->parse_datetime($int_start);

my $pointer3 = $span3->subtract_datetime($z_ref);


my $format = DateTime::Format::Duration->new(
    pattern => '%M minutes'
);


my $result_now3 = $format->format_duration($pointer3);
$result_now3 =~ s/\D+//gi;


#-----------------------------------------------
my $in_range;

if (any { $_ eq $result_now3} @range_sorted) {
    return $in_range = "true"." -Time now is - ".$time_now." and is within time intervals";
}
else {
    return  $in_range = "false"." -Time now is - ".$time_now." and isn't within any time intervals";
}

   }


sub minute_now{
	
	($minute) = @_;

#---------------------------------------------------
      my $parser_now= DateTime::Format::Strptime->new(
            pattern =>'%H:%M',
            time_zone => 'UTC'
);
my $now_start = $minute;#-------------------------------passed-from-script

my $zero_ref = $parser_now->parse_datetime('00:00');
my $end_ref =  $parser_now->parse_datetime($now_start);
my $pointer4 = $end_ref->subtract_datetime($zero_ref);
my $format = DateTime::Format::Duration->new(
    pattern => '%M minutes'
);
my $result_now = $format->format_duration($pointer4);
$result_now =~ s/\D+//gi;#-----------------------------take-out-non-digits
return $result_now;
}

END { }       # module clean-up code here (global destructor)

1;

# ABSTRACT: Time Interval

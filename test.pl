#!/usr/bin/perl -w
# 37K2jPD - test.pl created by Pip@CPAN.Org to validate 
#     Curses::Simp functionality.
#   Before `make install' is performed this script should be run with
#     `make test'.  After `make install' it should work as `perl test.pl'.

BEGIN { $| = 1; print "0..0\n"; }
END   { print "not ok 1\n" unless($loaded); }
use Curses::Simp;

my $calc; my $result; my $TESTNUM = 0;
$loaded = 1;
&report(1);

sub report { # prints test progress
  my $bad = !shift;
  print "not " x $bad;
  print "ok ", $TESTNUM++, "\n";
  print @_ if $ENV{TEST_VERBOSE} and $bad;
}

# not sure how to perform automated test of Simp installation success yet

#!/usr/bin/perl -w
# 37K2jPD - test.pl created by Pip@CPAN.Org to validate 
#     Curses::Simp functionality.
#   Before `make install' is performed this script should be run with
#     `make test'.  After `make install' it should work as `perl test.pl'.
#   This test.pl mimics that of Term::Screen by Mark Kaehny.

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

my $simp = Curses::Simp->new();
# test output
$simp->Text('push' => 'Test series for Simp.pm module for perl5');
# test cursor movement && output together
$simp->Prnt('ycrs' => 2, 'xcrs' => 3,
            '1. Should be at row 2 col 3 (upper left is 0,0)');
#test current position update
my $rowe = $simp->YCrs(); my $colm = $simp->XCrs();
$simp->Prnt('ycrs' => 3, 'xcrs' => 0,
            "2. Last position $rowe $colm -- should be 2 50.");
#test rows and cols ( should be updated for signal )
$simp->Prnt('ycrs' => 4, 'xcrs' => 0,
            "3. Screen size: " . $simp->Hite() . " rows and " . 
                                 $simp->Widt() . " columns.");
# test standout and normal test
$simp->Move(6, 0);
$simp->Prnt(#'colr' => '!wwwwwwwwww;bWbWbWbWbWbWbW', # actual reverse is not
                       '4. Testing reverse');       #   in Curses::Simp
$simp->Prnt(#'colr' => '!wwwwwwwWWWWwwwwwww',        # bold is done with uc()
                       ' mode, bold mode, ');       #   in Curses::Simp
$simp->Prnt(#'colr' => ';.bWWWWWWWW.!wwwwwwwww',     # it's not the same 
                         'and both together.');     #   in Curses::Simp
# test clreol 
# first put some stuff up
my $line = "0---------10--------20--------30--------40--------50--------60--------70-------";
$simp->Prnt('ycrs' => 7, 'xcrs' => 0, #'colr' => 'wb',
            '5. Testing clreol - ' . 
                      '   The next 2 lines should end at col 20 and 30.');
for(8..10) { $simp->Prnt('ycrs' => $_, 'xcrs' => 0, #'colr' => 'wb',
                         $line); }
$simp->{'_text'}->[8] = substr($simp->{'_text'}->[8], 0, 20);
$simp->{'_text'}->[9] = substr($simp->{'_text'}->[9], 0, 30);
$simp->Draw();

## test clreos
for(11..20) { $simp->Prnt('ycrs' => $_, 'xcrs' => 0, #'colr' => 'wb',
                          $line); }
$simp->Prnt('ycrs' => 11, 'xcrs' => 0, #'colr' => 'wb',
            '6. Clreos - Hit a key to clear all right and below:');
$simp->GetK(31);
$simp->Prnt(' ' x 4097); # hehe hack to clear to EndOfScreen =)
#test insert line and delete line
$simp->Prnt('ycrs' => 12, 'xcrs' => 0, #'colr' => 'wb',
            '7. Test insert and delete line - 15 deleted, and ...');
for(13..16) { $simp->Prnt('ycrs' => $_, 'xcrs' => 0, #'colr' => 'wb',
                          $_ . substr($line, 2)); }
splice(@{$simp->{'_text'}}, 15, 1); # delete line dl()
splice(@{$simp->{'_text'}}, 14, 0, '... this is where line 14 was'); # il()
## test key_pressed
$simp->Prnt('ycrs' => 18, 'xcrs' => 0, #'colr' => 'wb',
            "8. Key_pressed - Don't Hit a key in the next 5 seconds: ");
if($simp->GetK( 5) ne '-1') { $simp->Prnt('HEY A KEY WAS HIT'); }
else                        { $simp->Prnt('GOOD - NO KEY HIT!'); }
$simp->Prnt('ycrs' => 19, 'xcrs' => 0, #'colr' => 'wb',
            'Hit a key in the next 15 seconds: ');
if($simp->GetK(15) ne '-1') { $simp->Prnt('KEY HIT!'); }
else                        { $simp->Prnt('NO KEY HIT'); }
## test getch
## clear buffer out
$simp->GetK() for(0..127); # flush_input();
$simp->Prnt('ycrs' => 21, 'xcrs' => 0, #'colr' => 'wb',
            'Testing getch, Enter Key (q to quit): ');
$simp->Move(21, 40);
my $char = '';
while(($char = $simp->GetK(31)) ne 'q' && $char ne '-1') {
  $simp->{'_text'}->[21] = substr($simp->{'_text'}->[8], 0, 50);
  if(length($char) == 1) {
    $simp->Prnt('ycrs' => 21, 'xcrs' => 50, #'colr' => 'wb',
                'ord of char is: ' . ord($char));
  } else {
    $simp->Prnt('ycrs' => 21, 'xcrs' => 50, #'colr' => 'wb',
                "function value: $char");
  }
  $simp->Move(21, 40);
}
$simp->Move(22, 0);

# 2AFBQB7 - Curses::Simp created by Pip@CPAN.Org to vastly simplify Perl
#   text-mode application development
# Notz: Curses color names:
#   COLOR_ BLACK,RED,GREEN,YELLOW,BLUE,MAGENTA,CYAN,WHITE 

=head1 NAME

Curses::Simp - a Simple Curses wrapper for easy application development

=head1 VERSION

This documentation refers to version 1.0.41O4516 of 
Curses::Simp, which was released on Sat Jan 24 04:05:01:06 2004.

=head1 SYNOPSIS

  use Curses::Simp;
  my $scrn = Curses::Simp->new('text' => ['1337', 'nachoz', 'w/', 'cheese' x 7]);
  my $keey = '';
  while($keey ne 'x') {           # wait for 'x' to eXit
    $keey = $scrn->GetK(-1);      # get a blocking keypress
    $scrn->Text('push' => $keey); # add new line for new key
  } # screen automagically draws when new() && Text() are called

=head1 DESCRIPTION

Curses::Simp provides a curt mechanism for updating a console screen 
with any Perl array (or two to include color codes).  Most key strokes
can be simply obtained and tested for interface manipulation.  The goal
was ease-of-use first && efficient rendering second.  Of course, it 
could always benefit from being faster still.  Many Simp functions 
can accept rather cryptic parameters to do fancier things but the most
common case is meant to be as simple as possible (hence the name).
The more I learn about Curses, the more functionality I intend to add...
Feeping Creatures overcome.

=head1 2DO

=over 2

=item - fix ShokScrn redrawing / overlapping bugs

=item - optimize autodraw by using Prnt('prin' => 1) nstd of Draw() when
          only a line chgd with like Text('1' => 'new line 1 text')

=item - fix ptok bars screen jitters (too many touchwin refresh?)

=item - add styles && style/blockchar increment keys to CPik

=item - mk generic file/dir browse dialog window function: Brws

=item - describe Simp objects sharing apps (pmix + ptok)
          mk OScr read Simp apps @_ param list && auto-handle --geom wxh+x+y

=item - add multi-line option to Prnt where text can split on /\n/

=item - add multi-line option to Prmt where dtxt can split on /\n/ && ^d
          accepts entry instead of RETURN

=item - handle ascii chars under 32 with escapes from Prnt

=item - optimize Draw more

=item - imp up/dn scrollbars either internally or w/ normal Curses funcs

=item - handle ascii chars under 32 better than current escapes if possible

=back

=over 4

        if detectable:

=item - handle xterm resize events

=item - handle mouse input (study any existent Curses apps that use mouse 
          input you can find ... probably in C)

=item - Learn how to read a Shift-Tab key press if in any way 
          distinguishable from Tab/Ctrl-I

=item -    What else does Simp need?

=back

=head1 WHY?

Curses::Simp was created because I could hardly find dox || examples 
of Curses.pm usage so I fiddled until I could wrap the most important
stuff (AFAIC) in names && enhanced functions which streamline what I
want to do.

=head1 USAGE

B<new()> - Curses::Simp object constructor

new() opens a new Curses screen if one does not exist already && 
initializes useful default screen, color, && keys settings.  The
created Curses screen is automagically closed on program exit.

Below are available object methods.  Each of the four letter 
abbreviated method names as well as those beginning with "Flag" 
can be used as initialization parameters to new() if lowercased.
An example:

  my $simp = Curses::Simp->new( 'hite' => 7 ); # set 'hite' at init
     $simp->Hite(   15 );                 # set 'hite' through Hite()
     $simp->Height( 31 );                 # set 'hite' through Height()

See the individual sections in the ACCESSOR && FLAG METHODS 
section for more information on how to manipulate created 
Curses::Simp objects.

Most other Curses::Simp methods also accept a hash parameter which 
loads the object fields the same as new().

=head2 ExpandCC or ExpandColorCodeString($cccs)

Returns the expanded form of the compressed color code string $cccs.

$cccs may contain any of the special formatting characters specified in the 
COLOR NOTES (Interpretation of Backgrounds && Repeats in Color Codes)
section.

ExpandCC() is primarily useful as an internal function to the 
Curses::Simp package but I have exposed it because it can be useful
to test && see how a compressed color code string would be expanded
especially if expansion from Prnt() or Draw() are not what you expect.

=head2 ShokScrn or ShockScreen([$cler])

ShokScrn() forces the screen && all created Simp objects to be 
refreshed in order.

The $cler flag (default is false) can be provided to specify that
the entire screen is to be cleared before everything refreshes.
Clearing the entire screen usually isn't necessary.

=head2 KNum or KeyNumbers

Returns a hash with key    numbers  => "names".

=head2 CLet or ColorLetters

Returns a hash with color "letters" => numbers.

=head2 NumC or NumColors

Returns the number of available colors (last index: NumC()-1)

=head2 Hite or Height

Returns the current Simp object's window height (last index: Hite()-1)

=head2 Widt or Width

Returns the current Simp object's window width  (last index: Widt()-1)

=head2 Prnt or PrintString($strn)

Prints $strn at current cursor position.  Prnt() can also accept a hash 
of parameters (eg. Prnt('text' => $strn)) where:

  'text' => [ "String to Print" ], # or can just be string without arrayref
  'colr' => [ "ColorCodes corresponding to text" ], # same just string optn
  'ycrs' =>  3, # Number to move the cursor's y to before printing
  'xcrs' =>  7, # Number to move the cursor's x to before printing
  'yoff' => 15, # same as ycrs except original ycrs is restored afterwards
  'xoff' => 31, # same as xcrs except original xcrs is restored afterwards
  'prin' =>  1, # flag to specify whether printed text should update the
                #   main Text() && Colr() data or just print to the screen
                #   temporarily.  Default is true (ie. Print Into Text/Colr)

Prnt() returns the number of characters printed.

=head2 Draw or DrawWindow

Draws the current Simp object with the established Text() and Colr()
data.

Draw() accepts a hash of parameters like new() which will update as
many attributes of the Simp object as are specified by key => values.

Draw() returns the number of lines printed (which is normally the
same as Hite()).

=head2 Wait or WaitTime($time)

Wait() does nothing for $time seconds.

$time can be an integer or floating point number of seconds.
(eg. Wait(1.27) does nothing for just over one second).

Wait() (like GetK()) can also use alternate waiting methods.
The default $time format is integer or floating seconds.  It can
also be a Time::Frame object or an integer of milliseconds.
These modes can be set with the FlagFram(1) and FlagMili(1)
methods respectively.

=head2 GetK or GetKey([$tmot][,$sdlk])

Returns a keypress if one is made or -1 after waiting $tmot seconds.

$tmot can be an integer or floating point number of seconds.
(eg. GetK(2.55) waits for two && one-half seconds before returning -1
if no key was pressed).

Default behavior is to not block (ie. GetK(0)).  Use GetK(-1) for a
blocking keypress (ie. to wait indefinitely).

GetK() can also use alternate waiting methods.  The default is 
integer or floating seconds.  It can also utilize Time::Frame objects
or integer milliseconds if preferred.  These modes can be set with
the FlagFram(1) and FlagMili(1) methods respectively.

$sdlk is a flag (default is false) which tells GetK() to return a
verbose key string name from the list of SDLKeys in the SDLKEY NOTES
section.

The GetK() $sdlk flag parameter sets SDLKey mode temporarily
(ie. only for a single execution of GetK()).  This mode can be
turned on permanently via the FlagSDLK(1) function.

In SDLKey mode, GetK() returns an SDLKey name from the SDLKEY NOTES
section and sets the flags in KMod().

=head2 KMod or KeyMode([$keyn][,$newv])

Returns the key mode (state) of the key mode name $keyn.  $keyn
should be one of the KMOD_ names from the bottom of the SDLKEY NOTES
section.

If no parameters are provided, the state of KMOD_NONE is returned.

If $newv is provided, $keyn state is set to $newv.

=head2 Move or MoveCursor([$ycrs, $xcrs])

Move() updates the current Simp object's cursor position to the
newly specified $ycrs, $xcrs.

By default, the cursor is not visible but this can be changed through
the FlagCVis() function.

Returns ($ycrs, $xcrs) as the coordinates of cursor.

=head2 Rsiz or ResizeWindow($hite, $widt)

Rsiz() updates the current Simp object's window dimensions to the
newly specified $hite, $widt.

It may help to think of Rsiz() as a wrapper to Hite(), Widt() 
although actually the opposite is true.

Returns ($hite, $widt) as the dimensions of the window.

=head2 Mesg or MessageWindow($mesg)

Mesg() draws a Message Window in the center of the screen to 
display $mesg.  Mesg() can also accept a hash of parameters 
(eg. Mesg('mesg' => $mesg)) where:

  'mesg' => "Message to Print",
  'text' => [ "same as new \@text" ],
  'colr' => [ "ColorCodes corresponding to mesg or text" ],
  'titl' => "MessageWindow Title string",
  'tclr' => "ColorCodes corresponding to titl",
  'flagpres' => 1, # a flag specifying whether to "Press A Key"
  'pres' => "Press A Key...", # string to append if flagpres is true
  'pclr' => "ColorCodes corresponding to pres",
  'wait' => 1.0, # floating number of seconds to wait
                 #   if flagpres is true, Mesg() waits this long for
                 #     a keypress before quitting
                 #   if flagpres is false, Mesg() waits this long
                 #     regardless of whether keys are pressed

Returns the value of pressed key.  This can be used to make simple
one-character prompt windows.  For example:

  use Curses::Simp;
  my $simp = Curses::Simp->new();
  my $answ = $simp->Mesg('titl' => 'Is Simp useful?', 
                         'mesg' => '(Yes/No)', 
                         'pres' => '');
             $simp->Mesg('titl' => 'Answer:', $answ);
     # ... or another way ...
     $answ = $simp->Mesg('titl' => 'Is Simp useful?',
                         'pres' => '(Yes/No)');
             $simp->Mesg('titl' => 'Answer:', $answ);

=head2 Prmt or PromptWindow(\$dref)

Prmt() draws a Prompt Window in the center of the screen to 
display && update the value of $dref.  \$dref should be a 
reference to a variable containing a string you want edited or
replaced.  Prmt() can also accept a hash of parameters 
(eg. Prmt('dref' => \$dref)) where:

  'dref' => \$dref, # Default Reference to variable to be read && edited
  'dtxt' => "Default Text string in place of dref",
  'dclr' => "ColorCodes corresponding to dref/dtxt",
  'hclr' => "ColorCodes corresponding to the highlighted (unedited) dref/dtxt",
  'text' => [ "same as new \@text" ],
  'colr' => [ "ColorCodes corresponding to mesg or text" ],
  'hite' =>  3, # height of the prompt window (including borders)
  'widt' => 63, # width  of the prompt window (including borders)
  'titl' => "MessageWindow Title string",
  'tclr' => "ColorCodes corresponding to titl",
  'flagcvis' => 1, # a flag specifying whether the cursor should be displayed

=head2 CPik or ColorPickWindow

CPik() is a simple Color Picker window.

It accepts arrow keys to highlight a particular color && enter to select.
The letter corresponding to the color or the number of the index can also
be pressed instead.

Returns the letter of the picked color.

=head2 DESTROY or DelW or DeleteWindow

DelW() deletes all the components of the created Simp object and calls
ShokScrn() to cause the screen && all other created objects to be redrawn.

=head1 ACCESSOR && FLAG METHODS

Simp accessor && flag object methods have related interfaces as they
each access && update a single component field of Curses::Simp objects.  Each
one always returns the value of the field they access.  Thus if you want
to obtain a certain value from a Simp object, just call the accessor
method with no parameters.  If you provide parameters, the field will
be updated && will return its new value.

All of these methods accept a default parameter of their own type or
a hash of operations to perform on their field.

Some operations are only applicable to a subset of the methods as 
dictated by the field type.  The available operations are:

   Key   =>   Value Type  ... # Purpose
  -----      ------------ 
  'asin' =>  $scalar (number|string|arrayref)
  # this context-sensitive assignment loads the field
  'blnk' =>  $ignored         # blanks a string value
  'togl' =>  $ignored         # toggles    a flag value
  'true' =>  $ignored         # trues      a flag value
  'fals' =>  $ignored         # falsifies  a flag value
  'incr' =>  $numeric_amount  
  # increments if no $num is provided or increases by $num
  'decr' =>  $numeric_amount  
  # decrements if no $num is provided or decreases by $num
  'nmrc' =>  $string          
  # instead of an explicit 'nmrc' hash key, this means the
  #   key is an entirely numeric string like '1023'
  #   so the value gets assigned to that element when the 
  #   field is an array.  The key is assigned directly if
  #   the field is numeric or a string.
  # ARRAY-SPECIFIC operations:
  'size' => $ignored                # return the array size
  'push' => $scalar (number|string) # push new value
  'popp' => $ignored                # pop last value
  'apnd' => $scalar (number|string) # append to last element
  'dupl' => $number                 # duplicate last line or
                                    #   $num line if provided
  'data' => $arrayref               # assigns the array if
                                    #   $arrayref provided &&
                                    #   returns ALL array data
  # LOOP-SPECIFIC operations:
  'next' => $ignored          # assign to next     in loop
  'prev' => $ignored          # assign to previous in loop

=head2 Array Accessors

  Text # update the text  array
  Colr # update the color array

=head2 Loop Accessors

  BTyp # loop through border types

=head2 Normal Accessors

  Name             # Description
  ----             -------------
  Hite             # window height
  Widt             # window width
  YOff             # window y-offset position
  XOff             # window x-offset position
  YCrs             # window y-cursor position
  XCrs             # window x-cursor position
  BClr             # border color code string
  Titl             # title string
  TClr             # title  color code string
  DNdx             # global display index

=head2 Flag Accessors

  FlagName Default # Description
  -------- ------- -------------
  FlagAuDr    1    # Automatic Draw() whenever Text or Colr are updated
  FlagMaxi    1    # Maximize window
  FlagShrk    1    # Shrink window to fit Text
  FlagCntr    1    # Center window within entire available screen
  FlagCVis    0    # Cursor Visible
  FlagScrl    0    # use Scrollbars (not implemented yet)
  FlagSDLK    0    # use advanced SDLKey mode in GetK()
  FlagBkgr    0    # always expect background colors in color codes
  FlagFram    0    # use Time::Frame objects  instead of float seconds
  FlagMili    0    # use integer milliseconds instead of float seconds
  FlagPrin    1    # Prnt() Into Text array.  If FlagPrin is false, 
                   #   then each call to Prnt() only writes to the screen
                   #   temporarily && will be wiped the next time the
                   #   window behind it is updated.

=head2 Accessor && Flag Method Usage Examples

  #!/usr/bin/perl -w
  use strict;
  use Curses::Simp;
  # create new object which gets auto-drawn with init params
  my $simp = Curses::Simp->new('text' => [ 'hmmm', 'haha', 'whoa', 'yeah' ],
                               'colr' => [ 'bbbB', 'bBBw', 'BwrR', 'ROYW' ],
                               'btyp' => 1,
                               'flagmaxi' => 0); 
     $simp->GetK(-1);               # wait for a key press
     $simp->Text('push' => 'weee'); # add more to the Text
     $simp->Colr('push' => 'WwBb'); #              && Colr arrays
     $simp->FlagMaxi('togl');       # toggle  the maximize flag
     $simp->GetK(-1);               # wait for a key press
     $simp->Text('2'    => 'cool'); # change index two elements of Text
     $simp->Colr('2'    => 'uUCW'); #                           && Colr
     $simp->FlagMaxi('fals');       # falsify the maximize flag
     $simp->GetK(-1);               # wait for a key press
     $simp->Text('popp');           # pop the last elements off Text
     $simp->Colr('popp');           #                        && Colr
     $simp->BTyp('incr');           # increment the border type
     $simp->GetK(-1);               # wait for a key press
     $simp->Text('asin' => [ 'some', 'diff', 'rent', 'stuf' ]);
     $simp->Colr('asin' => [ 'GGYY', 'CCOO', 'UURR', 'WWPP' ]);
     $simp->BTyp('incr');           # increment the border type
     $simp->GetK(-1);               # wait for a key press before quitting

=head1 SDLKEY NOTES

The GetK() function has a special advanced mode of input.  Instead of 
returning the plain keypress (eg. 'a'), the $sdlk flag parameter can 
be set to true for temporary SDLKey mode or with FlagSDLK(1) for
permanence so that verbose strings of SDLKey names will be returned 
instead (eg. 'SDLK_a').

The list of returnable SDLKey names are:

   SDLKey           ASCII value    Common name
  ----------------  -----------   ------------
  'SDLK_BACKSPACE',      #'\b'    backspace
  'SDLK_TAB',            #'\t'    tab
  'SDLK_CLEAR',          #        clear
  'SDLK_RETURN',         #'\r'    return
  'SDLK_PAUSE',          #        pause
  'SDLK_ESCAPE',         #'^['    escape
  'SDLK_SPACE',          #' '     space
  'SDLK_EXCLAIM',        #'!'     exclaim
  'SDLK_QUOTEDBL',       #'"'     quotedbl
  'SDLK_HASH',           #'#'     hash
  'SDLK_DOLLAR',         #'$'     dollar
  'SDLK_AMPERSAND',      #'&'     ampersand
  'SDLK_QUOTE',          #'''     quote
  'SDLK_LEFTPAREN',      #'('     left parenthesis
  'SDLK_RIGHTPAREN',     #')'     right parenthesis
  'SDLK_ASTERISK',       #'*'     asterisk
  'SDLK_PLUS',           #'+'     plus sign
  'SDLK_COMMA',          #','     comma
  'SDLK_MINUS',          #'-'     minus sign
  'SDLK_PERIOD',         #'.'     period
  'SDLK_SLASH',          #'/'     forward slash
  'SDLK_0',              #'0'     0
  'SDLK_1',              #'1'     1
  'SDLK_2',              #'2'     2
  'SDLK_3',              #'3'     3
  'SDLK_4',              #'4'     4
  'SDLK_5',              #'5'     5
  'SDLK_6',              #'6'     6
  'SDLK_7',              #'7'     7
  'SDLK_8',              #'8'     8
  'SDLK_9',              #'9'     9
  'SDLK_COLON',          #':'     colon
  'SDLK_SEMICOLON',      #';'     semicolon
  'SDLK_LESS',           #'<'     less-than sign
  'SDLK_EQUALS',         #'='     equals sign
  'SDLK_GREATER',        #'>'     greater-than sign
  'SDLK_QUESTION',       #'?'     question mark
  'SDLK_AT',             #'@'     at
  'SDLK_LEFTBRACKET',    #'['     left bracket
  'SDLK_BACKSLASH',      #'\'     backslash
  'SDLK_RIGHTBRACKET',   #']'     right bracket
  'SDLK_CARET',          #'^'     caret
  'SDLK_UNDERSCORE',     #'_'     underscore
  'SDLK_BACKQUOTE',      #'`'     grave
  'SDLK_a',              #'a'     a
  'SDLK_b',              #'b'     b
  'SDLK_c',              #'c'     c
  'SDLK_d',              #'d'     d
  'SDLK_e',              #'e'     e
  'SDLK_f',              #'f'     f
  'SDLK_g',              #'g'     g
  'SDLK_h',              #'h'     h
  'SDLK_i',              #'i'     i
  'SDLK_j',              #'j'     j
  'SDLK_k',              #'k'     k
  'SDLK_l',              #'l'     l
  'SDLK_m',              #'m'     m
  'SDLK_n',              #'n'     n
  'SDLK_o',              #'o'     o
  'SDLK_p',              #'p'     p
  'SDLK_q',              #'q'     q
  'SDLK_r',              #'r'     r
  'SDLK_s',              #'s'     s
  'SDLK_t',              #'t'     t
  'SDLK_u',              #'u'     u
  'SDLK_v',              #'v'     v
  'SDLK_w',              #'w'     w
  'SDLK_x',              #'x'     x
  'SDLK_y',              #'y'     y
  'SDLK_z',              #'z'     z
  'SDLK_DELETE',         #'^?'    delete
  'SDLK_KP0',            #        keypad 0
  'SDLK_KP1',            #        keypad 1
  'SDLK_KP2',            #        keypad 2
  'SDLK_KP3',            #        keypad 3
  'SDLK_KP4',            #        keypad 4
  'SDLK_KP5',            #        keypad 5
  'SDLK_KP6',            #        keypad 6
  'SDLK_KP7',            #        keypad 7
  'SDLK_KP8',            #        keypad 8
  'SDLK_KP9',            #        keypad 9
  'SDLK_KP_PERIOD',      #'.'     keypad period
  'SDLK_KP_DIVIDE',      #'/'     keypad divide
  'SDLK_KP_MULTIPLY',    #'*'     keypad multiply
  'SDLK_KP_MINUS',       #'-'     keypad minus
  'SDLK_KP_PLUS',        #'+'     keypad plus
  'SDLK_KP_ENTER',       #'\r'    keypad enter
  'SDLK_KP_EQUALS',      #'='     keypad equals
  'SDLK_UP',             #        up arrow
  'SDLK_DOWN',           #        down arrow
  'SDLK_RIGHT',          #        right arrow
  'SDLK_LEFT',           #        left arrow
  'SDLK_INSERT',         #        insert
  'SDLK_HOME',           #        home
  'SDLK_END',            #        end
  'SDLK_PAGEUP',         #        page up
  'SDLK_PAGEDOWN',       #        page down
  'SDLK_F1',             #        F1
  'SDLK_F2',             #        F2
  'SDLK_F3',             #        F3
  'SDLK_F4',             #        F4
  'SDLK_F5',             #        F5
  'SDLK_F6',             #        F6
  'SDLK_F7',             #        F7
  'SDLK_F8',             #        F8
  'SDLK_F9',             #        F9
  'SDLK_F10',            #        F10
  'SDLK_F11',            #        F11
  'SDLK_F12',            #        F12
  'SDLK_F13',            #        F13
  'SDLK_F14',            #        F14
  'SDLK_F15',            #        F15
  'SDLK_NUMLOCK',        #        numlock
  'SDLK_CAPSLOCK',       #        capslock
  'SDLK_SCROLLOCK',      #        scrollock
  'SDLK_RSHIFT',         #        right shift
  'SDLK_LSHIFT',         #        left shift
  'SDLK_RCTRL',          #        right ctrl
  'SDLK_LCTRL',          #        left ctrl
  'SDLK_RALT',           #        right alt
  'SDLK_LALT',           #        left alt
  'SDLK_RMETA',          #        right meta
  'SDLK_LMETA',          #        left meta
  'SDLK_LSUPER',         #        left windows key
  'SDLK_RSUPER',         #        right windows key
  'SDLK_MODE',           #        mode shift
  'SDLK_HELP',           #        help
  'SDLK_PRINT',          #        print-screen
  'SDLK_SYSREQ',         #        SysRq
  'SDLK_BREAK',          #        break
  'SDLK_MENU',           #        menu
  'SDLK_POWER',          #        power
  'SDLK_EURO',           #        euro

SDLKey mode also sets flags in KMod where:

   SDL Modifier                    Meaning
  --------------                  ---------
  'KMOD_NONE',           #        No modifiers applicable
  'KMOD_CTRL',           #        A  Control key is down
  'KMOD_SHIFT',          #        A  Shift   key is down
  'KMOD_ALT',            #        An Alt     key is down

=head1 COLOR NOTES

Colors can be encoded along with each text line to be printed.  
Prnt() && Draw() each take hash parameters where the key should be
'colr' && the value is a color code string as described below.

A normal color code is simply a single character (typically just the
first letter of the color name && the case [upper or lower] 
designates high or low intensity [ie. Bold on or off]).  Simple 
single character color codes represent only the foreground color.
The default printing mode of color codes assumes black background
colors for everything.  There are special ways to specify non-black
background colors or to encode repeating color codes if you want to.
The default to assume no background colors are specified can be
overridden object-wide by the FlagBkgr(1) function.

=head2 Normal Color Code Reference

                          b(Black),  r(Red),    g(Green),  y(Yellow),
   (upper-case = bright)  u(Blue),   p(Purple), c(Cyan),   w(White)

=head2 Alternate Color Codes

                          o([Orange] *Yellow),   m([Magenta]  Purple),
   (upper-case = bright)  t([Teal]    Cyan),     l([Lavender] Purple)

=head2 *Upper-Case Bright Orange Exception

There is a special exception for Upper-Case 'O' (Orange).  Orange is
actually Dark Yellow but it is often much brighter than any of the 
other dark colors which leads to confusion.  Therefore, Upper-Case 'O'
breaks the (upper-case = bright) rule && is interpreted the same as
Lower-Case 'y'.  Every other color code is consistent with the rule.

=head2 Interpretation of Backgrounds && Repeats in Color Codes

The following mechanisms are available for changing the default color
code string interpretation to read background colors after foreground &&
to specify abbreviations for code repeating:

The function FlagBkgr(1) will specify that you wish to have all color 
codes interpreted expecting both foreground && background characters for
each source text character.  Similarly, FlagBkgr(0) (which is the default
setting of not expecting Background characters) will turn off global
background interpretation.

The base64 characters specified below are in the set [0-9A-Za-z._] &&
are interpreted using the Math::BaseCnv module.

A space in a color code string is the same as 'b' (black).

When Background mode is OFF (ie. the default after FlagBkgr(0) or a '!'):

   x - When this lowercase times character is used, it must be followed
         by a base64 character which specifies how many times the color
         code prior to the (x) times character should be repeated.
   X - When this uppercase times character is used, it must be followed
         by a base64 character which specifies how many times the color
         code prior to the (X) times character should be repeated.  The
         difference from the lowercase (x) times is that the code prior
         to the (X) is treated as a background color for that many
         following foreground color code characters.
         After that, backgrounds return to black.
   , - The comma character specifies that the next two characters are a
         foreground && background color pair.
         After that, backgrounds return to black.
   : - The colon character specifies that the following character is a
         (presumably non-black) background character to use instead of 
         the default black for the remainder of the line (or until another
         special character overrides this one).
   ; - The semicolon character specifies that the remaining part of the
         current color code line should be interpreted as if full
         background interpretation were turned ON (as if FlagBkgr(1) had
         been called just for this line) so further interpretation
         proceeds like the FlagBkgr(1) section below.

   Each background specification character takes effect starting with the 
     next encountered foreground character so:
       'RgX2UU', 'R:gUU', && 'R;Ugx2' all expand to 'RbUgUg' not 'RgUgUb'
   Some Examples:
     Prnt('Hello World',  # the simplest 1-to-1 text/color printing with
          'WWWWW UUUUU'); #   all characters printed on black background
     Prnt('Hello World', 
          'Wx5bUx5');     # the same as above but using repeat (x) times
       Both of the above Prnt() calls would print 'Hello' in Bright White
         && 'World' in Bright blUe both on the default black background.
         The color strings would expanded from 
           'WWWWW UUUUU' or 'Wx5bUx5' to 'WbWbWbWbWbbbUbUbUbUbUb';
     Prnt('Hello World', 
          'Wx5b,Gu,Gu,Gu,Gu,Gu');
     Prnt('Hello World', 
          'Wx5b:uGx5');
     Prnt('Hello World', 
          'WWWWWbuX5GGGGG');
     Prnt('Hello World', 
          'Wx5buX5Gx5');
       These Prnt() calls would print 'Hello' the same as before but now
         'World' would be in Bright Green on a dark blUe background.
         These color strings would all expand to 'WbWbWbWbWbbbGuGuGuGuGu'.

When Background mode is ON  (ie. after FlagBkgr(1) or a ';'):

   . - When the dot character is encountered in a color pair, it signifies
         that the other field (foreground or background) should be used
         for the remainder of the color code string (or until the next 
         (.) dot character is found).
   x - When this times character is used, it must be followed by a base64
         character which specifies how many times the color code pair 
         prior to the (x) times character should be repeated.
   X - When this upper-case times character is used, it specifies that
         whichever field value preceeded it, it should be repeated the 
         number of times specified in the base64 character which follows.
   ! - The bang character specifies that the remaining part of the
         current color code line should be interpreted as if background
         interpretation were turned OFF (as if FlagBkgr(0) had
         been called just for this line) so further interpretation
         proceeds like the FlagBkgr(0) section above.

   Some Examples:
     typical color pairs code string: 'WbWbWbGuGuGuGuGpGpGpYgYgYgYg'
       means 3 source characters should be Bright White  on black,
             4 source characters should be Bright Green  on blue,
             3 source characters should be Bright Green  on purple,
         &&  4 source characters should be Bright Yellow on green.
     same result using (.)    : 'W.bbb.G.uuuuppp.Y.gggg'
     same result using (x)    : 'Wbx3Gux4Gpx3Ygx4'
     same result using (X)    : 'WX3bbbGX7uuuupppYX4gggg'
     same result using hybrid : 'WbWbWbG.uX4pX3.Ygx4'
         color code string:   =>      expands to:
      'W.brgo'                =>  'WbWrWgWo'  # W. -> brgo
      '.bWCPU'                =>  'WbCbPbUb'  # .b -> WCPU
      'Wbx4'                  =>  'WbWbWbWb'  # (Wb) x 4
      'WbRx3p'                =>  'WbRbRbRp'  # W + (bR) x 3 + p
      'WX4upcw'               =>  'WuWpWcWw'  # W X 4 -> upcw
      'WoX4RGU'               =>  'WoRoGoUo'  # Wo + o X 3 -> RGU

I have tried to make Simp very simple to use yet still flexible && 
powerful.  Please feel free to e-mail me any suggestions || coding 
tips || notes of appreciation like "I appreciate you!  I like to say 
appreciate.  You can say it too.  Go on.  Say it.  Say 'I appreciate 
you!  I like to say appreciate.  You can say it too.  Go on.  Say it.
Say "..."'"  Thank you.  It's like app-ree-see-ate.  TTFN.

=head1 CHANGES

Revision history for Perl extension Curses::Simp:

=over 4

=item - 1.0.41O4516  Sat Jan 24 04:05:01:06 2004

* updated POD && added Simp projects into bin/ && MANIFEST in preparation
    for release, made all but ptok && qbix non-executable for EXE_FILES

=item - 1.0.41O3SQK  Sat Jan 24 03:28:26:20 2004

* setup window border char sets, added SDLK advanced input option to GetK,
    made new Mesg, Prmt, && CPik utils, added PrntInto 'flagprin' ability,
    fixed weird char probs in Draw && removed weird char support from Prnt

=item - 1.0.4140asO  Sun Jan  4 00:36:54:24 2004

* CHANGES section && new objects created, refined Draw() && InitPair()

=item - 1.0.37VG26k  Thu Jul 31 16:02:06:46 2003

* original version

=back

=head1 INSTALL

Please run:

    `perl -MCPAN -e "install Curses::Simp"`

or uncompress the package && run the standard:

    `perl Makefile.PL; make; make test; make install`

=head1 FILES

Curses::Simp requires:

  Carp                to allow errors to croak() from calling sub
  Curses              provides core screen && input handling
  Math::BaseCnv       to handle number-base conversion

Curses::Simp uses (if available):

  Time::Frame         to provide another mechanism for timing

=head1 LICENSE

Most source code should be Free!
  Code I have lawful authority over is && shall be!
Copyright: (c) 2003, Pip Stuart.  All rights reserved.
Copyleft :  I license this software under the GNU General Public
  License (version 2).  Please consult the Free Software Foundation
  (http://www.fsf.org) for important information about your freedom.

=head1 AUTHOR

Pip Stuart <Pip@CPAN.Org>

=cut

package Curses::Simp;
use strict;
use vars qw( $AUTOLOAD );
use Carp;
use Curses;
use Math::BaseCnv qw(:all);
my $fram = eval("use Time::Frame; 1") || 0;
our $VERSION     = '1.0.41O4516'; # major . minor . PipTimeStamp
our $PTVR        = $VERSION; $PTVR =~ s/^\d+\.\d+\.//; # strip major && minor
# See http://Ax9.Org/pt?$PTVR && `perldoc Time::PT`

my $dbug = 0; # flag for debug file logging
open(DBUG, ">dbug") if($dbug);
END { CScr(); close(DBUG) if($dbug); } # Auto-execute CloseScreen() on exit

# GLOBAL CLASS VARIABLES
my %GLBL = (
  'FLAGOPEN' => 0,   # flag for if a main curses screen has been opened yet
  'FLAGCOLR' => 0,   # flag for whether colors have been initialized which
                     #   holds the maximum number of color pairs after init
  'CHARSIMP' => '!', # character which specifies all temp simple   modes
  'CHARADVN' => ';', # character which specifies all temp advanced modes
);
my @DISPSTAK = ( );# global stack of created Simp objects for display order
my @BORDSETS = ( );# array of hashes of different border char sets (see OScr())
my @SDLKNAMZ = ( # in advanced input mode, these SDLK names return from GetK()
#  SDLKey           ASCII value    Common name
  'SDLK_BACKSPACE',      #'\b'    backspace
  'SDLK_TAB',            #'\t'    tab
  'SDLK_CLEAR',          #        clear
  'SDLK_RETURN',         #'\r'    return
  'SDLK_PAUSE',          #        pause
  'SDLK_ESCAPE',         #'^['    escape
  'SDLK_SPACE',          #' '     space
  'SDLK_EXCLAIM',        #'!'     exclaim
  'SDLK_QUOTEDBL',       #'"'     quotedbl
  'SDLK_HASH',           #'#'     hash
  'SDLK_DOLLAR',         #'$'     dollar
  'SDLK_AMPERSAND',      #'&'     ampersand
  'SDLK_QUOTE',          #'''     quote
  'SDLK_LEFTPAREN',      #'('     left parenthesis
  'SDLK_RIGHTPAREN',     #')'     right parenthesis
  'SDLK_ASTERISK',       #'*'     asterisk
  'SDLK_PLUS',           #'+'     plus sign
  'SDLK_COMMA',          #','     comma
  'SDLK_MINUS',          #'-'     minus sign
  'SDLK_PERIOD',         #'.'     period
  'SDLK_SLASH',          #'/'     forward slash
  'SDLK_0',              #'0'     0
  'SDLK_1',              #'1'     1
  'SDLK_2',              #'2'     2
  'SDLK_3',              #'3'     3
  'SDLK_4',              #'4'     4
  'SDLK_5',              #'5'     5
  'SDLK_6',              #'6'     6
  'SDLK_7',              #'7'     7
  'SDLK_8',              #'8'     8
  'SDLK_9',              #'9'     9
  'SDLK_COLON',          #':'     colon
  'SDLK_SEMICOLON',      #';'     semicolon
  'SDLK_LESS',           #'<'     less-than sign
  'SDLK_EQUALS',         #'='     equals sign
  'SDLK_GREATER',        #'>'     greater-than sign
  'SDLK_QUESTION',       #'?'     question mark
  'SDLK_AT',             #'@'     at
  'SDLK_LEFTBRACKET',    #'['     left bracket
  'SDLK_BACKSLASH',      #'\'     backslash
  'SDLK_RIGHTBRACKET',   #']'     right bracket
  'SDLK_CARET',          #'^'     caret
  'SDLK_UNDERSCORE',     #'_'     underscore
  'SDLK_BACKQUOTE',      #'`'     grave
  'SDLK_a',              #'a'     a
  'SDLK_b',              #'b'     b
  'SDLK_c',              #'c'     c
  'SDLK_d',              #'d'     d
  'SDLK_e',              #'e'     e
  'SDLK_f',              #'f'     f
  'SDLK_g',              #'g'     g
  'SDLK_h',              #'h'     h
  'SDLK_i',              #'i'     i
  'SDLK_j',              #'j'     j
  'SDLK_k',              #'k'     k
  'SDLK_l',              #'l'     l
  'SDLK_m',              #'m'     m
  'SDLK_n',              #'n'     n
  'SDLK_o',              #'o'     o
  'SDLK_p',              #'p'     p
  'SDLK_q',              #'q'     q
  'SDLK_r',              #'r'     r
  'SDLK_s',              #'s'     s
  'SDLK_t',              #'t'     t
  'SDLK_u',              #'u'     u
  'SDLK_v',              #'v'     v
  'SDLK_w',              #'w'     w
  'SDLK_x',              #'x'     x
  'SDLK_y',              #'y'     y
  'SDLK_z',              #'z'     z
  'SDLK_DELETE',         #'^?'    delete
  'SDLK_KP0',            #        keypad 0
  'SDLK_KP1',            #        keypad 1
  'SDLK_KP2',            #        keypad 2
  'SDLK_KP3',            #        keypad 3
  'SDLK_KP4',            #        keypad 4
  'SDLK_KP5',            #        keypad 5
  'SDLK_KP6',            #        keypad 6
  'SDLK_KP7',            #        keypad 7
  'SDLK_KP8',            #        keypad 8
  'SDLK_KP9',            #        keypad 9
  'SDLK_KP_PERIOD',      #'.'     keypad period
  'SDLK_KP_DIVIDE',      #'/'     keypad divide
  'SDLK_KP_MULTIPLY',    #'*'     keypad multiply
  'SDLK_KP_MINUS',       #'-'     keypad minus
  'SDLK_KP_PLUS',        #'+'     keypad plus
  'SDLK_KP_ENTER',       #'\r'    keypad enter
  'SDLK_KP_EQUALS',      #'='     keypad equals
  'SDLK_UP',             #        up arrow
  'SDLK_DOWN',           #        down arrow
  'SDLK_RIGHT',          #        right arrow
  'SDLK_LEFT',           #        left arrow
  'SDLK_INSERT',         #        insert
  'SDLK_HOME',           #        home
  'SDLK_END',            #        end
  'SDLK_PAGEUP',         #        page up
  'SDLK_PAGEDOWN',       #        page down
  'SDLK_F1',             #        F1
  'SDLK_F2',             #        F2
  'SDLK_F3',             #        F3
  'SDLK_F4',             #        F4
  'SDLK_F5',             #        F5
  'SDLK_F6',             #        F6
  'SDLK_F7',             #        F7
  'SDLK_F8',             #        F8
  'SDLK_F9',             #        F9
  'SDLK_F10',            #        F10
  'SDLK_F11',            #        F11
  'SDLK_F12',            #        F12
  'SDLK_F13',            #        F13
  'SDLK_F14',            #        F14
  'SDLK_F15',            #        F15
  'SDLK_NUMLOCK',        #        numlock
  'SDLK_CAPSLOCK',       #        capslock
  'SDLK_SCROLLOCK',      #        scrollock
  'SDLK_RSHIFT',         #        right shift
  'SDLK_LSHIFT',         #        left shift
  'SDLK_RCTRL',          #        right ctrl
  'SDLK_LCTRL',          #        left ctrl
  'SDLK_RALT',           #        right alt
  'SDLK_LALT',           #        left alt
  'SDLK_RMETA',          #        right meta
  'SDLK_LMETA',          #        left meta
  'SDLK_LSUPER',         #        left windows key
  'SDLK_RSUPER',         #        right windows key
  'SDLK_MODE',           #        mode shift
  'SDLK_HELP',           #        help
  'SDLK_PRINT',          #        print-screen
  'SDLK_SYSREQ',         #        SysRq
  'SDLK_BREAK',          #        break
  'SDLK_MENU',           #        menu
  'SDLK_POWER',          #        power
  'SDLK_EURO',           #        euro
);
my %SDLKCHRM = (
  ' ' => 'SPACE',
  '!' => 'EXCLAIM',
  '"' => 'QUOTEDBL',
  '#' => 'HASH',
  '$' => 'DOLLAR',
  '%' => 'PERCENT',
  '&' => 'AMPERSAND',
  "'" => 'QUOTE',
  '(' => 'LEFTPAREN',
  ')' => 'RIGHTPAREN',
  ',' => 'COMMA',
  '*' => 'ASTERISK',
  '+' => 'PLUS',
  ',' => 'COMMA',
  '-' => 'MINUS',
  '.' => 'PERIOD',
  '/' => 'SLASH',
  ':' => 'COLON',
  ';' => 'SEMICOLON',
  '<' => 'LESS',
  '=' => 'EQUALS',
  '>' => 'GREATER',
  '?' => 'QUESTION',
  '@' => 'AT',
  '[' => 'LEFTBRACKET',
  '\\'=> 'BACKSLASH',
  ']' => 'RIGHTBRACKET',
  '^' => 'CARET',
  '_' => 'UNDERSCORE',
  '`' => 'BACKQUOTE',
);
my %SDLKCRSM = (
  'KEY_BACKSPACE' => 'BACKSPACE',
  'KEY_LEFT'      => 'LEFT',
  'KEY_RIGHT'     => 'RIGHT',
  'KEY_UP'        => 'UP',
  'KEY_DOWN'      => 'DOWN',
  'KEY_HOME'      => 'HOME',
  'KEY_END'       => 'END',
  'KEY_PPAGE'     => 'PAGEUP',
  'KEY_NPAGE'     => 'PAGEDOWN',
  'KEY_IC'        => 'INSERT',
  'KEY_DC'        => 'DELETE',
  'KEY_F1'        => 'F1',
  'KEY_F2'        => 'F2',
  'KEY_F3'        => 'F3',
  'KEY_F4'        => 'F4',
  'KEY_F5'        => 'F5',
  'KEY_F6'        => 'F6',
  'KEY_F7'        => 'F7',
  'KEY_F8'        => 'F8',
  'KEY_F9'        => 'F9',
  'KEY_F10'       => 'F10',
  'KEY_F11'       => 'F11',
  'KEY_F12'       => 'F12',
  'KEY_F13'       => 'F13',
  'KEY_F14'       => 'F14',
  'KEY_F15'       => 'F15',
);
my %SDLKORDM = (
  '9'  => 'TAB',
  '13' => 'RETURN',
  '27' => 'ESCAPE',
);
my @KMODNAMZ = ( # in advanced input mode, these KMOD modifier names get set
                 #   within the Simp object's '_kmod' hash after each GetK()
#  SDL Modifier                    Meaning
  'KMOD_NONE',           #        No modifiers applicable
# I don't think I can detect locks or left/right with Curses so commented
#  'KMOD_NUM',            #        Numlock is down
#  'KMOD_CAPS',           #        Capslock is down
#  'KMOD_LCTRL',          #        Left Control is down
#  'KMOD_RCTRL',          #        Right Control is down
#  'KMOD_RSHIFT',         #        Right Shift is down
#  'KMOD_LSHIFT',         #        Left Shift is down
#  'KMOD_RALT',           #        Right Alt is down
#  'KMOD_LALT',           #        Left Alt is down
  'KMOD_CTRL',           #        A Control key is down
  'KMOD_SHIFT',          #        A Shift key is down
  'KMOD_ALT',            #        An Alt key is down
);
my @kndx = (); my @knam = (); my %knum = (); my $i = 0;
my %clet = ( 'b' =>  0, 'r' =>  1, 'g' =>  2, 'o' =>  3, # color letters map
                        'm' =>  5, 't' =>  6, 'y' =>  3,
             'u' =>  4, 'p' =>  5, 'c' =>  6, 'w' =>  7,
             'B' =>  8, 'R' =>  9, 'G' => 10, 'O' =>  3, # Orange exception
                        'M' => 13, 'T' => 14, 'Y' => 11,
             'U' => 12, 'P' => 13, 'C' => 14, 'W' => 15,
             'l' =>  5, 'L' => 13                       );
my @telc = ( 'b', 'r', 'g', 'y', 'u', 'p', 'c', 'w' ); # core colors indexed
# ordered attribute names array, default attribute data hash
my @_attrnamz = ();     my %_attrdata = ();
         my %_verbose_attribute_names = ();
# field data
push(@_attrnamz, '_wind'); $_attrdata{$_attrnamz[-1]} = 0; # CursesWindowHandle
            $_verbose_attribute_names{$_attrnamz[-1]} = 'window_handle';
push(@_attrnamz, '_text'); $_attrdata{$_attrnamz[-1]} = []; # text  data
            $_verbose_attribute_names{$_attrnamz[-1]} = 'text_data';
push(@_attrnamz, '_colr'); $_attrdata{$_attrnamz[-1]} = []; # color data
            $_verbose_attribute_names{$_attrnamz[-1]} = 'color_data';
push(@_attrnamz, '_hite'); $_attrdata{$_attrnamz[-1]} = 0;  # window height
            $_verbose_attribute_names{$_attrnamz[-1]} = 'window_height';
push(@_attrnamz, '_widt'); $_attrdata{$_attrnamz[-1]} = 0;  # window width
            $_verbose_attribute_names{$_attrnamz[-1]} = 'window_width';
push(@_attrnamz, '_yoff'); $_attrdata{$_attrnamz[-1]} = 0;  # window y-offset
            $_verbose_attribute_names{$_attrnamz[-1]} = 'window_y_offset';
push(@_attrnamz, '_xoff'); $_attrdata{$_attrnamz[-1]} = 0;  # window x-offset
            $_verbose_attribute_names{$_attrnamz[-1]} = 'window_x_offset';
push(@_attrnamz, '_ycrs'); $_attrdata{$_attrnamz[-1]} = 0;  # cursor y-offset
            $_verbose_attribute_names{$_attrnamz[-1]} = 'cursor_y_offset';
push(@_attrnamz, '_xcrs'); $_attrdata{$_attrnamz[-1]} = 0;  # cursor x-offset
            $_verbose_attribute_names{$_attrnamz[-1]} = 'cursor_x_offset';
push(@_attrnamz, '_btyp'); $_attrdata{$_attrnamz[-1]} = 0;    # border type
            $_verbose_attribute_names{$_attrnamz[-1]} = 'window_border_type';
push(@_attrnamz, '_bclr'); $_attrdata{$_attrnamz[-1]} = '!w'; # border color
            $_verbose_attribute_names{$_attrnamz[-1]} = 'window_border_color';
push(@_attrnamz, '_titl'); $_attrdata{$_attrnamz[-1]} = ''; # window title
            $_verbose_attribute_names{$_attrnamz[-1]} = 'window_title';
push(@_attrnamz, '_tclr'); $_attrdata{$_attrnamz[-1]} = '!W'; # title color
            $_verbose_attribute_names{$_attrnamz[-1]} = 'window_title_color';
push(@_attrnamz, '_dndx'); $_attrdata{$_attrnamz[-1]} = 0;    # DISPSTAK index
            $_verbose_attribute_names{$_attrnamz[-1]} = 'display_stack_index';
# Flags, storage Values, && extended attributes
push(@_attrnamz, '_flagaudr'); $_attrdata{$_attrnamz[-1]} = 1; # Auto Draw()
                $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_auto_draw';
push(@_attrnamz, '_flagmaxi'); $_attrdata{$_attrnamz[-1]} = 1; # Maximize
                $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_maximize';
push(@_attrnamz, '_flagshrk'); $_attrdata{$_attrnamz[-1]} = 1; # ShrinkToFit
       $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_shrink_to_fit';
push(@_attrnamz, '_flagcntr'); $_attrdata{$_attrnamz[-1]} = 1; # Center
                $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_center';
push(@_attrnamz, '_flagcvis'); $_attrdata{$_attrnamz[-1]} = 0; # CursorVisible
       $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_cursor_visible';
push(@_attrnamz, '_flagscrl'); $_attrdata{$_attrnamz[-1]} = 0; # Scrollbar
                $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_scrollbar';
push(@_attrnamz, '_flagsdlk'); $_attrdata{$_attrnamz[-1]} = 0; # SDLK
                $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_sdl_key';
push(@_attrnamz, '_flagbkgr'); $_attrdata{$_attrnamz[-1]} = 0; # background
                $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_background';
push(@_attrnamz, '_flagfram'); $_attrdata{$_attrnamz[-1]} = 0; # Time::Frame
                $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_time_frame';
push(@_attrnamz, '_flagmili'); $_attrdata{$_attrnamz[-1]} = 0; # millisecond
                $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_millisecond';
push(@_attrnamz, '_flagprin'); $_attrdata{$_attrnamz[-1]} = 1; # Prnt into self
                $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_print_into';
push(@_attrnamz, '_flaginsr'); $_attrdata{$_attrnamz[-1]} = 1; # insert mode
                $_verbose_attribute_names{$_attrnamz[-1]} = 'flag_insert_mode';
push(@_attrnamz, '_valulasp'); $_attrdata{$_attrnamz[-1]} = undef; # last pair
                $_verbose_attribute_names{$_attrnamz[-1]} = 'last_pair';
push(@_attrnamz, '_valullsp'); $_attrdata{$_attrnamz[-1]} = undef; # llastpair
                $_verbose_attribute_names{$_attrnamz[-1]} = 'last_last_pair';
push(@_attrnamz, '_valulasb'); $_attrdata{$_attrnamz[-1]} = undef; # last bold
                $_verbose_attribute_names{$_attrnamz[-1]} = 'last_bold';
push(@_attrnamz, '_valullsb'); $_attrdata{$_attrnamz[-1]} = undef; # llastbold
                $_verbose_attribute_names{$_attrnamz[-1]} = 'last_last_bold';
push(@_attrnamz, '_valudol8'); $_attrdata{$_attrnamz[-1]} = undef; # do late
              $_verbose_attribute_names{$_attrnamz[-1]} = 'late_escaped_print';

# methods
sub _default_value   { my ($self, $attr) = @_; $_attrdata{$attr}; } # Dflt vals
sub _attribute_names { @_attrnamz; } # attribute names

# MkMethdz creates Simp object field accessor methods with 
#   configurable handling && overrideable default operations.  Beppu@CPAN.Org
#   coded the first version of MkMethdz && taught me a new trick as such. =)
# Special Parameters:
#   NAME => name of the method to be created
#   ARAY => if this is true, $self->{$attr} is assumed to be
#           an array ref, and default subcommands are installed
#   LOOP => ...
#   nmrc => sub reference for handling a numeric subcommand
# The rest of the parameters should be key/value pairs where:
#   subcommand => subroutine reference
sub MkMethdz {
  my %cmnd = @_;
  my $meth = $cmnd{'NAME'} || die('NAME => required!'); delete($cmnd{'NAME'});
  my $aray = $cmnd{'ARAY'} || 0;                        delete($cmnd{'ARAY'});
  my $rsiz = $cmnd{'RSIZ'} || 0;                        delete($cmnd{'RSIZ'});
  my $mvwn = $cmnd{'MVWN'} || 0;                        delete($cmnd{'MVWN'});
  my $mvcr = $cmnd{'MVCR'} || 0;                        delete($cmnd{'MVCR'});
  my $updt = $cmnd{'UPDT'} || 0;                        delete($cmnd{'UPDT'});
  my $curs = $cmnd{'CURS'} || 0;                        delete($cmnd{'CURS'});
  my $loop = $cmnd{'LOOP'} || 0;                        delete($cmnd{'LOOP'});
  my $excc = $cmnd{'EXCC'} || 0;                        delete($cmnd{'EXCC'});
  my $dstk = $cmnd{'DSTK'} || 0;                        delete($cmnd{'DSTK'});
  my $attr = '_' . lc($meth);
  $cmnd{'asin'} ||= sub { # Dflt assign command
    my $self = shift; my $nwvl = shift;
    if(!$dstk || (0 <= $nwvl && $nwvl < @DISPSTAK)) {
      if($dstk && $self->{'_dndx'} != $nwvl) { # exchange displaystack indices 
        $DISPSTAK[ $nwvl           ]->{'_dndx'} = $self->{'_dndx'};
        ($DISPSTAK[$nwvl           ], $DISPSTAK[$self->{'_dndx'}]) =
        ($DISPSTAK[$self->{'_dndx'}], $DISPSTAK[$nwvl           ]);
      }
      $self->{$attr}   = $nwvl;
      $self->{'_chgd'} = 1;
    }
  };
  $cmnd{'blnk'} ||= sub { # Dflt blank  command
    my $self = shift;
    $self->{$attr}   = '';
    $self->{'_chgd'} = 1;
  };
  $cmnd{'togl'} ||= sub { # Dflt toggle command (for flags)
    my $self = shift;
    $self->{$attr}  ^= 1;
    $self->{'_chgd'} = 1;
  };
  $cmnd{'true'} ||= sub { # Dflt truth command (for flags)
    my $self = shift;
    $self->{$attr}   = 1;
    $self->{'_chgd'} = 1;
  };
  $cmnd{'fals'} ||= sub { # Dflt fals command (for flags)
    my $self = shift;
    $self->{$attr}   = 0;
    $self->{'_chgd'} = 1;
  };
  $cmnd{'incr'} ||= sub { # Dflt increment command
    my $self = shift; my $amnt = shift || 1;
    if(!$dstk || $self->{'_dndx'} < $#DISPSTAK) {
      if($dstk) { # exchange display stack indices 
        $DISPSTAK[ $self->{'_dndx'} + 1]->{'_dndx'}--;
        ($DISPSTAK[$self->{'_dndx'}    ], $DISPSTAK[$self->{'_dndx'} + 1]) =
        ($DISPSTAK[$self->{'_dndx'} + 1], $DISPSTAK[$self->{'_dndx'}    ]);
      }
      $self->{$attr} += $amnt;
      $self->{'_chgd'} = 1;
    }
  };
  $cmnd{'decr'} ||= sub { # Dflt decrement command
    my $self = shift; my $amnt = shift || 1;
    if(!$dstk || $self->{'_dndx'}) {
      if($dstk) { # exchange display stack indices 
        $DISPSTAK[ $self->{'_dndx'} - 1]->{'_dndx'}++;
        ($DISPSTAK[$self->{'_dndx'}    ], $DISPSTAK[$self->{'_dndx'} - 1]) =
        ($DISPSTAK[$self->{'_dndx'} - 1], $DISPSTAK[$self->{'_dndx'}    ]);
      }
      $self->{$attr} -= $amnt;
      $self->{'_chgd'} = 1;
    }
  };
  if($aray) { # default commands for when $self->{$attr} is an array ref 
    $cmnd{'push'} ||= sub { # Dflt push
      my $self = shift;
      push(@{$self->{$attr}}, shift);
      $self->{'_chgd'} = 1;
    };
    $cmnd{'pop'}  ||= sub { # Dflt pop
      my $self = shift;
      pop(@{$self->{$attr}});
      $self->{'_chgd'} = 1;
    };
    $cmnd{'popp'} ||= $cmnd{'pop'}; # handle 4ltr popp tooo =)
    $cmnd{'apnd'} ||= sub { # Dflt append to last line
      my $self = shift;
      if(@{$self->{$attr}}) { $self->{$attr}->[-1] .= shift;  }
      else                  { push(@{$self->{$attr}}, shift); }
      $self->{'_chgd'} = 1;
    };
    $cmnd{'dupl'} ||= sub { # Dflt duplicate last line or some line #
      my $self = shift; my $lndx = shift || -1;
      if(@{$self->{$attr}}) { 
        push(@{$self->{$attr}}, $self->{$attr}->[$lndx]);
      } else {
        push(@{$self->{$attr}}, '');
      }
      $self->{'_chgd'} = 1;
    };
    $cmnd{'size'} ||= sub { # return array size
      my $self = shift; return(scalar(@{$self->{$attr}}));
    };
    $cmnd{'data'} ||= sub { # set && return whole array data
      my $self = shift;
      @{$self->{$attr}} = shift if(@_);
      return(@{$self->{$attr}});
    };
    $cmnd{'nmrc'} ||= sub { # Dflt nmrc
      my ($self, $keey, $valu) = @_;
      if(defined($valu)) { # value exists to be assigned
        $self->{$attr}->[$keey] = $valu;
        $self->{'_chgd'} = 1;
      } else { # just return array line
        return($self->{$attr}->[$keey]);
      }
    };
  } else {
    $cmnd{'nmrc'} ||= sub { # Dflt nmrc for non-arrays
      my ($self, $keey, $valu) = @_;
      if(defined($valu)) { 
        # hmm I don't think non-array fields will have a numeric key && a val
        #  so I don't know what to do here yet
      } else { # just assign the key if no defined value
        if(!$dstk || (0 <= $keey && $keey < @DISPSTAK)) {
          if($dstk && $self->{'_dndx'} != $keey) { # xchg displaystack indices
            $DISPSTAK[ $keey           ]->{'_dndx'} = $self->{'_dndx'};
            ($DISPSTAK[$keey           ], $DISPSTAK[$self->{'_dndx'}]) =
            ($DISPSTAK[$self->{'_dndx'}], $DISPSTAK[$keey           ]);
          }
          $self->{$attr}   = $keey;
          $self->{'_chgd'} = 1;
        }
      }
    };
  }
  if($loop) { # default commands for when $self->{$attr} is a loop
    $cmnd{'next'} ||= sub { # Dflt next
      my $self = shift;
      $self->{$attr}++; # should get loop limit instead of hard @BORDSETS
      $self->{$attr} = 0 if($self->{$attr} > @BORDSETS);
      $self->{'_chgd'} = 1;
    };
    $cmnd{'prev'} ||= sub { # Dflt prev
      my $self = shift;
      $self->{$attr}--; # should get loop limit instead of hard @BORDSETS
      $self->{$attr} = @BORDSETS if($self->{$attr} < 0);
      $self->{'_chgd'} = 1;
    };
  }
  { # block to isolate no strict where closure gets defined
    no strict 'refs';
    *{$meth} = sub {
      my $self = shift; my ($keey, $valu);
      while(@_) {
        ($keey, $valu) = (shift, shift);
        if     ($keey =~ /\d+$/) { # call a special sub for numeric keyz 
          $cmnd{'nmrc'}->($self, $keey, $valu);
        } elsif( defined($cmnd{$keey})) {
          $cmnd{$keey}->($self, $valu);
        } elsif(!defined($valu)) {
          $self->{$attr} = $keey;
          $self->{'_chgd'} = 1;
        } elsif($keey eq lc($meth)) { # same as 'asin' with meth name instead
          $self->{"_$keey"} = $valu;
        } else {
          croak "!*EROR*! Curses::Simp::$meth key:$keey was not recognized!\n";
        }
      }
      $self->{$attr} = $self->ExpandCC($self->{$attr})      if($excc);
      curs_set($self->{'_flagcvis'})                        if($curs);
      ($self->{'_flagmaxi'}, $self->{'_flagshrk'}) = (0, 0) if($rsiz);
      ($self->{'_flagmaxi'}, $self->{'_flagcntr'}) = (0, 0) if($mvwn);
       $self->Move()                                        if($mvcr);
      if   ($self->{'_chgd'} && $self->{'_flagaudr'}) { $self->Draw(); }
      elsif($mvwn || $updt)                           { $self->Updt(); }
      elsif($rsiz)                                    { $self->Rsiz(); }
      $self->{'_chgd'} = 0;
      return($self->{$attr});
    };
    # also define verbose names as alternate accessor methods
    *{$_verbose_attribute_names{$attr}} = \&{$meth};
  }
}

MkMethdz( 'NAME' => 'Text', 'ARAY' => 1 );
MkMethdz( 'NAME' => 'Colr', 'ARAY' => 1 );
MkMethdz( 'NAME' => 'Hite', 'RSIZ' => 1 );
MkMethdz( 'NAME' => 'Widt', 'RSIZ' => 1 );
MkMethdz( 'NAME' => 'YOff', 'MVWN' => 1 );
MkMethdz( 'NAME' => 'XOff', 'MVWN' => 1 );
MkMethdz( 'NAME' => 'YCrs', 'MVCR' => 1 );
MkMethdz( 'NAME' => 'XCrs', 'MVCR' => 1 );
MkMethdz( 'NAME' => 'BTyp', 'LOOP' => 1 );
MkMethdz( 'NAME' => 'BClr', 'EXCC' => 1 );
MkMethdz( 'NAME' => 'Titl' );
MkMethdz( 'NAME' => 'TClr', 'EXCC' => 1 );
MkMethdz( 'NAME' => 'DNdx', 'DSTK' => 1 );
MkMethdz( 'NAME' => 'FlagAuDr' );
MkMethdz( 'NAME' => 'FlagMaxi', 'UPDT' => 1 );
MkMethdz( 'NAME' => 'FlagShrk', 'UPDT' => 1 );
MkMethdz( 'NAME' => 'FlagCntr', 'UPDT' => 1 );
MkMethdz( 'NAME' => 'FlagCVis', 'CURS' => 1 );
MkMethdz( 'NAME' => 'FlagScrl' );
MkMethdz( 'NAME' => 'FlagSDLK' );
MkMethdz( 'NAME' => 'FlagBkgr' );
MkMethdz( 'NAME' => 'FlagFram' );
MkMethdz( 'NAME' => 'FlagMili' );
MkMethdz( 'NAME' => 'FlagPrin' );
MkMethdz( 'NAME' => 'FlagInsr' );

sub InitPair { # internal sub to Initialize && Set Color Pairs
  my ($self, $fgcl, $bgcl) = @_; my ($bold, $curp) = (0, 0);
  return    unless(defined($fgcl) && $fgcl =~ /^([0-9a-z._]|-1)$/i);
  $bgcl = 0 unless(defined($bgcl));
  if(!$GLBL{'FLAGCOLR'} && has_colors()) { # init all pairs 1st time thru
    $GLBL{'FLAGCOLR'} = COLOR_PAIRS(); 
    for(my $i=0; $i<NumC(); $i++) {
      for(my $j=0; $j<NumC(); $j++) {
        init_pair(($j * NumC()) + $i + 1, $i, $j);# COLOR_PAIR index: 1-based
      }
    }
  }
  if($GLBL{'FLAGCOLR'}) {
    if($fgcl eq -1) { # return to last color pair && bold values
      $curp = $self->{'_valullsp'} if(defined($self->{'_valullsp'})); 
      $bold = $self->{'_valullsb'};
    } else {
      $fgcl = $clet{$fgcl} if(exists($clet{$fgcl}));
      $bgcl = $clet{$bgcl} if(exists($clet{$bgcl}));
      $fgcl = dec($fgcl) % 16 if($fgcl =~ /[A-Z]/i);
      $bgcl = dec($bgcl) %  8 if($bgcl =~ /[A-Z]/i);
      if($fgcl > 7) { $bold = 1; $fgcl = $fgcl - 8; }
      if($fgcl < 0 || $fgcl >= NumC()) { $fgcl = (NumC() - 1); }
      $bgcl = 0 unless(defined($bgcl) && $bgcl =~ /^\d+$/i);
      $bgcl -= NumC() if($bgcl >= NumC());
      $bgcl = 0 if($bgcl < 0 || $bgcl >= NumC()); 
      $curp = ($bgcl * NumC()) + $fgcl + 1;
    }
    if(defined($self->{'_wind'})) {
      if(!defined($self->{'_valulasp'}) || $self->{'_valulasp'} != $curp) {
        $self->{'_wind'}->attroff(COLOR_PAIR($self->{'_valulasp'})) if(defined($self->{'_valulasp'}));
        $self->{'_wind'}->attron( COLOR_PAIR($curp));
      }
      if($bold) { $self->{'_wind'}->attron( A_BOLD); }
      else      { $self->{'_wind'}->attroff(A_BOLD); }
      if(!defined($self->{'_valulasp'}) || !defined($self->{'_valulasb'}) || $self->{'_valulasp'} != $curp || $self->{'_valulasb'} != $bold) {
        $self->{'_valullsp'} = $self->{'_valulasp'};
        $self->{'_valulasp'} = $curp;
        $self->{'_valullsb'} = $self->{'_valulasb'};
        $self->{'_valulasb'} = $bold;
      }
    }
  }
  return($curp);
}

sub BordChar { # return characters for different border types
  my ($self, $loca, $noip) = @_; 
  unless($noip) { # No InitPair flag to say border color staying same
    my ($fgcl, $bgcl) = split(//, $self->{'_bclr'});
    $self->InitPair($fgcl, $bgcl);
  }
  $self->{'_wind'}->addch( $BORDSETS[($self->{'_btyp'} - 1)]{lc($loca)} );
}

sub ExpandCC { # fill out abbreviations in color code strings
  my $self = shift; my $ccod = shift; my $bkgd = shift; 
  my @mtch; my @chrz; my $btai;
  $bkgd = $self->{'_flagbkgr'} unless(defined $bkgd);
  if($bkgd) { # expand color code pairs including background
    $btai = $1 if($ccod =~ s/$GLBL{'CHARSIMP'}(.+)$//);
    $ccod =~ s/$GLBL{'CHARADVN'}//g;
    while($ccod =~ /[\.x]/i) { 
      @mtch = ();
      if     ($ccod =~ /^(([^\.][^\.])*?)\.(.)([^\.]*)\.?/) { # rep bg
        $mtch[0] = $1; $mtch[1] = $2; $mtch[2] = $3; $mtch[3] = $4; 
        if(length($mtch[3])) {
          $mtch[4] = $mtch[3];
          while($mtch[4] =~ /(.)x(.)/i) {
            $mtch[5] = $1; $mtch[6] = $2;
            $mtch[5] .= $mtch[5] x (b10($mtch[6]) - 1);
            $mtch[4] =~ s/.x./$mtch[5]/i;
          }
          $mtch[7] = join($mtch[2], split(//, $mtch[4])) . $mtch[2];
        }
        $ccod =~ s/\.$mtch[2]$mtch[3]\.?/$mtch[7]/;
      } elsif($ccod =~ /^(([^\.][^\.])*?)(.)\.([^\.]*)\.?/) { # rep fg
        $mtch[0] = $1; $mtch[1] = $2; $mtch[2] = $3; $mtch[3] = $4; 
        if(length($mtch[3])) {
          $mtch[4] = $mtch[3];
          while($mtch[4] =~ /(.)x(.)/i) {
            $mtch[5] = $1; $mtch[6] = $2;
            $mtch[5] .= $mtch[5] x (b10($mtch[6]) - 1);
            $mtch[4] =~ s/.x./$mtch[5]/i;
          }
          $mtch[7] = $mtch[2] . join($mtch[2], split(//, $mtch[4]));
        }
        $ccod =~ s/$mtch[2]\.$mtch[3]\.?/$mtch[7]/;
      } elsif($ccod =~ /(..)x(.)/) {      # rep (fg/bg | bg/fg) x $2
        $mtch[0] = $1; $mtch[1] = $2; 
        $mtch[7] = $mtch[0] x (b10($mtch[1]) - 1);
        $ccod =~ s/x$mtch[1]/$mtch[7]/;
      } elsif($ccod =~ /^(..)*?.(.)X(.)/){ # rep bg X $3
        $mtch[0] = $1; $mtch[1] = $2; $mtch[2] = $3;
        $mtch[3] = (b10($mtch[2]) - 1);
        $ccod =~ /X$mtch[2](.{0,$mtch[3]})/;
        $mtch[4] = $1;
        if(length($mtch[4])) {
          $mtch[5] = $mtch[4];
          $mtch[5] =~ s/\.//g;
          while($mtch[5] =~ /(.)x(.)/i) {
            $mtch[0] = $1; $mtch[6] = $2;
            $mtch[0] .= $mtch[0] x (b10($mtch[6]) - 1);
            $mtch[5] =~ s/.x./$mtch[0]/i;
          }
          if(length($mtch[5]) < $mtch[3]) {
            $mtch[5] .= substr($mtch[5], -1, 1) x 
                          ($mtch[3] - length($mtch[5]));
          }
          $mtch[7] = join($mtch[1], split(//, $mtch[5])) . $mtch[1];
        }
        $ccod =~ s/X$mtch[2]$mtch[4]/$mtch[7]/;
      } elsif($ccod =~ /^(..)*?(.)X(.)/) { # rep fg X $3
        $mtch[0] = $1; $mtch[1] = $2; $mtch[2] = $3;
        $mtch[3] = b10($mtch[2]);
        $ccod =~ /X$mtch[2](.{0,$mtch[3]})/;
        $mtch[4] = $1;
        if(length($mtch[4])) {
          $mtch[5] = $mtch[4];
          $mtch[5] =~ s/\.//g;
          while($mtch[5] =~ /(.)x(.)/i) {
            $mtch[0] = $1; $mtch[6] = $2;
            $mtch[0] .= $mtch[0] x (b10($mtch[6]) - 1);
            $mtch[5] =~ s/.x./$mtch[0]/i;
          }
          if(length($mtch[5]) < $mtch[3]) {
            $mtch[5] .= substr($mtch[5], -1, 1) x 
                          ($mtch[3] - length($mtch[5]));
          }
          $mtch[7] = $mtch[1] . join($mtch[1], split(//, $mtch[5]));
        }
        $ccod =~ s/$mtch[1]X$mtch[2]$mtch[4]/$mtch[7]/;
      } elsif($ccod =~ s/^(.?)x.?/$1/) {            # strip bad tags
      } elsif($ccod =~ s/(^x.?|x$)//i) {            # strip bad tags
      }
    }
    $ccod .= $self->ExpandCC($btai, 0) if(defined $btai);
  } else {
    $btai = $1 if($ccod =~ s/$GLBL{'CHARADVN'}(.+)$//);
    $ccod =~ s/$GLBL{'CHARSIMP'}//g;
    while($ccod =~ /(.)x(.)/) { # rep fg x $2
      @mtch = ();
      $mtch[0] = $1; $mtch[1] = $2; 
      $mtch[7] = $mtch[0] x (b10($mtch[1]) - 1);
      $ccod =~ s/x$mtch[1]/$mtch[7]/;
    }
    $ccod =~ s/^(.?)x.?/$1/g; # strip bad tags
    $ccod =~ s/(^x.?|x$)//gi; # strip bad tags
    $ccod = join('b', split(//, $ccod)); $ccod .= 'b' if(length($ccod) % 2);
    $ccod =~ s/,b(.)b(.)b/$1$2/g;
    while($ccod =~ /([X,:]|$GLBL{'CHARADVN'})/) {
      @mtch = ();
      if     ($ccod =~ s/(.)bXb(.)b/X/) {
        $mtch[0] = $1; $mtch[1] = $2; 
        $ccod =~ s/X(.)b/$1$mtch[0]X/ for(1..b10($mtch[1]));
        $ccod =~ s/X//;
      } elsif($ccod =~ s/:b(.)b(.)/:$2/) {
        $mtch[0] = $1; $mtch[1] = $2;
        while($mtch[1] ne ':') {
          $ccod =~ s/:(.)./$1$mtch[0]:/;
          $mtch[1] = $1;
          $mtch[1] = ':' if($ccod !~ /:./ && $ccod =~ /:$/);
        }
        $ccod =~ s/://;
      }
    }
    $ccod .= $self->ExpandCC($btai, 1) if(defined $btai);
  }
  $ccod =~ s/ /b/g; # spaces in color codes are just black
  return($ccod);
}

sub ShokScrn { # shock (redraw) the entire screen && all windows in order
  my $self = shift; # clear() every time? or just with flag?
  my ($ycrs, $xcrs);
  clear() if(shift);  touchwin(); refresh();
  foreach(@DISPSTAK) {
    ${$_}->{'_wind'}->touchwin();
#    ${$_}->Move(); # just Move()?
    if(${$_}->{'_valudol8'}) {
      ${$_}->{'_wind'}->refresh();
      ${$_}->{'_wind'}->getyx($ycrs, $xcrs);
      print(${$_}->{'_valudol8'});
      printf("\e[%d;%dH",   $ycrs + 1, $xcrs);
      if($ycrs != ${$_}->{'_ycrs'} || $xcrs != ${$_}->{'_xcrs'}) {
        ${$_}->{'_wind'}->move(          $ycrs,                $xcrs);
        ${$_}->{'_wind'}->getyx(${$_}->{'_ycrs'},     ${$_}->{'_xcrs'});
        if(${$_}->{'_btyp'}) {  ${$_}->{'_ycrs'}--;   ${$_}->{'_xcrs'}--; }
      }
    }
    ${$_}->{'_wind'}->refresh();
  }
}

sub KNum { return %knum; }
sub CLet { return %clet; }
sub OScr { 
  unless($GLBL{'FLAGOPEN'}) {
    $GLBL{'FLAGOPEN'} = 1; initscr(); noecho(); nonl(); raw(); 
    start_color(); curs_set(0); keypad(1); meta(1); intrflush(0); 
    notimeout(0); timeout(0); 
    clear(); move((getmaxy() - 1), (getmaxx() - 1)); refresh();
    # raw() allows ^C,^S,^Z to pass through unlike cbreak()
    #   but requires `reset` on cmdline if app crashes
    # use nodelay()/timeout(-1) for non/blocking getch()
    # napms($ms) to nap for a few millisecs
    @BORDSETS = ( # initscr initializes line-draw chars for my border hash
      {
        'ul' => ACS_ULCORNER,                  'ur' => ACS_URCORNER,
                     'rt' => ACS_RTEE,  'lt' => ACS_LTEE,  
                     'hl' => ACS_HLINE, 'vl' => ACS_VLINE, 
        'll' => ACS_LLCORNER,                  'lr' => ACS_LRCORNER,
      },
      { 
        'ul' => ' ', 'rt' => ' ', 'lt' => ' ', 'ur' => ' ',
        'll' => ' ', 'hl' => ' ', 'vl' => ' ', 'lr' => ' ',
      },
      {
        'ul' => '+', 'rt' => '{', 'lt' => '}', 'ur' => '+',
        'll' => '+', 'hl' => '-', 'vl' => '|', 'lr' => '+',
      },
    );
    @kndx = (
      ERR                    , OK                     , ACS_BLOCK             ,
      ACS_BOARD              , ACS_BTEE               , ACS_BULLET            ,
      ACS_CKBOARD            , ACS_DARROW             , ACS_DEGREE            ,
      ACS_DIAMOND            , ACS_HLINE              , ACS_LANTERN           ,
      ACS_LARROW             , ACS_LLCORNER           , ACS_LRCORNER          ,
      ACS_LTEE               , ACS_PLMINUS            , ACS_PLUS              ,
      ACS_RARROW             , ACS_RTEE               , ACS_S1                ,
      ACS_S9                 , ACS_TTEE               , ACS_UARROW            ,
      ACS_ULCORNER           , ACS_URCORNER           , ACS_VLINE             ,
      A_ALTCHARSET           , A_ATTRIBUTES           , A_BLINK               ,
      A_BOLD                 , A_CHARTEXT             , A_COLOR               ,
      A_DIM                  , A_INVIS                , A_NORMAL              ,
      A_PROTECT              , A_REVERSE              , A_STANDOUT            ,
      A_UNDERLINE            , COLOR_BLACK            , COLOR_BLUE            ,
      COLOR_CYAN             , COLOR_GREEN            , COLOR_MAGENTA         ,
      COLOR_RED              , COLOR_WHITE            , COLOR_YELLOW          ,
      KEY_A1                 , KEY_A3                 , KEY_B2                ,
      KEY_BACKSPACE          , KEY_BEG                , KEY_BREAK             ,
      KEY_BTAB               , KEY_C1                 , KEY_C3                ,
      KEY_CANCEL             , KEY_CATAB              , KEY_CLEAR             ,
      KEY_CLOSE              , KEY_COMMAND            , KEY_COPY              ,
      KEY_CREATE             , KEY_CTAB               , KEY_DC                ,
      KEY_DL                 , KEY_DOWN               , KEY_EIC               ,
      KEY_END                , KEY_ENTER              , KEY_EOL               ,
      KEY_EOS                , KEY_EXIT               , KEY_F0                ,
      KEY_FIND               , KEY_HELP               , KEY_HOME              ,
      KEY_IC                 , KEY_IL                 , KEY_LEFT              ,
      KEY_LL                 , KEY_MARK               , KEY_MAX               ,
      KEY_MESSAGE            , KEY_MIN                , KEY_MOVE              ,
      KEY_NEXT               , KEY_NPAGE              , KEY_OPEN              ,
      KEY_OPTIONS            , KEY_PPAGE              , KEY_PREVIOUS          ,
      KEY_PRINT              , KEY_REDO               , KEY_REFERENCE         ,
      KEY_REFRESH            , KEY_REPLACE            , KEY_RESET             ,
      KEY_RESTART            , KEY_RESUME             , KEY_RIGHT             ,
      KEY_SAVE               , KEY_SBEG               , KEY_SCANCEL           ,
      KEY_SCOMMAND           , KEY_SCOPY              , KEY_SCREATE           ,
      KEY_SDC                , KEY_SDL                , KEY_SELECT            ,
      KEY_SEND               , KEY_SEOL               , KEY_SEXIT             ,
      KEY_SF                 , KEY_SFIND              , KEY_SHELP             ,
      KEY_SHOME              , KEY_SIC                , KEY_SLEFT             ,
      KEY_SMESSAGE           , KEY_SMOVE              , KEY_SNEXT             ,
      KEY_SOPTIONS           , KEY_SPREVIOUS          , KEY_SPRINT            ,
      KEY_SR                 , KEY_SREDO              , KEY_SREPLACE          ,
      KEY_SRESET             , KEY_SRIGHT             , KEY_SRSUME            ,
      KEY_SSAVE              , KEY_SSUSPEND           , KEY_STAB              ,
      KEY_SUNDO              , KEY_SUSPEND            , KEY_UNDO              ,
      KEY_UP                 , KEY_MOUSE              , BUTTON1_RELEASED      ,
      BUTTON1_PRESSED        , BUTTON1_CLICKED        , BUTTON1_DOUBLE_CLICKED,
      BUTTON1_TRIPLE_CLICKED , BUTTON1_RESERVED_EVENT , BUTTON2_RELEASED      ,
      BUTTON2_PRESSED        , BUTTON2_CLICKED        , BUTTON2_DOUBLE_CLICKED,
      BUTTON2_TRIPLE_CLICKED , BUTTON2_RESERVED_EVENT , BUTTON3_RELEASED      ,
      BUTTON3_PRESSED        , BUTTON3_CLICKED        , BUTTON3_DOUBLE_CLICKED,
      BUTTON3_TRIPLE_CLICKED , BUTTON3_RESERVED_EVENT , BUTTON4_RELEASED      ,
      BUTTON4_PRESSED        , BUTTON4_CLICKED        , BUTTON4_DOUBLE_CLICKED,
      BUTTON4_TRIPLE_CLICKED , BUTTON4_RESERVED_EVENT , BUTTON_CTRL           ,
      BUTTON_SHIFT           , BUTTON_ALT             , ALL_MOUSE_EVENTS      ,
      REPORT_MOUSE_POSITION  , NCURSES_MOUSE_VERSION );# , E_OK                  ,
#     E_SYSTEM_ERROR         , E_BAD_ARGUMENT         , E_POSTED              ,
#     E_CONNECTED            , E_BAD_STATE            , E_NO_ROOM             ,
#     E_NOT_POSTED           , E_UNKNOWN_COMMAND      , E_NO_MATCH            ,
#     E_NOT_SELECTABLE       , E_NOT_CONNECTED        , E_REQUEST_DENIED      ,
#     E_INVALID_FIELD        , E_CURRENT              , REQ_LEFT_ITEM         ,
#     REQ_RIGHT_ITEM         , REQ_UP_ITEM            , REQ_DOWN_ITEM         ,
#     REQ_SCR_ULINE          , REQ_SCR_DLINE          , REQ_SCR_DPAGE         ,
#     REQ_SCR_UPAGE          , REQ_FIRST_ITEM         , REQ_LAST_ITEM         ,
#     REQ_NEXT_ITEM          , REQ_PREV_ITEM          , REQ_TOGGLE_ITEM       ,
#     REQ_CLEAR_PATTERN      , REQ_BACK_PATTERN       , REQ_NEXT_MATCH        ,
#     REQ_PREV_MATCH         , MIN_MENU_COMMAND       , MAX_MENU_COMMAND      ,
#     O_ONEVALUE             , O_SHOWDESC             , O_ROWMAJOR            ,
#     O_IGNORECASE           , O_SHOWMATCH            , O_NONCYCLIC           ,
#     O_SELECTABLE           , REQ_NEXT_PAGE          , REQ_PREV_PAGE         ,
#     REQ_FIRST_PAGE         , REQ_LAST_PAGE          , REQ_NEXT_FIELD        ,
#     REQ_PREV_FIELD         , REQ_FIRST_FIELD        , REQ_LAST_FIELD        ,
#     REQ_SNEXT_FIELD        , REQ_SPREV_FIELD        , REQ_SFIRST_FIELD      ,
#     REQ_SLAST_FIELD        , REQ_LEFT_FIELD         , REQ_RIGHT_FIELD       ,
#     REQ_UP_FIELD           , REQ_DOWN_FIELD         , REQ_NEXT_CHAR         ,
#     REQ_PREV_CHAR          , REQ_NEXT_LINE          , REQ_PREV_LINE         ,
#     REQ_NEXT_WORD          , REQ_PREV_WORD          , REQ_BEG_FIELD         ,
#     REQ_END_FIELD          , REQ_BEG_LINE           , REQ_END_LINE          ,
#     REQ_LEFT_CHAR          , REQ_RIGHT_CHAR         , REQ_UP_CHAR           ,
#     REQ_DOWN_CHAR          , REQ_NEW_LINE           , REQ_INS_CHAR          ,
#     REQ_INS_LINE           , REQ_DEL_CHAR           , REQ_DEL_PREV          ,
#     REQ_DEL_LINE           , REQ_DEL_WORD           , REQ_CLR_EOL           ,
#     REQ_CLR_EOF            , REQ_CLR_FIELD          , REQ_OVL_MODE          ,
#     REQ_INS_MODE           , REQ_SCR_FLINE          , REQ_SCR_BLINE         ,
#     REQ_SCR_FPAGE          , REQ_SCR_BPAGE          , REQ_SCR_FHPAGE        ,
#     REQ_SCR_BHPAGE         , REQ_SCR_FCHAR          , REQ_SCR_BCHAR         ,
#     REQ_SCR_HFLINE         , REQ_SCR_HBLINE         , REQ_SCR_HFHALF        ,
#     REQ_SCR_HBHALF         , REQ_VALIDATION         , REQ_NEXT_CHOICE       ,
#     REQ_PREV_CHOICE        , MIN_FORM_COMMAND       , MAX_FORM_COMMAND      ,
#     NO_JUSTIFICATION       , JUSTIFY_LEFT           , JUSTIFY_CENTER        ,
#     JUSTIFY_RIGHT          , O_VISIBLE              , O_ACTIVE              ,
#     O_PUBLIC               , O_EDIT                 , O_WRAP                ,
#     O_BLANK                , O_AUTOSKIP             , O_NULLOK              ,
#     O_PASSOK               , O_STATIC               , O_NL_OVERLOAD         ,
#     O_BS_OVERLOAD          );
my @knam = qw(
      ERR                      OK                       ACS_BLOCK              
      ACS_BOARD                ACS_BTEE                 ACS_BULLET             
      ACS_CKBOARD              ACS_DARROW               ACS_DEGREE             
      ACS_DIAMOND              ACS_HLINE                ACS_LANTERN            
      ACS_LARROW               ACS_LLCORNER             ACS_LRCORNER           
      ACS_LTEE                 ACS_PLMINUS              ACS_PLUS               
      ACS_RARROW               ACS_RTEE                 ACS_S1                 
      ACS_S9                   ACS_TTEE                 ACS_UARROW             
      ACS_ULCORNER             ACS_URCORNER             ACS_VLINE              
      A_ALTCHARSET             A_ATTRIBUTES             A_BLINK                
      A_BOLD                   A_CHARTEXT               A_COLOR                
      A_DIM                    A_INVIS                  A_NORMAL               
      A_PROTECT                A_REVERSE                A_STANDOUT             
      A_UNDERLINE              COLOR_BLACK              COLOR_BLUE             
      COLOR_CYAN               COLOR_GREEN              COLOR_MAGENTA          
      COLOR_RED                COLOR_WHITE              COLOR_YELLOW           
      KEY_A1                   KEY_A3                   KEY_B2                 
      KEY_BACKSPACE            KEY_BEG                  KEY_BREAK              
      KEY_BTAB                 KEY_C1                   KEY_C3                 
      KEY_CANCEL               KEY_CATAB                KEY_CLEAR              
      KEY_CLOSE                KEY_COMMAND              KEY_COPY               
      KEY_CREATE               KEY_CTAB                 KEY_DC                 
      KEY_DL                   KEY_DOWN                 KEY_EIC                
      KEY_END                  KEY_ENTER                KEY_EOL                
      KEY_EOS                  KEY_EXIT                 KEY_F0                 
      KEY_FIND                 KEY_HELP                 KEY_HOME               
      KEY_IC                   KEY_IL                   KEY_LEFT               
      KEY_LL                   KEY_MARK                 KEY_MAX                
      KEY_MESSAGE              KEY_MIN                  KEY_MOVE               
      KEY_NEXT                 KEY_NPAGE                KEY_OPEN               
      KEY_OPTIONS              KEY_PPAGE                KEY_PREVIOUS           
      KEY_PRINT                KEY_REDO                 KEY_REFERENCE          
      KEY_REFRESH              KEY_REPLACE              KEY_RESET              
      KEY_RESTART              KEY_RESUME               KEY_RIGHT              
      KEY_SAVE                 KEY_SBEG                 KEY_SCANCEL            
      KEY_SCOMMAND             KEY_SCOPY                KEY_SCREATE            
      KEY_SDC                  KEY_SDL                  KEY_SELECT             
      KEY_SEND                 KEY_SEOL                 KEY_SEXIT              
      KEY_SF                   KEY_SFIND                KEY_SHELP              
      KEY_SHOME                KEY_SIC                  KEY_SLEFT              
      KEY_SMESSAGE             KEY_SMOVE                KEY_SNEXT              
      KEY_SOPTIONS             KEY_SPREVIOUS            KEY_SPRINT             
      KEY_SR                   KEY_SREDO                KEY_SREPLACE           
      KEY_SRESET               KEY_SRIGHT               KEY_SRSUME             
      KEY_SSAVE                KEY_SSUSPEND             KEY_STAB               
      KEY_SUNDO                KEY_SUSPEND              KEY_UNDO               
      KEY_UP                   KEY_MOUSE                BUTTON1_RELEASED       
      BUTTON1_PRESSED          BUTTON1_CLICKED          BUTTON1_DOUBLE_CLICKED 
      BUTTON1_TRIPLE_CLICKED   BUTTON1_RESERVED_EVENT   BUTTON2_RELEASED       
      BUTTON2_PRESSED          BUTTON2_CLICKED          BUTTON2_DOUBLE_CLICKED 
      BUTTON2_TRIPLE_CLICKED   BUTTON2_RESERVED_EVENT   BUTTON3_RELEASED       
      BUTTON3_PRESSED          BUTTON3_CLICKED          BUTTON3_DOUBLE_CLICKED 
      BUTTON3_TRIPLE_CLICKED   BUTTON3_RESERVED_EVENT   BUTTON4_RELEASED       
      BUTTON4_PRESSED          BUTTON4_CLICKED          BUTTON4_DOUBLE_CLICKED 
      BUTTON4_TRIPLE_CLICKED   BUTTON4_RESERVED_EVENT   BUTTON_CTRL            
      BUTTON_SHIFT             BUTTON_ALT               ALL_MOUSE_EVENTS       
      REPORT_MOUSE_POSITION    NCURSES_MOUSE_VERSION   );# E_OK                   
#     E_SYSTEM_ERROR           E_BAD_ARGUMENT           E_POSTED               
#     E_CONNECTED              E_BAD_STATE              E_NO_ROOM              
#     E_NOT_POSTED             E_UNKNOWN_COMMAND        E_NO_MATCH             
#     E_NOT_SELECTABLE         E_NOT_CONNECTED          E_REQUEST_DENIED       
#     E_INVALID_FIELD          E_CURRENT                REQ_LEFT_ITEM          
#     REQ_RIGHT_ITEM           REQ_UP_ITEM              REQ_DOWN_ITEM          
#     REQ_SCR_ULINE            REQ_SCR_DLINE            REQ_SCR_DPAGE          
#     REQ_SCR_UPAGE            REQ_FIRST_ITEM           REQ_LAST_ITEM          
#     REQ_NEXT_ITEM            REQ_PREV_ITEM            REQ_TOGGLE_ITEM        
#     REQ_CLEAR_PATTERN        REQ_BACK_PATTERN         REQ_NEXT_MATCH         
#     REQ_PREV_MATCH           MIN_MENU_COMMAND         MAX_MENU_COMMAND       
#     O_ONEVALUE               O_SHOWDESC               O_ROWMAJOR             
#     O_IGNORECASE             O_SHOWMATCH              O_NONCYCLIC            
#     O_SELECTABLE             REQ_NEXT_PAGE            REQ_PREV_PAGE          
#     REQ_FIRST_PAGE           REQ_LAST_PAGE            REQ_NEXT_FIELD         
#     REQ_PREV_FIELD           REQ_FIRST_FIELD          REQ_LAST_FIELD         
#     REQ_SNEXT_FIELD          REQ_SPREV_FIELD          REQ_SFIRST_FIELD       
#     REQ_SLAST_FIELD          REQ_LEFT_FIELD           REQ_RIGHT_FIELD        
#     REQ_UP_FIELD             REQ_DOWN_FIELD           REQ_NEXT_CHAR          
#     REQ_PREV_CHAR            REQ_NEXT_LINE            REQ_PREV_LINE          
#     REQ_NEXT_WORD            REQ_PREV_WORD            REQ_BEG_FIELD          
#     REQ_END_FIELD            REQ_BEG_LINE             REQ_END_LINE           
#     REQ_LEFT_CHAR            REQ_RIGHT_CHAR           REQ_UP_CHAR            
#     REQ_DOWN_CHAR            REQ_NEW_LINE             REQ_INS_CHAR           
#     REQ_INS_LINE             REQ_DEL_CHAR             REQ_DEL_PREV           
#     REQ_DEL_LINE             REQ_DEL_WORD             REQ_CLR_EOL            
#     REQ_CLR_EOF              REQ_CLR_FIELD            REQ_OVL_MODE           
#     REQ_INS_MODE             REQ_SCR_FLINE            REQ_SCR_BLINE          
#     REQ_SCR_FPAGE            REQ_SCR_BPAGE            REQ_SCR_FHPAGE         
#     REQ_SCR_BHPAGE           REQ_SCR_FCHAR            REQ_SCR_BCHAR          
#     REQ_SCR_HFLINE           REQ_SCR_HBLINE           REQ_SCR_HFHALF         
#     REQ_SCR_HBHALF           REQ_VALIDATION           REQ_NEXT_CHOICE        
#     REQ_PREV_CHOICE          MIN_FORM_COMMAND         MAX_FORM_COMMAND       
#     NO_JUSTIFICATION         JUSTIFY_LEFT             JUSTIFY_CENTER         
#     JUSTIFY_RIGHT            O_VISIBLE                O_ACTIVE               
#     O_PUBLIC                 O_EDIT                   O_WRAP                 
#     O_BLANK                  O_AUTOSKIP               O_NULLOK               
#     O_PASSOK                 O_STATIC                 O_NL_OVERLOAD          
#     O_BS_OVERLOAD          );
    # load $knum{CONSTANT_KEY_NUMBER_VALUE} => "CONSTANT_KEY_NAME_STRING"
    for($i = 0; $i < @kndx; $i++) { 
      $knum{"$kndx[$i]"} = "$knam[$i]" if(defined($knam[$i])); 
    } 
    # add my own new additional key<->num mappings (ie. 265..276 => F1..F12)
    for($i = 265; $i <= 276; $i++) { $knum{"$i"} = "KEY_F" . ($i-264); }
  }
  return(); 
}
# Following are Curses funcs that might be useful to call in CloseScreen():
#   termname(), erasechar(), killchar()
sub CScr { 
  if($GLBL{'FLAGOPEN'}) { 
    $GLBL{'FLAGOPEN'} = 0; 
    ${$DISPSTAK[0]}->DelW() while(@DISPSTAK);
    return(endwin()); 
  }
}
sub NumC { return(COLORS()); }

# Curses::Simp object constructor as class method or copy as object method.
# First param can be ref to copy.  Not including optional ref from 
#   copy, default is no params to create a new empty Simp object.
# If params are supplied, they must be hash key => value pairs.
sub new { 
  OScr() unless($GLBL{'FLAGOPEN'}); # need Open main Screen for new Simp obj
  my ($nvkr, $cork) = @_; my ($keey, $valu);
  my $nobj = ref($nvkr);
  my $clas = $cork; # Class OR Key
  $clas = $nobj || $nvkr if(!defined($cork) || $cork !~ /::/);
  my $self = bless({}, $clas);
  foreach my $attr ( $self->_attribute_names() ) { 
    $self->{$attr} = $self->_default_value($attr); # init defaults
    $self->{$attr} = $nvkr->{$attr} if($nobj);     #  && copy if supposed to
  }
  foreach(@KMODNAMZ) { $self->{'_kmod'}->{$_} = 0; }
  # there were init params with no colon (classname)
  if(defined($cork) && $cork !~ /::/) { 
    $nvkr = shift if($nvkr =~ /::/);
    while(@_) {
      my $foun = 0;
      ($keey, $valu) = (shift, shift);
      foreach my $attr ( $self->_attribute_names() ) { 
        if($attr =~ /$keey/i) {
          $self->{$attr} = $valu;
          $foun = 1;
        }
      }
      unless($foun) {
# detect non-matching verbose names here
#        if     ($keey =~ /^t/i) {    # 'text'
#        } elsif($keey =~ /^[la]/i) { # 'list' or 'array'
#        } elsif($keey =~ /^h/i) {    # 'hash'
#        } else { # unrecognized init key name
          croak "!*EROR*! Curses::Simp::new initialization key:$keey was not recognized!\n";
#        }
      }
    }
  }
  $self->{'_bclr'} = $self->ExpandCC($self->{'_bclr'});
  $self->{'_flagshrk'} = 0 if($self->{'_hite'} && $self->{'_widt'});
  $self->Updt(1);
  $self->{'_wind'} = newwin($self->{'_hite'}, $self->{'_widt'}, 
                            $self->{'_yoff'}, $self->{'_xoff'});
  unless(exists($self->{'_wind'}) && defined($self->{'_wind'})) {
    croak "!*EROR*! Curses::Simp::new could not create new window with hite:$self->{'_hite'}, widt:$self->{'_widt'}, yoff:$self->{'_yoff'}, xoff:$self->{'_xoff'}!\n";
  }
  # newwin doesn't auto draw so if there's init _text && autodraw is on...
  if($self->{'_text'} && @{$self->{'_text'}} && $self->{'_flagaudr'}) {
    $self->Draw();
  }
  $self->Move(-1, -1) unless($self->{'_ycrs'} || $self->{'_xcrs'});
  curs_set($self->{'_flagcvis'}); # set cursor state
  # add new Simp object to display order stack
  $self->{'_dndx'} = @DISPSTAK;
  push(@DISPSTAK, \$self); 
  return($self);
}

sub Prnt { # Simp object PrintString method
  my $self = shift; my %parm; my ($ycrs, $xcrs); my ($keey, $valu); 
  my ($cnum, $delt, $chrz);   my ($yold, $xold); my ($fgcl, $bgcl); 
  $parm{'nore'} = 0; # No Refresh flag init'd to false
  $parm{'ycrs'} = $self->{'_ycrs'};
  $parm{'xcrs'} = $self->{'_xcrs'};
  if($self->{'_btyp'}) { $parm{'ycrs'}++; $parm{'xcrs'}++; }
  $parm{'prin'} = $self->{'_flagprin'}; # init prin param
  while(@_) { # load params
    ($keey, $valu) = (shift, shift);
    if(defined($valu)) { $keey =~ s/^_*//; $parm{$keey } = $valu; }
    else               {                   $parm{'text'} = $keey; }
  }
  # if text or colr are arrays like new or Draw would take, join them
  $chrz = ref($parm{'text'});
  $parm{'text'} = join("\n", @{$parm{'text'}}) if($chrz eq 'ARRAY');
  $chrz = ref($parm{'colr'});
  $parm{'colr'} = join("\n", @{$parm{'colr'}}) if($chrz eq 'ARRAY');
  return() unless(exists($parm{'text'}) && defined($parm{'text'}) && length($parm{'text'}));
  ($yold, $xold) = ($self->{'_ycrs'}, $self->{'_xcrs'});
  $parm{'ycrs'} = $parm{'ytmp'} if(exists($parm{'ytmp'}));
  $parm{'xcrs'} = $parm{'xtmp'} if(exists($parm{'xtmp'}));
  $parm{'text'} =~ s/[ 	›œ]/ /g; # Prnt does not support escaped printf chars like Draw
  if($parm{'prin'}) {
    if($self->{'_btyp'}) { 
      if($parm{'ycrs'}) { $parm{'ycrs'}--; } else { $parm{'zery'} = 1; }
      if($parm{'xcrs'}) { $parm{'xcrs'}--; } else { $parm{'zerx'} = 1; }
    }
    unless(@{$self->{'_text'}} > $parm{'ycrs'} && 
           defined($self->{'_text'}->[$parm{'ycrs'}])) {
      $self->{'_text'}->[$parm{'ycrs'}]  = '';
    }
    if(length($self->{'_text'}->[$parm{'ycrs'}]) > $parm{'xcrs'}) {
      substr($self->{'_text'}->[$parm{'ycrs'}], $parm{'xcrs'}, length($parm{'text'}), $parm{'text'});
    } else {
      $self->{'_text'}->[$parm{'ycrs'}] .= ' ' x ($parm{'xcrs'} - length($self->{'_text'}->[$parm{'ycrs'}])) . $parm{'text'};
    }
    if($self->{'_btyp'}) { 
      $parm{'ycrs'}++ unless(exists($parm{'zery'}));
      $parm{'xcrs'}++ unless(exists($parm{'zerx'}));
    }
  }
  if(exists($parm{'colr'})) {
    $parm{'colr'} = $self->ExpandCC($parm{'colr'});
    if($parm{'prin'}) {
      if($self->{'_btyp'}) { 
        if($parm{'ycrs'}) { $parm{'ycrs'}--; } else { $parm{'zery'} = 1; }
        if($parm{'xcrs'}) { $parm{'xcrs'}--; } else { $parm{'zerx'} = 1; }
      }
      if(defined($self->{'_colr'}->[$parm{'ycrs'}])) {
        $self->{'_colr'}->[$parm{'ycrs'}]  = ';' . $self->ExpandCC($self->{'_colr'}->[$parm{'ycrs'}]);
      } else {
        $self->{'_colr'}->[$parm{'ycrs'}]  = ';';
      }
      if(length($self->{'_colr'}->[$parm{'ycrs'}]) > (($parm{'xcrs'} * 2) + 1)) {
        substr($self->{'_colr'}->[$parm{'ycrs'}], (($parm{'xcrs'} * 2) + 1), (length($parm{'text'}) * 2), $parm{'colr'});
      } else {
        if($self->{'_colr'}->[$parm{'ycrs'}] =~ /^;.*(.)(.)$/) {
          $fgcl = $1; $bgcl = $2;
          while(length($self->{'_colr'}->[$parm{'ycrs'}]) < (($parm{'xcrs'} * 2) + 1)) {
            $self->{'_colr'}->[$parm{'ycrs'}] .= $fgcl;
            $self->{'_colr'}->[$parm{'ycrs'}] .= $bgcl if(length($self->{'_colr'}->[$parm{'ycrs'}]) < (($parm{'xcrs'} * 2) + 1));
          }
        } else {
          $self->{'_colr'}->[$parm{'ycrs'}] .= 'Bb' x $parm{'xcrs'};
        }
        $self->{'_colr'}->[$parm{'ycrs'}] .= $parm{'colr'};
      }
      if($self->{'_btyp'}) { 
        $parm{'ycrs'}++ unless(exists($parm{'zery'}));
        $parm{'xcrs'}++ unless(exists($parm{'zerx'}));
      }
    }
    $parm{'ycrs'} = 0 unless($parm{'ycrs'} =~ /^\d+$/);
    $parm{'xcrs'} = 0 unless($parm{'xcrs'} =~ /^\d+$/);
    $cnum = 0;
    while($parm{'text'} =~ s/^(.)//) {
      $chrz = $1; $delt = 0;
      if(exists($parm{'colr'}) && $parm{'colr'} =~ s/^(.)(.)//) {
        $fgcl = $1; $bgcl = $2; $self->InitPair($fgcl, $bgcl);
      }
      while((!length($parm{'colr'}) || 
              substr($parm{'colr'}, 0, 2) eq "$fgcl$bgcl") && 
              length($parm{'text'})) {
        $cnum++; $delt++;
        $parm{'colr'} =~ s/^..// if(exists($parm{'colr'}));
        $parm{'text'} =~ s/^(.)//;
        $chrz .= $1;
      }
      $chrz = '' unless(defined($chrz));
      if(exists($parm{'ycrs'}) && exists($parm{'xcrs'})) { 
        $self->{'_wind'}->addstr($parm{'ycrs'}, $parm{'xcrs'} + ($cnum - $delt), $chrz); 
      }
      $cnum++;
    }
  } else {
    $cnum = length($parm{'text'});
    if(exists($parm{'ycrs'}) && exists($parm{'xcrs'})) { 
      $self->{'_wind'}->addstr($parm{'ycrs'}, $parm{'xcrs'}, $parm{'text'}); 
    }
  }
  $self->{'_wind'}->getyx($self->{'_ycrs'},     $self->{'_xcrs'});
  if($self->{'_btyp'}) {  $self->{'_ycrs'}--;   $self->{'_xcrs'}--; }
  if(exists($parm{'ytmp'}) || exists($parm{'xtmp'})) { 
    $self->Move($yold, $xold);
  }
  $self->{'_wind'}->refresh() unless($parm{'nore'});
  return($cnum);
}

sub Draw { # Simp object self Drawing method
  my $self = shift;  my ($fgcl, $bgcl); my ($lnum, $cnum); my ($ltxt, $clin);
  my ($keey, $valu); my ($delt, $char); my ($yoff, $xoff); my ($ordc, $ordd);
  my $dol8; my $tndx;
  while(@_) { # load key/vals like new()
    ($keey, $valu) = (shift, shift);
    foreach my $attr ( $self->_attribute_names() ) { 
      $self->{$attr} = $valu if($attr =~ /$keey/i);
    }
  }
  $self->Updt(); 
  $self->{'_wind'}->move(0, 0);
  if($self->{'_btyp'}) {
    $self->BordChar('ul');
    $tndx = int((($self->{'_widt'} - 2) - length($self->{'_titl'})) / 2);
    if(length($self->{'_titl'})) {
      for (my $i = 1; $i < $tndx; $i++) {
        $self->BordChar('hl', 1);
      }
      $self->BordChar('rt', 1); $tndx++;
      $self->Prnt('text' => $self->{'_titl'}, 'ytmp' => 0, 'prin' => 0,
                  'colr' => $self->{'_tclr'}, 'xtmp' => $tndx );
      $tndx += length($self->{'_titl'});
      $self->{'_wind'}->move(0, $tndx);
      $self->BordChar('lt');
      for(my $i = 1; $i < int((($self->{'_widt'} - 1) - length($self->{'_titl'})) / 2); $i++) {
        $self->BordChar('hl', 1);
      }
    } else {
      for (my $i = 0; $i < ($self->{'_widt'} - 2); $i++) { 
        $self->BordChar('hl', 1);
      }
    }
    $self->BordChar('ur', 1);
  }
  for($lnum = 0;  $lnum < @{$self->{'_text'}} && 
                ( $lnum <  ($self->{'_hite'} - 2) || 
                 ($lnum <   $self->{'_hite'} && !$self->{'_btyp'})); $lnum++) {
    $_ = $self->{'_text'}->[$lnum];
    chomp() if(defined $_);
    $self->BordChar('vl', 1) if($self->{'_btyp'});
    $self->InitPair(-1)      if($self->{'_btyp'});
    $_ = ' ' x $self->{'_widt'} unless(defined $_);
    if   ((length($_) <= ($self->{'_widt'} - 2)) ||
          (length($_) <=  $self->{'_widt'} && !$self->{'_btyp'})) {$ltxt=$_; }
    elsif($self->{'_btyp'}) { $ltxt = substr($_, 0, ($self->{'_widt'} - 2)); }
    else                    { $ltxt = substr($_, 0,  $self->{'_widt'}); }
    if((exists($self->{'_colr'}) && $self->{'_colr'} && @{$self->{'_colr'}}) ||
       $_ =~ /[ 	›œ]/) {
      if($self->{'_colr'} && defined($self->{'_colr'}->[$lnum])) {
        $clin = $self->ExpandCC($self->{'_colr'}->[$lnum]);
      }
      for($cnum = 0; $cnum < length($ltxt); $cnum++) {
        if($cnum <= $self->{'_widt'}) {
          $delt = 0;
          if($self->{'_colr'} && @{$self->{'_colr'}} && defined($self->{'_colr'}->[$lnum]) && 
             length($clin) >= (($cnum + 1) * 2)) {
            ($fgcl, $bgcl) = split(//, substr($clin, $cnum * 2, 2));
            $self->InitPair($fgcl, $bgcl);
          }
          $ordc = ord(substr($ltxt, $cnum    , 1));
          $ordd = ord(substr($ltxt, $cnum + 1, 1));
          while($cnum < (length($ltxt) - 1) &&
            $ordc > 31 && $ordc != 127 && $ordc != 155 && $ordc != 156 &&
            $ordd > 31 && $ordd != 127 && $ordd != 155 && $ordd != 156 &&
            (!defined($self->{'_colr'}->[$lnum])  ||
             length($clin) < (($cnum+1)*2)        ||
             ($fgcl eq substr($clin, ($cnum+1)*2,   1) &&
              $bgcl eq substr($clin, ($cnum+1)*2+1, 1)))) {
            $cnum++; $delt++;
            $ordc = $ordd;
            $ordd = ord(substr($ltxt, $cnum + 1, 1));
          }
          $char = substr($ltxt, $cnum, 1);
          $ordc = ord($char);
          if(!$delt && 
            ($ordc <=  31 || $ordc == 127 || $ordc == 155 || $ordc == 156)) {
            if($self->{'_colr'} && @{$self->{'_colr'}}) {
              $fgcl = $clet{$fgcl} if(exists($clet{$fgcl}));
              $bgcl = $clet{$bgcl} if(exists($clet{$bgcl}));
              if   (ord($fgcl) >= ord('A')) { $delt = 1; $fgcl = ((ord($fgcl) - ord('A')) + 32); }
              elsif(    $fgcl  >=      8  ) { $delt = 1; $fgcl += 22; }
              else                          { $delt = 0; $fgcl += 30; }
              if   (ord($bgcl) >= ord('A')) { $bgcl  = ((ord($bgcl) - ord('A')) + 42); } 
              elsif(    $bgcl  >=      8  ) { $bgcl += 32; }
              else                          { $bgcl += 40; }
            }
            # fonter blanks:  0,7,8,  10,   12,13,14,15,      27,155
            foreach my $tstc (0,7,8,9,10,11,12,13,14,15,24,26,27,155) {
              $char = ' ' if($ordc == $tstc);
            }
            $self->{'_wind'}->addstr(' ');
            $yoff = $self->{'_yoff'} + 1; 
            $xoff = $self->{'_xoff'} + 1;
            if($self->{'_btyp'}) { $yoff++; $xoff++; }
            # some special chars must be printed with escapes done later (l8)
            if($self->{'_colr'} && @{$self->{'_colr'}}) {
              $dol8 .= sprintf("\e[%d;%dH\e[%d;%d;%dm$char", 
                ($lnum + $yoff), ($cnum + $xoff), $delt, $fgcl, $bgcl);
            } else {
              $dol8 .= sprintf("\e[%d;%dH\e[%dm$char", 
                ($lnum + $yoff), ($cnum + $xoff), $delt);
            }
          } else {
            $self->{'_wind'}->addstr(substr($ltxt, $cnum - $delt, $delt+1));
          }
        }
      }
      if($cnum < $self->{'_widt'}) {
        $self->{'_wind'}->addstr(' ' x (($self->{'_widt'} - $cnum) - 2));
        $self->{'_wind'}->addstr('  ') unless($self->{'_btyp'} || 
                                              !defined($_)     || 
                                               length($_) == $self->{'_widt'});
      }
    } else { # no color
      $self->{'_wind'}->addstr($_);
      if(length($_) < ($self->{'_widt'} - 2)) { 
        $self->{'_wind'}->addstr(' ' x (($self->{'_widt'} - 2) - length($_))); 
        $self->{'_wind'}->addstr('  ') unless($self->{'_btyp'});
      }
    }
    $self->BordChar('vl') if($self->{'_btyp'});
  }
  # pad blank lines if height not full
  if(($lnum < ($self->{'_hite'} - 2)) ||
     ($lnum <  $self->{'_hite'} && !$self->{'_btyp'})) {
    $_  = ' ' x ($self->{'_widt'} - 2);
    $_ .= '  ' unless($self->{'_btyp'});
    while($lnum < $self->{'_hite'}) {
      $self->BordChar('vl', 1) if($self->{'_btyp'});
      $self->{'_wind'}->addstr($_);
      $self->BordChar('vl')    if($self->{'_btyp'});
      $lnum++;
      $lnum+=2                 if($self->{'_btyp'} &&
                                  $lnum >= ($self->{'_hite'} - 3));
    }
  }
  if($self->{'_btyp'}) {
    $self->BordChar('ll', 1);
    $self->BordChar('hl', 1) foreach(2..$self->{'_widt'});
    $self->BordChar('lr', 1);
  }
  $self->{'_valudol8'} = $dol8 if(defined($dol8));
  $self->Move(); # replace cursor position && refresh the window
  return();
}

sub Wait { 
  my $self = shift; my $wait = shift || 0;
  if     ( $self->{'_flagfram'}) { # cnv from Time::Frame        to Curses ms
    $wait = Time::Frame->new($wait) unless(ref($wait) eq "Time::Frame");
    $wait = int($wait->total_frames() / 60.0 * 1000);
  } elsif(!$self->{'_flagmili'}) { # cnv from Dflt float seconds to Curses ms
    $wait = int($wait * 1000);
  }
  return(napms($wait)); 
}

sub GetK { 
  my $self = shift; my $tmot = shift || 0; my $sdlk = shift || 0;
  if($tmot ne '-1') {
    if     ( $self->{'_flagfram'}) { # cnv from Time::Frame        to Curses ms
      $tmot = Time::Frame->new($tmot) unless(ref($tmot) eq "Time::Frame");
      $tmot = int($tmot->total_frames() / 60.0 * 1000);
    } elsif(!$self->{'_flagmili'}) { # cnv from Dflt float seconds to Curses ms
      $tmot = int($tmot * 1000);
    }
  }
  timeout($tmot); 
  if($self->{'_flagsdlk'} || $sdlk) {
    my $char = getch(); my $ordc = ord($char);
    foreach(@KMODNAMZ) { $self->{'_kmod'}->{$_} = 0; }
    $self->{'_kmod'}->{'KMOD_NONE'} = 1;
    if($char =~ /^[A-Z]$/) {
      $self->{'_kmod'}->{'KMOD_NONE'}  = 0;
      $self->{'_kmod'}->{'KMOD_SHIFT'} = 1;
      $char = lc($char);
    }
    return("SDLK_$char")                   if($char =~ /^[a-z0-9]$/);
    return("SDLK_$SDLKCHRM{$char}")        if(exists($SDLKCHRM{$char}));
    return("SDLK_$SDLKCRSM{$knum{$char}}") if(exists($knum{$char}) &&
                                              exists($SDLKCRSM{$knum{$char}}));
    if($ordc == 27) { # escape or Alt-?
      timeout(0);
      my $chr2 = getch();
      if(defined($chr2) && $chr2 ne '-1') {
        $self->{'_kmod'}->{'KMOD_NONE'} = 0;
        $self->{'_kmod'}->{'KMOD_ALT'}  = 1;
        if($chr2 =~ /^[A-Z]$/) {
          $self->{'_kmod'}->{'KMOD_SHIFT'} = 1;
          $char = lc($char);
        }
        if     (exists($SDLKCHRM{$chr2})) {
          return("SDLK_$SDLKCHRM{$chr2}");
        } elsif(exists($knum{$char}) && exists($SDLKCRSM{$knum{$char}})) {
          return("SDLK_$SDLKCRSM{$knum{$chr2}}") 
        } else {
          return("SDLK_$chr2");
        }
      }
    }
    return("SDLK_$SDLKORDM{$ordc}")        if(exists($SDLKORDM{$ordc}));
    if($ordc < 27) {
      $self->{'_kmod'}->{'KMOD_NONE'} = 0;
      $self->{'_kmod'}->{'KMOD_CTRL'} = 1;
      return("SDLK_" . chr($ordc + 96));
    }
  # not detected correctly yet:
#  'SDLK_CLEAR',          #        clear
#  'SDLK_PAUSE',          #        pause
#  'SDLK_KP0',            #        keypad 0
#  'SDLK_KP1',            #        keypad 1
#  'SDLK_KP2',            #        keypad 2
#  'SDLK_KP3',            #        keypad 3
#  'SDLK_KP4',            #        keypad 4
#  'SDLK_KP5',            #        keypad 5
#  'SDLK_KP6',            #        keypad 6
#  'SDLK_KP7',            #        keypad 7
#  'SDLK_KP8',            #        keypad 8
#  'SDLK_KP9',            #        keypad 9
#  'SDLK_KP_PERIOD',      #'.'     keypad period
#  'SDLK_KP_DIVIDE',      #'/'     keypad divide
#  'SDLK_KP_MULTIPLY',    #'*'     keypad multiply
#  'SDLK_KP_MINUS',       #'-'     keypad minus
#  'SDLK_KP_PLUS',        #'+'     keypad plus
#  'SDLK_KP_ENTER',       #'\r'    keypad enter
#  'SDLK_KP_EQUALS',      #'='     keypad equals
#  'SDLK_NUMLOCK',        #        numlock
#  'SDLK_CAPSLOCK',       #        capslock
#  'SDLK_SCROLLOCK',      #        scrollock
#  'SDLK_RSHIFT',         #        right shift
#  'SDLK_LSHIFT',         #        left shift
#  'SDLK_RCTRL',          #        right ctrl
#  'SDLK_LCTRL',          #        left ctrl
#  'SDLK_RALT',           #        right alt
#  'SDLK_LALT',           #        left alt
#  'SDLK_RMETA',          #        right meta
#  'SDLK_LMETA',          #        left meta
#  'SDLK_LSUPER',         #        left windows key
#  'SDLK_RSUPER',         #        right windows key
#  'SDLK_MODE',           #        mode shift
#  'SDLK_HELP',           #        help
#  'SDLK_PRINT',          #        print-screen
#  'SDLK_SYSREQ',         #        SysRq
#  'SDLK_BREAK',          #        break
#  'SDLK_MENU',           #        menu
#  'SDLK_POWER',          #        power
#  'SDLK_EURO',           #        euro
#  kmods:
#  'KMOD_NONE',           #        No modifiers applicable
#  'KMOD_CTRL',           #        A Control key is down
#  'KMOD_SHIFT',          #        A Shift key is down
#  'KMOD_ALT',            #        An Alt key is down
  } else {
    return(getch());
  }
}

sub KMod { # accessor for the %{$self->{'_kmod'}} hash
  my $self = shift; my $kmod = shift || 'KMOD_NONE';
  foreach(@KMODNAMZ) {
    if(/$kmod$/i) {
      my $valu = shift;
      $self->{'_kmod'}->{$_} = $valu if(defined($valu));
      return($self->{'_kmod'}->{$_});
    }
  }
}

sub Move { # update cursor position
  my $self = shift; my ($ycrs, $xcrs) = (shift, shift); my $eflg = 0;
  if(defined($ycrs) && defined($xcrs)) { # (-1, -1) is a special Move
    # exception to put cursor in lower right corner of border (if BTyp)
    $eflg = 1 if($ycrs == -1 && $xcrs == -1);
    $ycrs = ($self->{'_hite'} - 1) if($ycrs == -1);
    $xcrs = ($self->{'_widt'} - 1) if($xcrs == -1);
  } else { 
    $ycrs = $self->{'_ycrs'} unless(defined($ycrs));
    $xcrs = $self->{'_xcrs'};
  }
  $ycrs = 0 if($ycrs < 0);
  $xcrs = 0 if($xcrs < 0);
  if($self->{'_btyp'}) { # trap cursor inside border
    if   (($ycrs == $self->{'_hite'} - 1 &&
           $xcrs == $self->{'_widt'} - 2) ||
          ($ycrs == $self->{'_hite'} - 2 &&
           $xcrs == $self->{'_widt'} - 1)) { 
      $ycrs = ($self->{'_hite'} - 2);
      $xcrs = ($self->{'_widt'} - 2);
    } elsif(!$eflg) {
      $ycrs++; $xcrs++;
      $ycrs = ($self->{'_hite'} - 2) if($ycrs > ($self->{'_hite'} - 2));
      $xcrs = ($self->{'_widt'} - 2) if($xcrs > ($self->{'_widt'} - 2));
    }
  } else {
    $ycrs = $self->{'_hite'} - 1 if($ycrs > ($self->{'_hite'} - 1));
    $xcrs = $self->{'_widt'} - 1 if($xcrs > ($self->{'_widt'} - 1));
  }
  if($self->{'_valudol8'}) {
    $self->{'_wind'}->refresh();
    $self->{'_wind'}->getyx($self->{'_ycrs'}, $self->{'_xcrs'});
    print($self->{'_valudol8'});
    printf("\e[%d;%dH", $self->{'_ycrs'} + 1, $self->{'_xcrs'});
  }
  if($ycrs != $self->{'_ycrs'} || $xcrs != $self->{'_xcrs'}) {
    $self->{'_wind'}->move($ycrs, $xcrs); 
    $self->{'_wind'}->getyx($self->{'_ycrs'}, $self->{'_xcrs'});
    if($self->{'_btyp'}) { $self->{'_ycrs'}--; $self->{'_xcrs'}--; }
  }
  $self->{'_wind'}->refresh();
  return($self->{'_ycrs'}, $self->{'_xcrs'});
}

sub Rsiz { # update window dimensions (Resize)
  my $self = shift; my $hite = shift; my $widt = shift; my $eflg = 0;
  my ($ymax, $xmax);
  if(defined($hite) && defined($widt)) {
    $hite = getmaxy() if($hite == -1);
    $widt = getmaxx() if($widt == -1);
  } else { 
    $hite = $self->{'_hite'} unless(defined($hite));
    $widt = $self->{'_widt'};
  }
  $hite = 1 if($hite < 1);
  $widt = 1 if($widt < 1);
  if($self->{'_btyp'}) { # don't resize text && borders away
    $hite = 3 if($hite < 3);
    $widt = 3 if($widt < 3);
    $ymax = $self->{'_wind'}->getmaxy();
    $xmax = $self->{'_wind'}->getmaxx();
    if(($self->{'_ycrs'} == ($hite - 2) &&
        $self->{'_xcrs'} == ($widt - 3) &&
        $self->{'_widt'} != ($xmax    )) ||
       ($self->{'_ycrs'} == ($hite - 3) &&
        $self->{'_xcrs'} == ($widt - 2) &&
        $self->{'_hite'} != ($ymax    )) ||
       ($self->{'_ycrs'} == ($hite - 1) &&
        $self->{'_xcrs'} == ($widt - 2)) ||
       ($self->{'_ycrs'} == ($hite - 2) &&
        $self->{'_xcrs'} == ($widt - 1))) {
      $eflg = 1;
    }
  }
  $self->{'_wind'}->resize($hite, $widt); 
  $self->{'_wind'}->refresh();
  $self->ShokScrn();
  $self->{'_wind'}->getmaxyx($self->{'_hite'}, $self->{'_widt'});
  $self->Move(-1, -1) if($eflg);
  return($self->{'_hite'}, $self->{'_widt'});
}

sub Updt { # update a Simp object's dimensions (resize && mvwin)
  my $self = shift; my $noch = shift || 0; # No Changes flag
  my ($hite, $widt) = ($self->{'_hite'}, $self->{'_widt'});
  my ($yoff, $xoff) = ($self->{'_yoff'}, $self->{'_xoff'});
  $self->{'_wind'}->getmaxyx($hite, $widt) unless($noch);
  $self->{'_wind'}->getbegyx($yoff, $xoff) unless($noch);
  if(length($self->{'_titl'})) {
    # if there's a window title, there must be a border to hold it
    $self->{'_btyp'} = 1 unless($self->{'_btyp'});
    # if titl+bord > Widt, trunc titl to Widt - 4 to fit screen
    if(length($self->{'_titl'}) > (getmaxx() - 4)) {
      $self->{'_titl'} = substr($self->{'_titl'}, 0, (getmaxx() - 4));
    }
  }
  if($self->{'_flagmaxi'}) { # maximize
    $self->{'_widt'} = getmaxx(); $self->{'_yoff'} = 0;
    $self->{'_hite'} = getmaxy(); $self->{'_xoff'} = 0;
  } else {
    if($self->{'_flagshrk'}) { # shrink to (hite, wider of titl+bord || text)
      if($self->{'_text'} && @{$self->{'_text'}}) {
        $self->{'_hite'}  =  @{$self->{'_text'}};
        $self->{'_hite'} +=  2 if($self->{'_btyp'});
      }
      $self->{'_hite'} = getmaxy() if($self->{'_hite'} > getmaxy());
      $self->{'_widt'} = length($self->{'_titl'}) + 4 if($self->{'_btyp'});
      if($self->{'_text'} && @{$self->{'_text'}}) {
        foreach(@{$self->{'_text'}}) {
          $self->{'_widt'}  = length($_) if($self->{'_widt'} < length($_));
        }
        $self->{'_widt'} += 2 if($self->{'_btyp'});
      }
      $self->{'_widt'} = getmaxx() if($self->{'_widt'} > getmaxx());
    }
    if($self->{'_flagcntr'}) { # set yoff,xoff so window is centered
      $self->{'_yoff'} = int((getmaxy() - $self->{'_hite'}) / 2);
      $self->{'_xoff'} = int((getmaxx() - $self->{'_widt'}) / 2);
    }
  }
  $self->{'_yoff'} = 0 if($self->{'_yoff'} < 0);
  $self->{'_xoff'} = 0 if($self->{'_xoff'} < 0);
  unless($noch) { # the window has been created so it's ok to change it
    $noch = 1; # reappropriate NoChanges flag to designate whether changed
    if(  $hite != $self->{'_hite'} || $widt != $self->{'_widt'}) {
      $self->Rsiz();#{'_wind'}->resize($self->{'_hite'}, $self->{'_widt'});
      if($hite >  $self->{'_hite'} || $widt >  $self->{'_widt'}) { 
        $self->ShokScrn(1); # Clear/Refresh main screen because window shrank
      }
      $noch = 0;
    }
    if($yoff != $self->{'_yoff'} || $xoff != $self->{'_xoff'}) {
      $self->{'_wind'}->mvwin( $self->{'_yoff'}, $self->{'_xoff'});
      $self->ShokScrn(1); # Clear/Refresh main screen because window moved
      $noch = 0;
    }
  }
  if($hite >  $self->{'_hite'} || $widt >  $self->{'_widt'} || !$noch) {
  }
  return(!$noch); # return flag telling whether self resized or moved
}

# Mesg() is a special Curses::Simp object constructor which creates a 
#   completely temporary Message window.
# If params are supplied, they must be hash key => value pairs.
sub Mesg {
  my $main = shift; my ($keey, $valu); my $char = -1;
  my $self = bless({}, ref($main));
  foreach my $attr ( $self->_attribute_names() ) { 
    $self->{$attr} = $self->_default_value($attr); # init defaults
  }
  # special Mesg window defaults
  $self->{'_flagmaxi'} = 0; # not maximized 
  $self->{'_flagcvis'} = 0; # don't show cursor
  $self->{'_mesg'} =   '';#EROR!';
  $self->{'_text'} = [ ];
  $self->{'_colr'} = [ ';Cu'   ];
  $self->{'_titl'} =   'Message:';
  $self->{'_tclr'} =   ';Gb';
  $self->{'_flagpres'} = 1;
  $self->{'_pres'} =   'Press A Key...';
  $self->{'_pclr'} =   ';Yr';
  $self->{'_wait'} =     0;
  foreach(@KMODNAMZ) { $self->{'_kmod'}->{$_} = 0; }
  # there were init params with no colon (classname)
  while(@_) {
    ($keey, $valu) = (shift, shift);
    if(defined($valu)) {
      if($keey =~ /^(mesg|pres|wait)$/) {
        $self->{"_$keey"} = $valu;
      } else {
        foreach my $attr ( $self->_attribute_names() ) { 
          $self->{$attr} = $valu if($attr =~ /$keey/i);
        }
      }
    } else {
      $self->{'_mesg'} = $keey;
    }
  }
  unless(@{$self->{'_text'}}) {
    @{$self->{'_text'}} = split(/\n/, $self->{'_mesg'});
  }
  if($self->{'_flagpres'}) {
    if(length($self->{'_pres'})) {
      $self->{'_colr'}->[@{$self->{'_text'}}] = $self->{'_pclr'};
      my $wdst = 0;
      $wdst = length($self->{'_titl'}) + 4;
      if(@{$self->{'_text'}}) { # center press string
        foreach(@{$self->{'_text'}}) {
          $wdst = length($_) if($wdst < length($_));
        }
      }
      if($wdst > length($self->{'_pres'})) {
        $self->{'_pres'} = ' ' x int(($wdst - length($self->{'_pres'}) + 1) / 2) . $self->{'_pres'};
      }
      push(@{$self->{'_text'}}, $self->{'_pres'});
    }
  }
  $self->{'_bclr'} = $self->ExpandCC($self->{'_bclr'});
  $self->{'_flagshrk'} = 0 if($self->{'_hite'} && $self->{'_widt'});
  $self->Updt(1);
  $self->{'_wind'} = newwin($self->{'_hite'}, $self->{'_widt'}, 
                            $self->{'_yoff'}, $self->{'_xoff'});
  unless(exists($self->{'_wind'}) && defined($self->{'_wind'})) {
    croak "!*EROR*! Curses::Simp::Mesg could not create new window with hite:$self->{'_hite'}, widt:$self->{'_widt'}, yoff:$self->{'_yoff'}, xoff:$self->{'_xoff'}!\n";
  }
  $self->FlagCVis(); # set cursor visibility to new Mesg object state
  # newwin doesn't auto draw so if there's init _text && autodraw is on...
  if($self->{'_text'} && @{$self->{'_text'}} && $self->{'_flagaudr'}) {
    $self->Draw();
  }
  if     ($self->{'_flagpres'}) { 
    if($self->{'_wait'}) { timeout($self->{'_wait'}); } 
    else                 { timeout(-1); }
    $char = getch();
    if($self->{'_flagsdlk'}) {
      my $ordc = ord($char);
      foreach(@KMODNAMZ) { $self->{'_kmod'}->{$_} = 0; }
      $self->{'_kmod'}->{'KMOD_NONE'} = 1;
      if($char =~ /^[A-Z]$/) {
        $self->{'_kmod'}->{'KMOD_NONE'}  = 0;
        $self->{'_kmod'}->{'KMOD_SHIFT'} = 1;
        $char = lc($char);
      }
      $char = "SDLK_$char"                   if($char =~ /^[a-z0-9]$/);
      $char = "SDLK_$SDLKCHRM{$char}"        if(exists($SDLKCHRM{$char}));
      $char = "SDLK_$SDLKCRSM{$knum{$char}}" if(exists($knum{$char}) &&
                                                exists($SDLKCRSM{$knum{$char}}));
      if($ordc == 27) { # escape or Alt-?
        timeout(0);
        my $chr2 = getch();
        if(defined($chr2)) {
          $self->{'_kmod'}->{'KMOD_NONE'} = 0;
          $self->{'_kmod'}->{'KMOD_ALT'}  = 1;
          $char = "SDLK_$chr2";#               if($chr2 =~ /^[a-z0-9]$/);
        }
      }
      $char = "SDLK_$SDLKORDM{$ordc}"        if(exists($SDLKORDM{$ordc}));
      if($ordc < 27) {
        $self->{'_kmod'}->{'KMOD_NONE'} = 0;
        $self->{'_kmod'}->{'KMOD_CTRL'} = 1;
        $char = "SDLK_" . chr($ordc + 96);
      }
    }
    $char = '#' . $char if($self->{'_kmod'}->{'KMOD_SHIFT'});
    $char = '^' . $char if($self->{'_kmod'}->{'KMOD_CTRL'});
    $char = '@' . $char if($self->{'_kmod'}->{'KMOD_ALT'});
  } elsif($self->{'_wait'}) { 
    $self->Wait($self->{'_wait'});
  }
  # delete the Mesg window, redraw rest
  $self->DelW();
  $main->FlagCVis(); # return cursor visibility to calling object state
  return($char);
}

# Prmt() is a special Curses::Simp object constructor which creates a 
#   completely temporary Prompt window.
# If params are supplied, they must be hash key => value pairs.
sub Prmt {
  my $main = shift; my ($keey, $valu); my $char; my $tchr; my $text = '';
  my $self = bless({}, ref($main));    my $curs = 0; my $scrl = 0;
  my $twid; my $cmov;
  foreach my $attr ( $self->_attribute_names() ) { 
    $self->{$attr} = $self->_default_value($attr); # init defaults
  }
  # special Prmt window defaults
  $self->{'_flagsdlk'} = 1;         # get SDLKeys
  $self->{'_flagmaxi'} = 0;         # not maximized 
  $self->{'_flagcvis'} = 1;         # show cursor
  $self->{'_widt'} = getmaxx() - 4; # but almost full screen wide
  $self->{'_hite'} = 3;             #   && start 1 text line high
#  $self->{'_dref'} = \$text;        # default text ref does not exist at start
  $self->{'_dtxt'} =   '';
  $self->{'_text'} = [ ];
  $self->{'_dclr'} =   ';Gu';
  $self->{'_colr'} = [ $self->{'_dclr'} ];
  $self->{'_titl'} =   'Enter Text:';
  $self->{'_tclr'} =   ';Cb';
  $self->{'_hclr'} =   ';Wg';
  foreach(@KMODNAMZ) { $self->{'_kmod'}->{$_} = 0; }
  # there were init params with no colon (classname)
  while(@_) {
    ($keey, $valu) = (shift, shift);
    if(defined($valu)) {
      if     ($keey =~ /^d(ref|txt)$/) {
        $self->{"_$keey"} = $valu;
      } else {
        foreach my $attr ( $self->_attribute_names() ) { 
          $self->{$attr} = $valu if($attr =~ /$keey/i);
        }
      }
    } else {
      $self->{'_dref'} = $keey;
    }
  }
  $self->{'_dtxt'} = ${$self->{'_dref'}} if(exists($self->{'_dref'}));
  $text = $self->{'_dtxt'};
  $self->{'_text'}->[0] = $text unless(@{$self->{'_text'}});
  $curs = length($text);
  if($self->{'_widt'} < length($self->{'_titl'}) + 4) {
    $self->{'_widt'} = length($self->{'_titl'}) + 4;
  }
  $twid = $self->{'_widt'} - 2;
  unless($curs <= $twid) { # scrolling necessary off to the left
    substr($self->{'_text'}->[0], 0,  $twid, substr($text, -$twid, $twid));
  }
  $self->{'_colr'}->[0] = $self->{'_hclr'} if($curs);
  $self->{'_ycrs'} = 0;
  $self->{'_xcrs'} = 0 + $curs;
  $self->{'_bclr'} = $self->ExpandCC($self->{'_bclr'});
  $self->{'_flagshrk'} = 0 if($self->{'_hite'} && $self->{'_widt'});
  $self->Updt(1);
  $self->{'_wind'} = newwin($self->{'_hite'}, $self->{'_widt'}, 
                            $self->{'_yoff'}, $self->{'_xoff'});
  unless(exists($self->{'_wind'}) && defined($self->{'_wind'})) {
    croak "!*EROR*! Curses::Simp::Prmt could not create new window with hite:$self->{'_hite'}, widt:$self->{'_widt'}, yoff:$self->{'_yoff'}, xoff:$self->{'_xoff'}!\n";
  }
  $self->FlagCVis(); # set cursor visibility to new Prmt object state
  # newwin doesn't auto draw so if there's init _text && autodraw is on...
  if($self->{'_text'} && @{$self->{'_text'}} && $self->{'_flagaudr'}) {
    $self->Draw();
  }
  while(!defined($char) || $char ne 'SDLK_RETURN') {
    $char = getch();
    if($char ne '-1') {
      my $ordc = ord($char); my %kmod;
      foreach(@KMODNAMZ) { $kmod{$_} = 0; }
      $kmod{'KMOD_NONE'} = 1;
      if($char =~ /^[A-Z]$/) {
        $kmod{'KMOD_NONE'}  = 0;
        $kmod{'KMOD_SHIFT'} = 1;
        $char = lc($char);
      }
      if     ($char =~ /^[a-z0-9]$/) {
        $char = "SDLK_$char";
      } elsif(exists($SDLKCHRM{$char})) {
        $char = "SDLK_$SDLKCHRM{$char}";
      } elsif(exists($knum{$char}) && exists($SDLKCRSM{$knum{$char}})) {
        $char = "SDLK_$SDLKCRSM{$knum{$char}}";
      } elsif($ordc == 27) { # escape or Alt-?
        timeout(0);
        my $chr2 = getch();
        if(defined($chr2) && $chr2 ne '-1') {
          $kmod{'KMOD_NONE'} = 0;
          $kmod{'KMOD_ALT'}  = 1;
          $char = "SDLK_$chr2";#               if($chr2 =~ /^[a-z0-9]$/);
        } else {
          $char = "SDLK_ESCAPE";
        }
      } elsif(exists($SDLKORDM{$ordc})) {
        $char = "SDLK_$SDLKORDM{$ordc}";
      } elsif($ordc < 27) {
        $kmod{'KMOD_NONE'} = 0;
        $kmod{'KMOD_CTRL'} = 1;
        $char = "SDLK_" . chr($ordc + 96);
      }
      unless($char eq 'SDLK_RETURN') {
        $tchr =  $char;
        $tchr =~ s/SDLK_//;
        $cmov = 0;
        if     ($tchr eq 'LEFT' ) { # move cursor left
          if($curs) {
            $curs--;
            $scrl-- if($scrl);
          }
          $cmov = 1;
        } elsif($tchr eq 'RIGHT') { # move cursor right
          if($curs < length($text)) {
            $curs++;
          }
          $cmov = 1;
        } elsif($tchr eq 'HOME' ) { # move cursor to beginning
          $curs = 0;
          $scrl = 0 if($scrl);
          $cmov = 1;
        } elsif($tchr eq 'END'  ) { # move cursor to end
          $curs = length($text);
          if(length($text) < $self->{'_widt'} - 2) {
            $scrl = (length($text) - $self->{'_widt'} - 2);
          }
          $cmov = 1;
        } elsif($tchr eq 'UP'  ) { # uppercase cursor letter
          if($curs) { 
            my $temp = substr($text, $curs, 1);
                       substr($text, $curs, 1, uc($temp)); 
          }
        } elsif($tchr eq 'DOWN') { # lowercase cursor letter
          if($curs) { 
            my $temp = substr($text, $curs, 1);
                       substr($text, $curs, 1, lc($temp)); 
          }
        } elsif($tchr eq 'INSERT') {
          $self->FlagInsr('togl');
          if($self->FlagInsr) { $self->{'_titl'} =~ s/\[O\]$//; }
          else                { $self->{'_titl'} .= '[O]'; 
            unless($self->Widt() > length($self->Titl()) + 4) {
              $self->Widt(length($self->Titl()) + 4);
              $main->Draw();
            }
          }
        } elsif($tchr eq 'BACKSPACE') {
          if($curs) {
            substr($text, --$curs, 1, '');
            $scrl-- if($scrl);
          }
        } elsif($tchr eq 'DELETE') {
          if($curs < length($text)) {
            substr($text,   $curs, 1, '');
            $scrl-- if($scrl);
          }
        } elsif($tchr eq 'ESCAPE') {
          $self->{'_colr'}->[0] = $self->{'_hclr'};
          $text = $self->{'_dtxt'};
          $curs = length($text);
        } elsif($self->{'_colr'}->[0] eq "$self->{'_hclr'}") {
          $text = $tchr;
          $curs = length($text);
        } else {
          foreach(keys(%SDLKCHRM)) {
            $tchr = $_ if($tchr eq $SDLKCHRM{$_});
          }
          if     ($curs == length($text)) { 
            $text .= $tchr; 
          } elsif($self->FlagInsr()) {
            substr($text, $curs,             0, $tchr); 
          } else { 
            substr($text, $curs, length($tchr), $tchr); 
          }
          $curs += length($tchr);
        }
        $scrl++ while(($curs - $scrl) >= $self->{'_widt'} - 2);
        if($self->{'_colr'}->[0] eq "$self->{'_hclr'}" &&
           ($text ne $self->{'_dtxt'} || $cmov)) {
          $self->{'_colr'}->[0] = $self->{'_dclr'};
        }
        $self->{'_xcrs'} = 0 + ($curs - $scrl);
        $self->{'_text'}->[0] = $text;
        substr($self->{'_text'}->[0], 0, $scrl + 3, '...') if($scrl);
        $self->Draw();
      }
    }
  }
  ${$self->{'_dref'}} = $text if(exists($self->{'_dref'}));
  # delete the Prmt window, redraw rest
  $self->DelW();
  $main->FlagCVis(); # return cursor visibility to calling object state
  return($text);
}

sub BildBlox { # a sub used by CPik to construct color blocks in @text && @colr
  my $self = shift; 
  @{$self->{'_text'}} = ( );
  @{$self->{'_colr'}} = ( );
  if     ($self->{'_styl'} eq 'barz') {
    for(my $cndx = 0; $cndx < @telc; $cndx++) {
      push(@{$self->{'_text'}},  ' ' . hex($cndx) . ' ' .
             $telc[$cndx] . ' ' . $self->{'_bchr'} x 63);
      if($cndx == $self->{'_hndx'}) {
        push(@{$self->{'_colr'}}, ';bwBwbwbw!' . ' ' .
               $telc[$cndx] x 63);
      } else {
        push(@{$self->{'_colr'}}, '! w W'      . ' ' .
               $telc[$cndx] x 63);
      }
    }
    if($self->{'_flagforg'}) {
      for(my $cndx = 0; $cndx < @telc; $cndx++) {
        if(hex($cndx+@telc) eq 'B' || hex($cndx+@telc) eq 'C') {
          push(@{$self->{'_text'}},  ' ' . '!' . ' ' . 
                 uc($telc[$cndx]) .  ' ' . $self->{'_bchr'} x 63);
        } else {
          push(@{$self->{'_text'}},  ' ' . hex($cndx+@telc) . ' ' .
                 uc($telc[$cndx]) .  ' ' . $self->{'_bchr'} x 63);
        }
        if($cndx == ($self->{'_hndx'} - 8)) {
          push(@{$self->{'_colr'}}, ';bwBwbwbw! ' . uc($telc[$cndx]) x 63);
        } else {
          push(@{$self->{'_colr'}}, '! w W '      . uc($telc[$cndx]) x 63);
        }
      }
    }
    $self->Move($self->{'_hndx'}, 0);
  } elsif($self->{'_styl'} eq 'blox') {
  }
  if($self->{'_flagpres'}) {
    if(length($self->{'_pres'})) {
      $self->{'_colr'}->[@{$self->{'_text'}}] = $self->{'_pclr'};
      my $wdst = 0;
      $wdst = length($self->{'_titl'}) + 4;
      if(@{$self->{'_text'}}) { # center press string
        foreach(@{$self->{'_text'}}) {
          $wdst = length($_) if($wdst < length($_));
        }
      }
      if($wdst > length($self->{'_pres'})) {
        $self->{'_pres'} = ' ' x int(($wdst - length($self->{'_pres'}) + 1) / 2) . $self->{'_pres'} . ' ' x int(($wdst - length($self->{'_pres'}) + 1) / 2);
      }
      push(@{$self->{'_text'}}, $self->{'_pres'});
    }
  }
  $self->Draw();
  return();
}

# CPik() is a special Curses::Simp object constructor which creates a 
#   Color Pick window.
# If params are supplied, they must be hash key => value pairs.
sub CPik {
  my $main = shift; my ($keey, $valu); my $char; my $tchr; my $text = '';
  my $self = bless({}, ref($main));
  my $cmov; my $pick; my $done = 0;
#    ' ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿','ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß',
  my @bchz = ( 'X', '@', '#', '$', 'Û', '²', '±', '°'); # block chars
  my @styz = ( 'barz', 'blox', 'squr' ); # color display styles
  foreach my $attr ( $self->_attribute_names() ) { 
    $self->{$attr} = $self->_default_value($attr); # init defaults
  }
  # special CPik window defaults
  $self->{'_flagsdlk'} = 1;         # get SDLKeys
  $self->{'_flagmaxi'} = 0;         # not maximized 
  $self->{'_flagcvis'} = 1;         # show cursor
  $self->{'_flagbakg'} = 1;         # pick background colors
  $self->{'_flagforg'} = 1;         # pick foreground colors
#  $self->{'_widt'} = getmaxx() - 4; # but almost full screen wide
#  $self->{'_hite'} = getmaxy() - 4; #                     && high
  $self->{'_text'} = [ ' ' ];
  $self->{'_dclr'} =   ';Gu';
  $self->{'_colr'} = [ $self->{'_dclr'} ];
  $self->{'_titl'} =   'Color Picker:';
  $self->{'_tclr'} =   ';RpOgYcGuUp  Gu';
  $self->{'_flagpres'} = 1;
  $self->{'_pres'} =   'Pick A Color... (Arrows+Enter, Letter, or Number)';
  $self->{'_pclr'} =   ';Yb'; # Pick message Color
  $self->{'_hclr'} =   ';Wg'; # highlight color
  $self->{'_hndx'} =     7;   # highlight index
  $self->{'_sndx'} =     0;   # style index
  $self->{'_styl'} =   'barz';# style name
  $self->{'_bndx'} =     0;   # block index
  $self->{'_bchr'} =   'X';   # block char
  foreach(@KMODNAMZ) { $self->{'_kmod'}->{$_} = 0; }
  # there were init params with no colon (classname)
  while(@_) {
    ($keey, $valu) = (shift, shift);
    if(defined($valu)) {
      if     ($keey =~ /^_*....$/) {
        $keey =~ s/^_*//;
        $self->{"_$keey"} = $valu;
      } else {
        foreach my $attr ( $self->_attribute_names() ) { 
          $self->{$attr} = $valu if($attr =~ /$keey/i);
        }
      }
    } else {
      $self->{'_styl'} = $keey;
    }
  }
  $self->{'_sndx'} = $self->{'_styl'} if($self->{'_styl'} =~ /^\d+$/);
  $self->{'_styl'} = $styz[$self->{'_sndx'}];
  $self->{'_bndx'} = $self->{'_bchr'} if($self->{'_bchr'} =~ /^\d+$/);
  $self->{'_bchr'} = $bchz[$self->{'_bndx'}];
  if($self->{'_widt'} < length($self->{'_titl'}) + 4) {
    $self->{'_widt'} = length($self->{'_titl'}) + 4;
  }
  $self->{'_ycrs'} = $self->{'_hndx'};
  $self->{'_xcrs'} = 0;
  $self->{'_bclr'} = $self->ExpandCC($self->{'_bclr'});
  $self->{'_flagshrk'} = 0 if($self->{'_hite'} && $self->{'_widt'});
  $self->Updt(1);
  $self->{'_wind'} = newwin($self->{'_hite'}, $self->{'_widt'}, 
                            $self->{'_yoff'}, $self->{'_xoff'});
  unless(exists($self->{'_wind'}) && defined($self->{'_wind'})) {
    croak "!*EROR*! Curses::Simp::Prmt could not create new window with hite:$self->{'_hite'}, widt:$self->{'_widt'}, yoff:$self->{'_yoff'}, xoff:$self->{'_xoff'}!\n";
  }
  $self->FlagCVis(); # set cursor visibility to new Prmt object state
  $self->BildBlox(); # build color block data into @text && @colr && Draw()
  $self->Move($self->{'_hndx'}, 0);
  while(!defined($char) || !$done) {
    $char = getch();
    if($char ne '-1') {
      my $ordc = ord($char); my %kmod;
      foreach(@KMODNAMZ) { $kmod{$_} = 0; }
      $kmod{'KMOD_NONE'} = 1;
      if($char =~ /^[A-Z]$/) {
        $kmod{'KMOD_NONE'}  = 0;
        $kmod{'KMOD_SHIFT'} = 1;
        $char = lc($char);
      }
      if     ($char =~ /^[a-z0-9]$/) {
        $char = "SDLK_$char";
      } elsif(exists($SDLKCHRM{$char})) {
        $char = "SDLK_$SDLKCHRM{$char}";
      } elsif(exists($knum{$char}) && exists($SDLKCRSM{$knum{$char}})) {
        $char = "SDLK_$SDLKCRSM{$knum{$char}}";
      } elsif($ordc == 27) { # escape or Alt-?
        timeout(0);
        my $chr2 = getch();
        if(defined($chr2) && $chr2 ne '-1') {
          $kmod{'KMOD_NONE'} = 0;
          $kmod{'KMOD_ALT'}  = 1;
          $char = "SDLK_$chr2";#               if($chr2 =~ /^[a-z0-9]$/);
        } else {
          $char = "SDLK_ESCAPE";
        }
      } elsif(exists($SDLKORDM{$ordc})) {
        $char = "SDLK_$SDLKORDM{$ordc}";
      } elsif($ordc < 27) {
        $kmod{'KMOD_NONE'} = 0;
        $kmod{'KMOD_CTRL'} = 1;
        $char = "SDLK_" . chr($ordc + 96);
      }
      if($char =~ /^SDLK_(RETURN|[0-9A-FRGYUPW])$/i) { # gonna be done
        $char =~ s/^SDLK_//;
        if     ($char =~ /^[BRGYUPCW]$/i) {
          $pick = $char;
          $pick = uc($pick) if($kmod{'KMOD_SHIFT'});
        } else {
          $self->{'_hndx'} = dec(uc($char)) unless($char =~ /^RETURN$/);
          $pick = $telc[      ($self->{'_hndx'} %  8)];
          $pick = uc($pick) if($self->{'_hndx'} >= 8);
        }
        $done = 1;
      } else {
        $tchr =  $char;
        $tchr =~ s/^SDLK_//;
        $cmov = 0;
        if     ($tchr eq 'LEFT' ) { # move left
          if     ($self->{'_styl'} eq 'barz') {
            $self->{'_hndx'} = 16 unless($self->{'_hndx'});
            $self->{'_hndx'}--;
          } elsif($self->{'_styl'} eq 'blox') {
          } elsif($self->{'_styl'} eq 'squr') {
          }
        } elsif($tchr eq 'RIGHT') { # move right
          if     ($self->{'_styl'} eq 'barz') {
            $self->{'_hndx'}++;
            $self->{'_hndx'} = 0 if($self->{'_hndx'} == 16);
          } elsif($self->{'_styl'} eq 'blox') {
          } elsif($self->{'_styl'} eq 'squr') {
          }
        } elsif($tchr eq 'HOME' ) { # move to beginning
          $self->{'_hndx'} =  0;
        } elsif($tchr eq 'END'  ) { # move to end
          $self->{'_hndx'} = 16;
        } elsif($tchr eq 'UP'   ) { # move up
          if     ($self->{'_styl'} eq 'barz') {
            $self->{'_hndx'} = 16 unless($self->{'_hndx'});
            $self->{'_hndx'}--;
          } elsif($self->{'_styl'} eq 'blox') {
          } elsif($self->{'_styl'} eq 'squr') {
          }
        } elsif($tchr eq 'DOWN' ) { # move down
          if     ($self->{'_styl'} eq 'barz') {
            $self->{'_hndx'}++;
            $self->{'_hndx'} = 0 if($self->{'_hndx'} == 16);
          } elsif($self->{'_styl'} eq 'blox') {
          } elsif($self->{'_styl'} eq 'squr') {
          }
        } elsif($tchr eq 'ESCAPE') {
          $self->{'_hndx'} = 7;
        }
        $self->BildBlox();
      }
    }
  }
  # delete the CPik window, redraw rest
  $self->DelW();
  $main->FlagCVis(); # return cursor visibility to calling object state
  return($pick);
}

sub DESTROY { 
  my $self = shift || return(); my $dndx = $self->{'_dndx'};
  if($self->{'_wind'}) {
    delwin($self->{'_wind'});
    splice(@DISPSTAK, $dndx, 1); #remove deleted from displaystack
    for(; $dndx < @DISPSTAK; $dndx++) { 
      if($DISPSTAK[$dndx] && %{$DISPSTAK[$dndx]}) {
        $DISPSTAK[$dndx]->{'_dndx'}--; 
      }
    }
    $self->ShokScrn();
  }
}

# VERBOSE METHOD NAME ALIASES
*MakeMethods           = \&MkMethdz;
*InitializeColorPair   = \&InitPair;
*PrintBorderCharacter  = \&BordChar;
*ExpandColorCodeString = \&ExpandCC;
*ShockScreen           = \&ShokScrn;
*KeyNumbers            = \&KNum;
*ColorLetters          = \&CLet;
*NumColors             = \&NumC;
*Height                = \&Hite;
*Width                 = \&Widt;
*PrintString           = \&Prnt;
*DrawWindow            = \&Draw;
*WaitTime              = \&Wait;
*GetKey                = \&GetK;
*MoveCursor            = \&Move;
*ResizeWindow          = \&Rsiz;
*UpdateWindow          = \&Updt;
*MessageWindow         = \&Mesg;
*PromptWindow          = \&Prmt;
*ColorPickWindow       = \&CPik;
*DeleteWindow          = \&DelW;
*DelW                  = \&DESTROY;

127;

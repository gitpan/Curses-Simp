# 2AFBQB7 - Curses::Simp created by Pip@CPAN.Org to vastly simplify Perl
#   text-mode application development
# Notz: Curses color names:
#   COLOR_ BLACK,RED,GREEN,YELLOW,BLUE,MAGENTA,CYAN,WHITE 

=head1 NAME

Curses::Simp - a Simple Curses wrapper for easy application development

=head1 VERSION

This documentation refers to version 1.0.4287FJQ of 
Curses::Simp, which was released on Sun Feb  8 07:15:19:26 2004.

=head1 SYNOPSIS

  use Curses::Simp;
  my $simp = Curses::Simp->new('text' => ['1337', 'nachoz', 'w/',
                                     'cheese' x 7]);
  my $key = '';
  while($key ne 'x') {           # wait for 'x' to eXit
    $key = $simp->GetKey(-1);    # get a blocking keypress
    $simp->Text('push' => $key); # push new line for new key
  }

=head1 DESCRIPTION

Curses::Simp provides a curt mechanism for updating a console screen 
with any Perl array (or two to include color codes).  Most key strokes
can be simply obtained and tested for interface manipulation.  The goal
was ease-of-use first and efficient rendering second.  Of course, it 
could always benefit from being faster still.  Many Simp functions 
can accept rather cryptic parameters to do fancier things but the most
common case is meant to be as simple as possible (hence the name).
The more I learn about Curses, the more functionality I intend to add...
maybe someday Simp will be done... yet Feeping Creatures overcome.

=head1 2DO

=over 2

=item - store some lilo structure for keeys && kmods pressed history in obj

=item - add support for new '_bcol' array to accompany colr w/ only bkgrnds

=item - mk proper scrollbars for all objects && use in Brws: view

=item - fix prin weirdness

=item - mk ~/.Simprc to save CPik && Brws cfg, OVERMAPP, etc.

=item - Brws: read ~/.LS_COLORS if -r into GLBL{OVERMAPP}

=item - Brws: mk view pack files left && right

=item - describe Simp objects sharing apps (pmix + ptok)
          mk OScr read Simp apps @_ param list && auto-handle --geom wxh+x+y

=item - CPik: rewrite BildBlox to scale style to window dims if !flagshrk
          && mk sure no forg or bakg works for all styles

=item - Prmt: mk new 'cbls' type: as a ckbx list && use in BrwsCnfg

=item - Prmt: mk new 'rdls' type: as a radio list w/ auto (*) -

=item - Mesg: mk new 'slid' type: params for all overlay text, chars, ticks, 
          flags, etc.

=item - Prnt: add multi-line option where text can split on /\n/ but each new
          line prints relative to starting xcrs

=item - Prmt: add multi-line option where dtxt can split on /\n/ && ^d
          accepts entry instead of RETURN

=item - Prnt: handle ascii chars under 32 with escapes like Draw

=item - Draw: optimize rendering

=item - Prnt&&Draw: handle ascii chars under 32 better than current escapes

=item - mk 'ceol' && 'ceos' params to clears text[n] from cursor on

=item - consider breaking sub (CPik|Brws|.+?) into own Curses::Simp::$1.pm
          instead of letting Simp.pm remain so cluttered

=back

=over 4

        if detectable:

=item - handle xterm resize events

=item - handle mouse input (study any existent Curses apps that use mouse 
          input you can find ... probably in C), read man for gpm(1),
          sysmouse(4), && sb(4) && study aumix mouse source

=item - Learn how to read a Shift-Tab key press if in any way 
          distinguishable from Tab/Ctrl-I

=item -    What else does Simp need?

=back

=head1 WHY?

Curses::Simp was created because I could hardly find dox or examples 
of Curses.pm usage so I fiddled until I could wrap the most important
stuff (AFAIC) in names and enhanced functions which streamline what I
want to do.

=head1 USAGE

B<new()> - Curses::Simp object constructor

new() opens a new Curses screen if one does not exist already and 
initializes useful default screen, color, and keys settings.  The
created Curses screen is automagically closed on program exit.

Available object methods are described in detail below.  Each of
the following four letter abbreviated or verbose method names
can be used as initialization parameters to new():

   Key       or  VerboseName                =>   Default Value
  -----         -------------                   ---------------
  'text'     or 'TextData'                  =>        [ ]
  'colr'     or 'ColorData'                 =>        [ ]
  'hite'     or 'WindowHeight'              =>         0
  'widt'     or 'WindowWidth'               =>         0
  'yoff'     or 'WindowYOffset'             =>         0
  'xoff'     or 'WindowXOffset'             =>         0
  'ycrs'     or 'CursorYOffset'             =>         0
  'xcrs'     or 'CursorXOffset'             =>         0
  'btyp'     or 'WindowBorderType'          =>         0
  'bclr'     or 'WindowBorderColor'         =>        'wb$'
  'titl'     or 'WindowTitle'               =>         ''
  'tclr'     or 'WindowTitleColor'          =>        'Wb$'
  'dndx'     or 'DisplayStackIndex'         =>         0
  'flagaudr' or 'FlagAutoDraw'              =>         1
  'flagmaxi' or 'FlagMaximize'              =>         1
  'flagshrk' or 'FlagShrinkToFit'           =>         1
  'flagcntr' or 'FlagCenter'                =>         1
  'flagcvis' or 'FlagCursorVisible'         =>         0
  'flagscrl' or 'FlagScrollbar'             =>         0
  'flagsdlk' or 'FlagSDLKey'                =>         0
  'flagbkgr' or 'FlagBackground'            =>         0
  'flagfram' or 'FlagTimeFrame'             =>         0
  'flagmili' or 'FlagMillisecond'           =>         0
  'flagprin' or 'FlagPrintInto'             =>         1

An example of setting and updating 'WindowHeight':

  use Curses::Simp; 
  my $simp = Curses::Simp->new( 'WindowHeight' => 7 ); # set
     $simp->WindowHeight( 15 ); # update

See the individual sections in the L<"ACCESSOR AND FLAG METHODS"> 
section for more information on how to manipulate created 
Curses::Simp objects.

Most other Curses::Simp methods also accept hash key => value pairs as
parameters which loads the object fields the same way new() does
before performing their operation.  This gives you the ability to
update many Simp fields with a call to any particular 
accessor method.  The method name just designates where the lone
value will be assigned and which field will be returned.

=head2 CnvAnsCC or ConvertAnsiColorCode( $AnsiColorCode )

Returns the Simp form of the ANSI color code
$AnsiColorCode.

$AnsiColorCode may contain any of the typical ANSI attribute or 
color codes:

                          Attribute        codes:
    00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
                          Foreground color codes:
    30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
                          Background color codes:
    40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white

ConvertAnsiColorCode() is primarily useful as an internal function
to the Curses::Simp package but I have exposed it because it could
be useful elsewhere.

=head2 ExpandCC or ExpandColorCodeString( $CompressedColorCodeString )

Returns the expanded form of the compressed color code string 
$CompressedColorCodeString.

$CompressedColorCodeString may contain any of the special formatting 
characters specified in the L<"COLOR NOTES"> 
(L<"Interpretation of Backgrounds and Repeats in Color Codes">) section.

ExpandColorCodeString() is primarily useful as an internal function
to the Curses::Simp package but I have exposed it because it can
be useful during testing to see how a compressed color code string would
be expanded (especially if expansion from PrintString() or DrawWindow()
is not what you're expecting).

=head2 ShokScrn or ShockScreen( [$FlagClear] )

ShockScreen() forces the screen and all created Simp objects
to be refreshed in order.

The $FlagClear (default is false) can be provided to specify that
the entire screen is to be cleared before everything refreshes.
Clearing the entire screen usually isn't necessary.

=head2 KNum or KeyNumbers()

Returns a hash with key    numbers  => "names".

=head2 CLet or ColorLetters()

Returns a hash with color "letters" => numbers.

=head2 NumC or NumColors()

Returns the number of available colors 
(last index: NumC() - 1)

=head2 Hite or Height

Returns the current Simp object's window height 
(last index: Height() - 1)

=head2 Widt or Width

Returns the current Simp object's window width  
(last index: Width() - 1)

=head2 Prnt or PrintString( $String )

Prints $String at current cursor position.  PrintString() can also accept
a hash of parameters (eg. PrintString('text' => $String)) where:

  'text' => [ "String to Print" ], # or can just be string without arrayref
  'colr' => [ "ColorCodes corresponding to text" ], # same just string optn
  'ycrs' =>  3, # Number to move the cursor's y to before printing
  'xcrs' =>  7, # Number to move the cursor's x to before printing
  'yoff' => 15, # same as ycrs except original ycrs is restored afterwards
  'xoff' => 31, # same as xcrs except original xcrs is restored afterwards
  'prin' =>  1, # flag to specify whether printed text should update the
                #   main Text() && Colr() data or just print to the screen
                #   temporarily.  Default is true (ie. Print Into Text/Colr)

The hash keys can also be the corresponding VerboseNames described in the
new() section instead of these 4-letter abbreviated key names.

PrintString() returns the number of characters printed.

=head2 Draw or DrawWindow()

Draws the current Simp object with the established TextData() and
ColorData() functions.

DrawWindow() accepts a hash of parameters like new() which will update
as many attributes of the Simp object as are specified by key => value
pairs.

DrawWindow() returns the number of lines printed (which is normally the
same as Height()).

=head2 Wait or WaitTime( $Time )

WaitTime() does nothing for $Time seconds.

$Time can be an integer or floating point number of seconds.
(eg. WaitTime(1.27) does nothing for just over one second).

WaitTime() (like GetKey()) can also use alternate waiting methods.
The default $Time format is integer or floating seconds.  It can
also be a Time::Frame object or an integer of milliseconds.
These modes can be set with the FlagTimeFrame(1) and 
FlagMillisecond(1) methods respectively.

=head2 GetK or GetKey( [$Timeout [,$FlagSDLKey]] )

Returns a keypress if one is made or -1 after waiting $Timeout seconds.

$Timeout can be an integer or floating point number of seconds.
(eg. GetKey(2.55) waits for two and one-half seconds before returning -1
if no key was pressed).

Default behavior is to not block (ie. GetKey(0)).  Use GetKey(-1) for a
blocking keypress (ie. to wait indefinitely).

GetKey() can use alternate waiting methods.  The default is integer or
floating seconds.  It can also utilize Time::Frame objects
or integer milliseconds if preferred.  These modes can be set with
the FlagTimeFrame(1) and FlagMillisecond(1) methods respectively.

Under normal mode (ie. when $FlagSDLKey is absent or false), GetKey()
returns a string describing the key pressed.  This will either be a
single character or the Curses name for the key if a special key was
pressed.  The list of special key names that can be returned from 
normal mode are described in the L<"CURSES KEY NOTES"> section.  This
means that the return value should be easy to test directly like:

  use Curses::Simp;
  my $simp = Curses::Simp->new();
  my $key  = $simp->GetKey(-1); # get a blocking keypress
  if     (    $key  eq 'a'        ) { # do 'a' stuff
  } elsif(    $key  eq 'b'        ) { # do 'b' stuff
  } elsif(    $key  eq 'A'        ) { # do 'A' stuff
  } elsif(    $key  eq 'B'        ) { # do 'B' stuff
  } elsif(    $key  eq 'KEY_LEFT' ) { # do Left-Arrow-Key stuff
  } elsif(    $key  eq 'KEY_NPAGE') { # do PageDown       stuff
  } elsif(    $key  eq 'KEY_F1'   ) { # do F1 (Help)      stuff
  } elsif(ord($key) ==  9         ) { # do Tab    stuff
  } elsif(ord($key) == 13         ) { # do Return stuff
  } elsif(ord($key) == 27         ) { # do Escape stuff
  }

$FlagSDLKey is a flag (default is false) which tells GetKey() to return
a verbose key string name from the list of SDLKeys in the L<"SDLKEY NOTES">
section instead of the normal Curses key value or name.  In SDLKey mode,
GetKey() also sets flags for Shift, Control, and Alt keys which are
testable through KeyMode().

The $FlagSDLKey parameter sets SDLKey mode temporarily (ie. only for a
single execution of GetKey()).  This mode can be turned on permanently
via the FlagSDLKey(1) function.

If the $Timeout for GetKey() is reached and no keypress has
occurred (in either normal mode or SDLKey mode), -1 is returned.

=head2 KMod or KeyMode( [$KeyName [,$NewValue]] )

Returns the key mode (state) of the key mode name $KeyName.  $KeyName
should be one of the KMOD_ names from the bottom of the L<"SDLKEY NOTES">
section.

If no parameters are provided, the state of KMOD_NONE is returned.

If $NewValue is provided, the state of $KeyName is set to $NewValue.

=head2 Move or MoveCursor( [$YCursor, $XCursor] )

MoveCursor() updates the current Simp object's cursor position
to the newly specified $YCursor, $XCursor.

By default, the cursor is not visible but this can be changed through
the FlagCursorVisible(1) function.

Returns ($YCursor, $XCursor) as the coordinates of the cursor.

=head2 Rsiz or ResizeWindow( $Height, $Width )

ResizeWindow() updates the current Simp object's window dimensions
to the newly specified $Height, $Width.

Think of ResizeWindow() as an easy way to call both Height() and
Width() at once.

Returns ($Height, $Width) as the dimensions of the window.

=head2 Mesg or MessageWindow( $Message )

MessageWindow() draws a Message Window in the center of the screen to 
display $Message.  MessageWindow() can also accept a hash of parameters 
(eg. MessageWindow('mesg' => $Message)) where:

  'mesg' => "Message to Print",
  'text' => [ "same as new \@text" ],
  'colr' => [ "ColorCodes corresponding to mesg or text" ],
  'titl' => "MessageWindow Title string",
  'tclr' => "ColorCodes corresponding to titl",
  'flagpres' => 1, # a flag specifying whether to "Press A Key"
  'pres' => "Press A Key...", # string to append if flagpres is true
  'pclr' => "ColorCodes corresponding to pres",
  'wait' => 1.0, # floating number of seconds to wait
                 #   if flagpres is true,  MessageWindow() waits this
                 #     long for a keypress before quitting
                 #   if flagpres is false, MessageWindow() waits this
                 #     long regardless of whether keys are pressed

The hash keys can also be the corresponding VerboseNames described in the
new() section instead of these 4-letter abbreviated key names.

Returns the value of the pressed key (if the "Press A Key" flag was true).
This can be used to make simple one-character prompt windows.  For example:

  use Curses::Simp;
  my $simp   = Curses::Simp->new();
  my $answer = $simp->MessageWindow('titl' => 'Is Simp useful?',
                                    'pres' => '(Yes/No)');
               $simp->MessageWindow('titl' => 'Answer:', $answer);

=head2 Prmt or PromptWindow( \$DefaultRef )

PromptWindow() draws a Prompt Window in the center of the screen to 
display and update the value of $DefaultRef.  \$DefaultRef should be 
a reference to a variable containing a string you want edited or
replaced.  PromptWindow() can also accept a hash of parameters 
(eg. PromptWindow('dref' => \$DefaultRef)) where:

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

The hash keys can also be the corresponding VerboseNames described in the
new() section instead of these 4-letter abbreviated key names.

=head2 CPik or ColorPickWindow()

ColorPickWindow() is a simple Color Picker window.

It accepts arrow keys to highlight a particular color and enter to select.
The letter corresponding to the color or the number of the index can also
be pressed instead.

Returns the letter (ie. the Color Code) of the picked color.

=head2 DESTROY or DelW or DeleteWindow()

DeleteWindow() deletes all the components of the created Simp object
and calls ShockScreen() to cause the screen and all other created
objects to be redrawn.

=head1 ACCESSOR AND FLAG METHODS

Simp accessor and flag object methods have related interfaces as they
each access and update a single component field of Curses::Simp objects.  Each
one always returns the value of the field they access.  Thus if you want
to obtain a certain value from a Simp object, just call the accessor
method with no parameters.  If you provide parameters, the field will
be updated and will return its new value.

All of these methods accept a default parameter of their own type or
a hash of operations to perform on their field.

Some operations are only applicable to a subset of the methods as 
dictated by the field type.  The available operations are:

   Key   =>   Value Type  
    NormalName (if different) ... # Purpose
  -----      ------------ 
  'asin' =>  $scalar (number|string|arrayref)
   'assign' # asin is context-sensitive assignment to load the field
  'blnk' =>  $ignored         # blanks a string value
   'blank'
  'togl' =>  $ignored         # toggles    a flag value
   'toggle'
  'true' =>  $ignored         # trues      a flag value
  'fals' =>  $ignored         # falsifies  a flag value
   'false'
  'incr' =>  $numeric_amount  
   'increase' # increments if no $num is provided or increases by $num
  'decr' =>  $numeric_amount  
   'decrease' # decrements if no $num is provided or decreases by $num
  'nmrc' =>  $string          
   'numeric'
  # instead of an explicit 'nmrc' hash key, this means the
  #   key is an entirely numeric string like '1023'
  #   so the value gets assigned to that indexed element when
  #   the field is an array.  The key is assigned directly if
  #   the field is numeric or a string.
  # ARRAY-SPECIFIC operations:
  'size' => $ignored                # return the array size
  'push' => $scalar (number|string) # push new value
  'popp' => $ignored                # pop last value
   'pop'
  'apnd' => $scalar (number|string) # append to last element
   'append'
  'dupl' => $number                 # duplicate last line or
   'duplicate'                      #   $num line if provided
  'data' => $arrayref               # assigns the array if
                                    #   $arrayref provided &&
                                    #   returns ALL array data
  # LOOP-SPECIFIC operations:
  'next' => $ignored          # assign to next     in loop
  'prev' => $ignored          # assign to previous in loop
   'previous'

=head2 Array Accessors

  Text or TextData  # update the text  array
  Colr or ColorData # update the color array

=head2 Loop Accessors

  BTyp or WindowBorderType # loop through border types

=head2 Normal Accessors

  Name or VerboseName       # Description
  ----    -----------       -------------
  Hite or WindowHeight      # window height
  Widt or WindowWidth       # window width
  YOff or WindowYOffset     # window y-offset position
  XOff or WindowXOffset     # window x-offset position
  YCrs or CursorYOffset     # window y-cursor position
  XCrs or CursorXOffset     # window x-cursor position
  BClr or WindowBorderColor # border color code string
  Titl or WindowTitle       # title string
  TClr or WindowTitleColor  # title  color code string
  DNdx or DisplayStackIndex # global display index

=head2 Flag Accessors

  FlagName or VerboseFlagName Default # Description
  --------    --------------- ------- -------------
  FlagAuDr or FlagAutoDraw      1    # Automatic DrawWindow() call whenever 
                                     #   TextData or ColorData are updated
  FlagMaxi or FlagMaximize      1    # Maximize window
  FlagShrk or FlagShrinkToFit   1    # Shrink window to fit TextData
  FlagCntr or FlagCenter        1    # Center window within entire screen
  FlagCVis or FlagCursorVisible 0    # Cursor Visible
  FlagScrl or FlagScrollbar     0    # use Scrollbars
  FlagSDLK or FlagSDLKey        0    # use advanced SDLKey mode in GetKey()
  FlagBkgr or FlagBackground    0    # always expect background colors to be
                                     #   present in color codes
  FlagFram or FlagTimeFrame     0    # use Time::Frame objects  instead of
                                     #   float seconds for timing
  FlagMili or FlagMillisecond   0    # use integer milliseconds instead of
                                     #   float seconds for timing
  FlagPrin or FlagPrintInto     1    # PrintString() prints Into TextData
    # array.  If FlagPrintInto is false, then each call to PrintString()
    # only writes to the screen temporarily and will be wiped the next time
    # the window behind it is updated.

=head2 Accessor and Flag Method Usage Examples

  #!/usr/bin/perl -w
  use strict;
  use Curses::Simp;
  # create new object which gets auto-drawn with init params
  my $simp = Curses::Simp->new('text' => [ 'hmmm', 'haha', 'whoa', 'yeah' ],
                               'colr' => [ 'bbbB', 'bBBw', 'BwrR', 'ROYW' ],
                               'btyp' => 1,
                               'maxi' => 0); 
     $simp->GetK(-1);               # wait for a key press
     $simp->Text('push' => 'weee'); # add more to the Text
     $simp->Colr('push' => 'WwBb'); #              && Colr arrays
     $simp->Maxi('togl');           # toggle  the maximize flag
     $simp->GetK(-1);               # wait for a key press
     $simp->Text('2'    => 'cool'); # change index two elements of Text
     $simp->Colr('2'    => 'uUCW'); #                           && Colr
     $simp->Maxi('fals');           # falsify the maximize flag
     $simp->GetK(-1);               # wait for a key press
     $simp->Text('popp');           # pop the last elements off Text
     $simp->Colr('popp');           #                        && Colr
     $simp->BTyp('incr');           # increment the border type
     $simp->GetK(-1);               # wait for a key press
     $simp->Text('asin' => [ 'some', 'diff', 'rent', 'stuf' ]);
     $simp->Colr('asin' => [ 'GGYY', 'CCOO', 'UURR', 'WWPP' ]);
     $simp->BTyp('incr');           # increment the border type
     $simp->GetK(-1);               # wait for a key press before quitting

=head1 CURSES KEY NOTES

When the GetKey() function is in the normal default mode of input,
special keypress name strings will be returned when detected.  A
small set of the names below are found commonly (like the arrow 
keys, the function keys, HOME, END, PPAGE [PageUp], NPAGE [PageDown],
IC [Insert], and BACKSPACE) but they are all described here since
they are supported by L<Curses.pm> and therefore could arise.

The list of returnable Curses Key names are:

      KEY_F1                   KEY_F2                   KEY_F3                 
      KEY_F4                   KEY_F5                   KEY_F6                 
      KEY_F7                   KEY_F8                   KEY_F9                 
      KEY_F10                  KEY_F11                  KEY_F12                
      KEY_F13                  KEY_F14                  KEY_F15                
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
      KEY_UP                   KEY_MOUSE                                       

=head1 SDLKEY NOTES

The GetKey() function has a special advanced mode of input.
Instead of returning the plain keypress (eg. 'a'), the $FlagSDLKey
parameter can be set to true for temporary SDLKey mode or with
FlagSDLKey(1) for permanence so that verbose strings of SDLKey names
(eg. 'SDLK_a') will be returned.

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
  'SDLK_QUOTE',          #'\''    quote
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
  'SDLK_TILDE',          #'~'     tilde
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
  # SDLKeys below aren't detected correctly yet
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

SDLKey mode also sets flags in KeyMode() where:

   SDL Modifier                    Meaning
  --------------                  ---------
  'KMOD_NONE',           #        No modifiers applicable
  'KMOD_CTRL',           #        A  Control key is down
  'KMOD_SHIFT',          #        A  Shift   key is down
  'KMOD_ALT',            #        An Alt     key is down

=head1 COLOR NOTES

Colors can be encoded along with each text line to be printed.  
PrintString() and DrawWindow() each take hash parameters where the
key should be 'colr' or 'ColorData' and the value is a color code
string as described below.

A normal color code is simply a single character (typically just the
first letter of the color name and the case [upper or lower] 
designates high or low intensity [ie. Bold on or off]).  Simple 
single character color codes represent only the foreground color.
The default printing mode of color codes assumes black background
colors for everything.  There are special ways to specify non-black
background colors or to encode repeating color codes if you want to.
The default (which assumes no background colors are specified) can
be overridden object-wide by the FlagBackground(1) function.

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
breaks the (upper-case = bright) rule and is interpreted the same as
Lower-Case 'y'.  Every other color code is consistent with the rule.

=head2 Interpretation of Backgrounds and Repeats in Color Codes

The following mechanisms are available for changing the default color
code string interpretation to read background colors after foreground
and to specify abbreviations for code repeating:

The function FlagBackground(1) will specify that you wish to have all
color codes interpreted expecting both foreground and background
characters for each source text character.  Similarly,
FlagBackground(0) (which is the default setting of not expecting
Background characters) will turn off global background interpretation.

The base64 characters specified below are in the set [0-9A-Za-z._] and
are interpreted using the L<Math::BaseCnv> module available from the CPAN.

A space in a color code string is the same as 'b' (black).

When Background mode is OFF (ie. the default after FlagBackground(0)
or a code string following the '!' [Simp!] character):

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
         foreground and background color pair.
         After that, backgrounds return to black.
   : - The colon character specifies that the following character is a
         (presumably non-black) background character to use instead of 
         the default black for the remainder of the line (or until another
         special character overrides this one).
   ; - The semicolon (Advanced;) character specifies that the remaining
         part of the current color code line should be interpreted as if
         full background interpretation were turned ON (as if
         FlagBackground(1) had been called just for this line) so
         further interpretation proceeds like the FlagBackground(1)
         section below.

   Each background specification character takes effect starting with the 
     next encountered foreground character so:
       'RgX2UU', 'R:gUU', and 'R;Ugx2' all expand to 'RbUgUg' not 'RgUgUb'
   Some Examples:
     PrintString('Hello World',  # the simplest 1-to-1 text/color printing
                 'WWWWW UUUUU'); # all characters printed on black background
     PrintString('Hello World',  # the same as above but...
                 'Wx5bUx5');     #   using repeat (x) times
       Both of the above PrintString() calls would print 'Hello' in Bright
         White and 'World' in Bright blUe both on the default black
         background.  The color strings would expand from:
           'WWWWW UUUUU' or 'Wx5bUx5' to 'WbWbWbWbWbbbUbUbUbUbUb';
     PrintString('Hello World', 
                 'Wx5b,Gu,Gu,Gu,Gu,Gu');
     PrintString('Hello World', 
                 'Wx5b:uGx5');
     PrintString('Hello World', 
                 'WWWWWbuX5GGGGG');
     PrintString('Hello World', 
                 'Wx5buX5Gx5');
       These PrintString() calls would print 'Hello' the same as before
         but now 'World' would be in Bright Green on a dark blUe
         background.  These color strings would all expand to:
           'WbWbWbWbWbbbGuGuGuGuGu'.

When Background mode is ON  (ie. after FlagBackground(1) or a code
string following the ';' [Advanced;] character):

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
   ! - The bang (Simp!) character specifies that the remaining part of
         the current color code line should be interpreted as if
         background interpretation were turned OFF (as if
         FlagBackground(0) had been called just for this line) so further
         interpretation proceeds like the FlagBackground(0) section above.

   Some Examples:
     typical color pairs code string: 'WbWbWbGuGuGuGuGpGpGpYgYgYgYg'
       means 3 source characters should be Bright White  on black,
             4 source characters should be Bright Green  on blue,
             3 source characters should be Bright Green  on purple,
        and  4 source characters should be Bright Yellow on green.
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

If a color code string is terminated with a dollar ($) character,
this tells PrintString() and DrawWindow() that the string is 
already fully expanded and to forego passing the string to 
ExpandColorCodeString().

I have tried to make Simp very simple to use yet still flexible &&
powerful.  Please feel free to e-mail me any suggestions || coding 
tips || notes of appreciation like "I appreciate you!  I like to say 
appreciate.  You can say it too.  Go on.  Say it.  Say 'I appreciate 
you!  I like to say appreciate.  You can say it too.  Go on.  Say it.
Say "..."'"  Thank you.  It's like app-ree-see-ate.  TTFN.

=head1 CHANGES

Revision history for Perl extension Curses::Simp:

=over 4

=item - 1.0.4287FJQ  Sun Feb  8 07:15:19:26 2004

* made Brws()

* added ckbx && butn types to Mesg() && drop type to Prmt() && wrote Focu()
    to focus new types

* added info && help types to Mesg() to auto title && color those screens

* added blox && squr styles to CPik && made style/blockchar increment
    keys (PgUp/Dn/Home/End)

=item - 1.0.41V0L3a  Sat Jan 31 00:21:03:36 2004

* made flag accessors without ^Flag

* wrote support for VerboseName hash keys

* fixed ShokScrn overlap && DelW bugs

* made GetK return detected KEY_ names in normal mode && added CURSES
    KEY MODE section to POD && made both key modes return -1 if $tmot reached

* made ShokScrn not blank the screen so often

* made Text('1' => 'new line') use Prnt instead of Draw for efficiency

* updated POD to use VerboseNames instead of 4-letter names && erased most '&&'

* made verbose accessor names like VerboseName instead of verbose_name

=item - 1.0.41O4516  Sat Jan 24 04:05:01:06 2004

* made all but ptok && qbix non-executable for EXE_FILES

* updated POD && added Simp projects into bin/ && MANIFEST in preparation
    for release

=item - 1.0.41O3SQK  Sat Jan 24 03:28:26:20 2004

* fixed weird char probs in Draw && removed weird char support from Prnt

* added PrintInto '_flagprin' ability

* made new Mesg, Prmt, && CPik utils

* added SDLK advanced input option to GetK

* setup window border char sets

=item - 1.0.4140asO  Sun Jan  4 00:36:54:24 2004

* refined Draw() && InitPair() for objects instead of exported procedures

* CHANGES section && new objects created

=item - 1.0.37VG26k  Thu Jul 31 16:02:06:46 2003

* original version

=back

=head1 INSTALL

Please run:

    `perl -MCPAN -e "install Curses::Simp"`

or uncompress the package and run the standard:

    `perl Makefile.PL; make; make test; make install`

=head1 FILES

Curses::Simp requires:

=over 4

=item L<Carp>          - to allow errors to croak() from calling sub

=item L<Curses>        - provides core screen and input handling

=item L<Math::BaseCnv> - to handle number-base conversion

=back

Curses::Simp uses (if available):

=over 4

=item L<Time::PT>      - for pt color coding

=item L<Time::Frame>   - to provide another mechanism for timing

=back

=head1 LICENSE

Most source code should be Free!
  Code I have lawful authority over is and shall be!
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
my $ptim = eval("use Time::PT;    1") || 0;
my $fram = eval("use Time::Frame; 1") || 0;
our $VERSION     = '1.0.4287FJQ'; # major . minor . PipTimeStamp
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
  'TESTMAPP' => {
    'NORMAL' => 'wb$', #00
    'FILE'   => 'wb$', #00       # normal file
    'DIR'    => 'Ub$', #01;34    # directory
    'LINK'   => 'Wb$', #01;37    # symbolic link
    'FIFO'   => 'yb$', #00;33;40 # pipe
    'SOCK'   => 'Pb$', #01;35    # socket
    #'DOOR'   => 'Pb$', #01;35   # door
    'BLK'    => 'Yb$', #01;33;40 # block device driver
    'CHR'    => 'Yb$', #01;33;40 # character device driver
    'ORPHAN' => 'Rb$', #01;31;40 # symlink to nonexistent file
    'EXEC'   => 'Gb$', #01;32    # executable file
  },
  'DFLTMAPP' => {
    qr/\.(cmd|exe|com|btm|bat)$/                                  => 'Ob$',
    qr/\.(bak)$/                                                  => 'Pb$',
    qr/\.(asm|c|cpp|m|h|scm|pl|pm|py|cgi|htm|html)$/              => 'Cb$',
    qr/\.(tar|tgz|tbz|tbz2|arj|taz|lzh|zip|z|gz|bz|bz2|deb|rpm)$/ => 'Rb$',
    qr/\.(jpg|jpeg|gif|bmp|ppm|tga|xbm|xpm|tif|tiff|png|mpg|mpeg|avi|mov|gl|dl)$/ => 'pb$',
    qr/\.(txt|rtf)$/                                              => 'Wb$',
    qr/\.(cfg|ini)$/                                              => 'Yb$',
    qr/\.(ogg|mp3|s3m|mod|wav|xm|it)$/                            => 'Cb$',
  },
  'OVERMAPP' => { },
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
  'SDLK_QUOTE',          #'\''    quote
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
  'SDLK_TILDE',          #'~'     tilde
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
  '~' => 'TILDE',
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
         my %_verbose_attrnamz = ();
# field data
push(@_attrnamz, '_wind'); $_attrdata{$_attrnamz[-1]} = 0; # CursesWindowHandle
            $_verbose_attrnamz{$_attrnamz[-1]} = 'WindowHandle';
push(@_attrnamz, '_text'); $_attrdata{$_attrnamz[-1]} = []; # text  data
            $_verbose_attrnamz{$_attrnamz[-1]} = 'TextData';
push(@_attrnamz, '_colr'); $_attrdata{$_attrnamz[-1]} = []; # color data
            $_verbose_attrnamz{$_attrnamz[-1]} = 'ColorData';
push(@_attrnamz, '_hite'); $_attrdata{$_attrnamz[-1]} = 0;  # window height
            $_verbose_attrnamz{$_attrnamz[-1]} = 'WindowHeight';
push(@_attrnamz, '_widt'); $_attrdata{$_attrnamz[-1]} = 0;  # window width
            $_verbose_attrnamz{$_attrnamz[-1]} = 'WindowWidth';
push(@_attrnamz, '_yoff'); $_attrdata{$_attrnamz[-1]} = 0;  # window y-offset
            $_verbose_attrnamz{$_attrnamz[-1]} = 'WindowYOffset';
push(@_attrnamz, '_xoff'); $_attrdata{$_attrnamz[-1]} = 0;  # window x-offset
            $_verbose_attrnamz{$_attrnamz[-1]} = 'WindowXOffset';
push(@_attrnamz, '_ycrs'); $_attrdata{$_attrnamz[-1]} = 0;  # cursor y-offset
            $_verbose_attrnamz{$_attrnamz[-1]} = 'CursorYOffset';
push(@_attrnamz, '_xcrs'); $_attrdata{$_attrnamz[-1]} = 0;  # cursor x-offset
            $_verbose_attrnamz{$_attrnamz[-1]} = 'CursorXOffset';
push(@_attrnamz, '_btyp'); $_attrdata{$_attrnamz[-1]} = 0;    # border type
            $_verbose_attrnamz{$_attrnamz[-1]} = 'WindowBorderType';
push(@_attrnamz, '_bclr'); $_attrdata{$_attrnamz[-1]} = 'wb$'; # border color
            $_verbose_attrnamz{$_attrnamz[-1]} = 'WindowBorderColor';
push(@_attrnamz, '_titl'); $_attrdata{$_attrnamz[-1]} = ''; # window title
            $_verbose_attrnamz{$_attrnamz[-1]} = 'WindowTitle';
push(@_attrnamz, '_tclr'); $_attrdata{$_attrnamz[-1]} = 'Wb$'; # title color
            $_verbose_attrnamz{$_attrnamz[-1]} = 'WindowTitleColor';
push(@_attrnamz, '_dndx'); $_attrdata{$_attrnamz[-1]} = 0;    # DISPSTAK index
            $_verbose_attrnamz{$_attrnamz[-1]} = 'DisplayStackIndex';
# Flags, storage Values, && extended attributes
push(@_attrnamz, '_flagaudr'); $_attrdata{$_attrnamz[-1]} = 1; # Auto Draw()
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagAutoDraw';
push(@_attrnamz, '_flagmaxi'); $_attrdata{$_attrnamz[-1]} = 1; # Maximize
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagMaximize';
push(@_attrnamz, '_flagshrk'); $_attrdata{$_attrnamz[-1]} = 1; # ShrinkToFit
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagShrinkToFit';
push(@_attrnamz, '_flagcntr'); $_attrdata{$_attrnamz[-1]} = 1; # Center
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagCenter';
push(@_attrnamz, '_flagcvis'); $_attrdata{$_attrnamz[-1]} = 0; # CursorVisible
               $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagCursorVisible';
push(@_attrnamz, '_flagscrl'); $_attrdata{$_attrnamz[-1]} = 0; # Scrollbar
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagScrollbar';
push(@_attrnamz, '_flagsdlk'); $_attrdata{$_attrnamz[-1]} = 0; # SDLK
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagSDLKey';
push(@_attrnamz, '_flagbkgr'); $_attrdata{$_attrnamz[-1]} = 0; # background
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagBackground';
push(@_attrnamz, '_flagfram'); $_attrdata{$_attrnamz[-1]} = 0; # Time::Frame
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagTimeFrame';
push(@_attrnamz, '_flagmili'); $_attrdata{$_attrnamz[-1]} = 0; # millisecond
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagMillisecond';
push(@_attrnamz, '_flagprin'); $_attrdata{$_attrnamz[-1]} = 1; # Prnt into self
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagPrintInto';
push(@_attrnamz, '_flaginsr'); $_attrdata{$_attrnamz[-1]} = 1; # insert mode
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagInsertMode';
push(@_attrnamz, '_flagdrop'); $_attrdata{$_attrnamz[-1]} = 0; # DropDown
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagDropDown';
push(@_attrnamz, '_flagdown'); $_attrdata{$_attrnamz[-1]} = 0; # DropIsDown
                $_verbose_attrnamz{$_attrnamz[-1]} = 'FlagDropIsDown';
push(@_attrnamz, '_valulasp'); $_attrdata{$_attrnamz[-1]} = undef; # last pair
                $_verbose_attrnamz{$_attrnamz[-1]} = 'LastPair';
push(@_attrnamz, '_valullsp'); $_attrdata{$_attrnamz[-1]} = undef; # llastpair
                $_verbose_attrnamz{$_attrnamz[-1]} = 'LastLastPair';
push(@_attrnamz, '_valulasb'); $_attrdata{$_attrnamz[-1]} = undef; # last bold
                $_verbose_attrnamz{$_attrnamz[-1]} = 'LastBold';
push(@_attrnamz, '_valullsb'); $_attrdata{$_attrnamz[-1]} = undef; # llastbold
                $_verbose_attrnamz{$_attrnamz[-1]} = 'LastLastBold';
push(@_attrnamz, '_valudol8'); $_attrdata{$_attrnamz[-1]} = undef; # do late
                $_verbose_attrnamz{$_attrnamz[-1]} = 'LateEscapedPrint';

# methods
sub DfltValu   { my ($self, $attr) = @_; $_attrdata{$attr}; } 
sub AttrNamz { @_attrnamz; } #         attribute names

# MkMethdz creates Simp object field accessor methods with 
#   configurable handling && overrideable default operations.  Beppu@CPAN.Org
#   coded the first version of MkMethdz && taught me a new trick as such. =)
# Special Parameters:
#   NAME => name of the method to be created
#   ARAY => if this is true, $self->{$attr} is assumed to be
#           an array ref, and default subcommands are installed
#   LOOP => like ARAY above but a looping value instead
#   ...  => other method flags describing what to include in made method
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
  $cmnd{'assign'} ||= $cmnd{'asin'}; # handle normal names too =)
  $cmnd{'blnk'} ||= sub { # Dflt blank  command
    my $self = shift;
    $self->{$attr}   = '';
    $self->{'_chgd'} = 1;
  };
  $cmnd{'blank'} ||= $cmnd{'blnk'}; # handle normal names too =)
  $cmnd{'togl'} ||= sub { # Dflt toggle command (for flags)
    my $self = shift;
    $self->{$attr}  ^= 1;
    $self->{'_chgd'} = 1;
  };
  $cmnd{'toggle'} ||= $cmnd{'togl'}; # handle normal names too =)
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
  $cmnd{'false'} ||= $cmnd{'fals'}; # handle normal names too =)
  $cmnd{'incr'} ||= sub { # Dflt increment command
    my $self = shift; my $amnt = shift || 1;
    if(!$dstk || $self->{'_dndx'} < $#DISPSTAK) {
      if($dstk) { # exchange display stack indices 
        ${$DISPSTAK[ $self->{'_dndx'} - 1]}->{'_dndx'}--;
        ($DISPSTAK[$self->{'_dndx'}    ], $DISPSTAK[$self->{'_dndx'} + 1]) =
        ($DISPSTAK[$self->{'_dndx'} + 1], $DISPSTAK[$self->{'_dndx'}    ]);
      }
      $self->{$attr} += $amnt;
      $self->{'_chgd'} = 1;
    }
  };
  $cmnd{'increase'} ||= $cmnd{'incr'}; # handle normal names too =)
  $cmnd{'decr'} ||= sub { # Dflt decrement command
    my $self = shift; my $amnt = shift || 1;
    if(!$dstk || $self->{'_dndx'}) {
      if($dstk) { # exchange display stack indices 
        ${$DISPSTAK[ $self->{'_dndx'} - 1]}->{'_dndx'}++;
        ($DISPSTAK[$self->{'_dndx'}    ], $DISPSTAK[$self->{'_dndx'} - 1]) =
        ($DISPSTAK[$self->{'_dndx'} - 1], $DISPSTAK[$self->{'_dndx'}    ]);
      }
      $self->{$attr} -= $amnt;
      $self->{'_chgd'} = 1;
    }
  };
  $cmnd{'decrease'} ||= $cmnd{'decr'}; # handle normal names too =)
  if($aray) { # default commands for when $self->{$attr} is an array ref 
    $cmnd{'push'} ||= sub { # Dflt push
      my $self = shift;
      push(@{$self->{$attr}}, shift);
      $self->{'_chgd'} = 1;
    };
    $cmnd{'popp'}  ||= sub { # Dflt pop
      my $self = shift;
      pop(@{$self->{$attr}});
      $self->{'_chgd'} = 1;
    };
    $cmnd{'pop'} ||= $cmnd{'popp'}; # handle normal names too =)
    $cmnd{'apnd'} ||= sub { # Dflt append to last line
      my $self = shift;
      if(@{$self->{$attr}}) { $self->{$attr}->[-1] .= shift;  }
      else                  { push(@{$self->{$attr}}, shift); }
      $self->{'_chgd'} = 1;
    };
    $cmnd{'append'} ||= $cmnd{'apnd'}; # handle normal names too =)
    $cmnd{'dupl'} ||= sub { # Dflt duplicate last line or some line #
      my $self = shift; my $lndx = shift || -1;
      if(@{$self->{$attr}}) { 
        push(@{$self->{$attr}}, $self->{$attr}->[$lndx]);
      } else {
        push(@{$self->{$attr}}, '');
      }
      $self->{'_chgd'} = 1;
    };
    $cmnd{'duplicate'} ||= $cmnd{'dupl'}; # handle normal names too =)
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
        if($attr =~ /^text/i && $self->{'_flagaudr'}) {
          # new Prnt() just changing line
          $self->Prnt('text' => $valu, 'prin' => 0,
                      'yoff' => $keey, 'xoff' => 0);
        } else {
          # old array element assignment with full AutoDraw
          $self->{'_chgd'} = 1;
        }
      } else { # just return array line
        return($self->{$attr}->[$keey]);
      }
    };
    $cmnd{'numeric'} ||= $cmnd{'nmrc'}; # handle normal names too =)
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
    $cmnd{'numeric'} ||= $cmnd{'nmrc'}; # handle normal names too =)
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
    $cmnd{'previous'} ||= $cmnd{'prev'}; # handle normal names too =)
  }
  { # block to isolate no strict where closure gets defined
    no strict 'refs';
    *{$meth} = sub {
      my $self = shift; my ($keey, $valu); my $foun;
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
        } else { # match && update any attributes accepted by new()
          $foun = 0;
          foreach my $attr ( $self->AttrNamz() ) { 
            if     ($attr =~ /$keey/i ||
                    $_verbose_attrnamz{$attr} eq $keey) { # exact match
              $self->{$attr} = $valu;
              $foun = 1;
            }
          }
          unless($foun) {
            croak "!*EROR*! Curses::Simp::$meth key:$keey was not recognized!\n";
#            $keey =~ s/^_*/_/; # auto-add unfound
#            $self->{$keey} = $valu; 
          }
        }
      }
      $self->{$attr} = $self->ExpandCC($self->{$attr}) . '$' if($excc &&
                                              $self->{$attr} !~ /\$$/);
      curs_set($self->{'_flagcvis'})                         if($curs);
      ($self->{'_flagmaxi'}, $self->{'_flagshrk'}) = (0, 0)  if($rsiz);
      ($self->{'_flagmaxi'}, $self->{'_flagcntr'}) = (0, 0)  if($mvwn);
       $self->Move()                                         if($mvcr);
      if   ($self->{'_chgd'} && $self->{'_flagaudr'}) { $self->Draw(); }
      elsif($mvwn || $updt)                           { $self->Updt(); }
      elsif($rsiz)                                    { $self->Rsiz(); }
      $self->{'_chgd'} = 0;
      return($self->{$attr});
    };
    # also define verbose names as alternate accessor methods
    *{$_verbose_attrnamz{$attr}} = \&{$meth};
    #   ... and if the method is a Flag accessor, provide with out /^Flag/
    if($meth =~ /^Flag/) {
      my $flgm = $meth; $flgm =~ s/^Flag//;
      *{$flgm} = \&{$meth};
    }
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
MkMethdz( 'NAME' => 'FlagDrop' );
MkMethdz( 'NAME' => 'FlagDown' );

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
      if($fgcl > 7 || $fgcl < 0) { $fgcl = 7; }
      $bgcl  = 0 unless(defined($bgcl) && $bgcl =~ /^\d+$/i);
      $bgcl %= 8 if($bgcl > 7);
      $bgcl  = 0 if($bgcl < 0);
      $curp  = ($bgcl * NumC()) + $fgcl + 1;
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

sub CnvAnsCC { # convert ANSI escape color codes into Simp color codes
  my $self = shift; my $acod = shift; my $bkgd = shift; 
  my @alut = qw( b r g y u p c w );
  my $bold = 0;     my $ccod = '';    my ($fgcl, $bgcl) = ('w', 'b');
  $bkgd = $self->{'_flagbkgr'} unless(defined($bkgd));
  $acod =~ s/(^;|^0|;)$//g; # strip all trailing or leading semicolons or zeros
#                          Attribute        codes:
#    00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
#                          Foreground color codes:
#    30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
#                          Background color codes:
#    40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
  while($acod =~ s/^(\d+);?//) {
    if   ( 1 == $1            ) { $bold = 1;                }
    elsif(30 <= $1 && $1 <= 37) { $fgcl = $alut[($1 - 30)]; }
    elsif(40 <= $1 && $1 <= 47) { $bgcl = $alut[($1 - 40)]; }
  }
  $ccod  =    $fgcl; 
  $ccod  = uc($ccod) if($bold);
  $ccod .=    $bgcl  if($bkgd);
  return($ccod);
}

sub ExpandCC { # fill out abbreviations in color code strings
  my $self = shift; my $ccod = shift; my $bkgd = shift; 
  my @mtch; my @chrz; my $btai;
  $bkgd = $self->{'_flagbkgr'} unless(defined($bkgd));
  $ccod =~ s/\$(.)/$1/g; # strip all non-terminating dollars
  return($ccod) if($ccod =~ /\$$/); # return right away if '$' terminated
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
  my $self = shift; my ($ycrs, $xcrs); my $slvl = 0;
  my ($keey, $valu); my $foun;
  while(@_) { # load key/vals like new()
    ($keey, $valu) = (shift, shift); $foun = 0;
    if(defined($valu)) { 
      foreach my $attr ( $self->AttrNamz() ) { 
        if     ($attr =~ /$keey/i ||
                $_verbose_attrnamz{$attr} eq $keey) { # exact match
          $self->{$attr} = $valu;
          $foun = 1;
        }
      }
      unless($foun) {
        if($keey =~ /slvl/i) {
          $slvl = $valu;
        } else {
          croak "!*EROR*! Curses::Simp::ShokScrn key:$keey was not recognized!\n";
#        $keey =~ s/^_*/_/; # auto-add unfound
#        $self->{$keey} = $valu; 
        }
      }
    } else {
      $slvl = $keey;
    }
  }
  if($slvl > 0) {
    if($slvl > 1) {
      if($slvl > 2) {
        clear();    }
      touchwin(); }
    refresh();  }
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
sub OScr { # Open a new Curses Screen && setup all useful stuff
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
                     'tt' => ACS_TTEE,  'bt' => ACS_BTEE,  
                     'hl' => ACS_HLINE, 'vl' => ACS_VLINE, 
        'll' => ACS_LLCORNER,                  'lr' => ACS_LRCORNER,
      },
      { 
        'ul' => ' ', 'rt' => ' ', 'lt' => ' ', 'ur' => ' ',
                     'tt' => ' ', 'bt' => ' ',
        'll' => ' ', 'hl' => ' ', 'vl' => ' ', 'lr' => ' ',
      },
      {
        'ul' => '+', 'rt' => '{', 'lt' => '}', 'ur' => '+',
                     'tt' => '+', 'bt' => '+',
        'll' => '+', 'hl' => '-', 'vl' => '|', 'lr' => '+',
      },
      {
        'ul' => 'X', 'rt' => '[', 'lt' => ']', 'ur' => 'X',
                     'tt' => '#', 'bt' => '#',
        'll' => 'X', 'hl' => '=', 'vl' => 'I', 'lr' => 'X',
      },
#   032:20: !"#$%&'   040:28:()*+,-./   048:30:01234567   056:38:89:;<=>?
#   064:40:@ABCDEFG   072:48:HIJKLMNO   080:50:PQRSTUVW   088:58:XYZ[\]^_
#   096:60:`abcdefg   104:68:hijklmno   112:70:pqrstuvw   120:78:xyz{|}~
#   160:A0:��������   168:A8:��������   176:B0:��������   184:B8:��������
#   192:C0:��������   200:C8:��������   208:D0:��������   216:D8:��������
#   224:E0:��������   232:E8:��������   240:F0:��������   248:F8:��������
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
      if(defined($knam[$i]) &&                      # not mapping -1..9 since 
         $kndx[$i] =~ /../  && $kndx[$i] ne '-1') { # "0".."9" are normal chars
        $knum{"$kndx[$i]"} = "$knam[$i]";           # && -1 when $tmot reached
      }
    }
    # add my own new additional key<->num mappings (ie. 265..279 => F1..F15)
    for($i = 265; $i <= 279; $i++) { $knum{"$i"} = "KEY_F" . ($i-264); }
  }
  return(); 
}
# Following are Curses funcs that might be useful to call in CloseScreen():
#   termname(), erasechar(), killchar()
sub CScr { # Close the previously Opened Curses Screen 
  if($GLBL{'FLAGOPEN'}) { 
    $GLBL{'FLAGOPEN'} = 0; 
    ${$DISPSTAK[0]}->DelW() while(@DISPSTAK); # delete all simp objects first
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
  foreach my $attr ( $self->AttrNamz() ) { 
    $self->{$attr} = $self->DfltValu($attr); # init defaults
    $self->{$attr} = $nvkr->{$attr} if($nobj);     #  && copy if supposed to
  }
  foreach(@KMODNAMZ) { $self->{'_kmod'}->{$_} = 0; }
  # there were init params with no colon (classname)
  if(defined($cork) && $cork !~ /::/) { 
    $nvkr = shift if($nvkr =~ /::/);
    while(@_) {
      my $foun = 0;
      ($keey, $valu) = (shift, shift);
      foreach my $attr ( $self->AttrNamz() ) { 
        if($attr =~ /$keey/i) {
          $self->{$attr} = $valu;
          $foun = 1;
        }
      }
      unless($foun) {
        foreach my $attr ( $self->AttrNamz() ) { 
          if($_verbose_attrnamz{$attr} eq $keey) { # exact match
            $self->{$attr} = $valu;
            $foun = 1;
          }
        }
        unless($foun) {
          croak "!*EROR*! Curses::Simp::new initialization key:$keey was not recognized!\n";
        }
      }
    }
  }
  $self->{'_bclr'} = $self->ExpandCC($self->{'_bclr'}) . '$' unless($self->{'_bclr'} =~ /\$$/);
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
  my $foun;
  $parm{'nore'} = 0; # No Refresh flag init'd to false
  $parm{'ycrs'} = $self->{'_ycrs'};
  $parm{'xcrs'} = $self->{'_xcrs'};
  if($self->{'_btyp'}) { $parm{'ycrs'}++; $parm{'xcrs'}++; }
  $parm{'prin'} = $self->{'_flagprin'}; # init prin param
  while(@_) { # load params
    ($keey, $valu) = (shift, shift); $foun = 0;
    if(defined($valu)) { 
      foreach my $attr ( $self->AttrNamz() ) { 
        if($_verbose_attrnamz{$attr} eq $keey) { # exact match
          $attr =~ s/^_*//; 
          $parm{$attr} = $valu;
          $foun = 1;
        }
      }
      unless($foun) {
        $keey =~ s/^_*//; 
        $parm{$keey} = $valu; 
      }
    } else {
      $parm{'text'} = $keey; 
    }
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
  $parm{'text'} =~ s/[ 	��]/ /g; # Prnt does not support escaped printf chars like Draw
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
    $parm{'colr'} = $self->ExpandCC($parm{'colr'}) . '$' unless($parm{'colr'} =~ /\$$/);
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
  } elsif(!$parm{'nore'}) {
    $self->{'_wind'}->refresh();
  }
  return($cnum);
}

sub Draw { # Simp object self Drawing method
  my $self = shift;  my ($fgcl, $bgcl); my ($lnum, $cnum); my ($ltxt, $clin);
  my ($keey, $valu); my ($delt, $char); my ($yoff, $xoff); my ($ordc, $ordd);
  my $dol8; my $tndx; my $foun;
  while(@_) { # load key/vals like new()
    ($keey, $valu) = (shift, shift); $foun = 0;
    if(defined($valu)) { 
      foreach my $attr ( $self->AttrNamz() ) { 
        if     ($attr =~ /$keey/i ||
                $_verbose_attrnamz{$attr} eq $keey) { # exact match
          $self->{$attr} = $valu;
          $foun = 1;
        }
      }
      unless($foun) {
        croak "!*EROR*! Curses::Simp::Draw key:$keey was not recognized!\n";
#        $keey =~ s/^_*/_/; # auto-add unfound
#        $self->{$keey} = $valu; 
      }
    } else {
      my $reft = ref($keey);
      if($reft eq 'ARRAY') {   $self->{'_text'}  = $keey; }
      else                 { @{$self->{'_text'}} = split(/\n/, $keey); }
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
    if( $self->{'_flagscrl'} || 
       ($self->{'_flagdrop'} && !$self->{'_flagdown'})) {
      $self->{'_wind'}->move(0, ($self->{'_widt'} - 4));
      $self->BordChar('tt', 1);
      $self->{'_wind'}->move(0, ($self->{'_widt'} - 1));
    }
    $self->BordChar('ur', 1);
  }
  for($lnum = 0;  $lnum < @{$self->{'_text'}} && 
                ( $lnum <  ($self->{'_hite'} - 2) || 
                 ($lnum <   $self->{'_hite'} && !$self->{'_btyp'})); $lnum++) {
    $ltxt = $self->{'_text'}->[$lnum];
    chomp($ltxt) if(defined($ltxt));
    $self->BordChar('vl', 1) if($self->{'_btyp'});
    $self->InitPair(-1)      if($self->{'_btyp'});
    $ltxt = ' ' x $self->{'_widt'} unless(defined($ltxt));
    if     (length($ltxt) > ($self->{'_widt'} - 2) && $self->{'_btyp'}) {
      $ltxt = substr($ltxt, 0, ($self->{'_widt'} - 2)); 
    } elsif(length($ltxt) > $self->{'_widt'}) {
      $ltxt = substr($ltxt, 0,  $self->{'_widt'});
    }
    if((exists($self->{'_colr'}) && $self->{'_colr'} && @{$self->{'_colr'}}) ||
       $ltxt =~ /[ 	��]/) {
      if($self->{'_colr'} && defined($self->{'_colr'}->[$lnum])) {
        $clin = $self->{'_colr'}->[$lnum];
        unless($clin =~ /\$$/) { 
          $clin =~ s/\$(.)/$1/g; # strip all non-terminating '$'
          $clin = $self->ExpandCC($clin) . '$'; # expand && terminate
          $self->{'_colr'}->[$lnum] = $clin;    # store back in self
        }
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
                                           !defined($ltxt)     || 
                                            length($ltxt) == $self->{'_widt'});
      }
    } else { # no color
      $self->{'_wind'}->addstr($ltxt);
      if(length($ltxt) < ($self->{'_widt'} - 2)) { 
        $self->{'_wind'}->addstr(' ' x (($self->{'_widt'} - 2) - length($ltxt))); 
        $self->{'_wind'}->addstr('  ') unless($self->{'_btyp'});
      }
    }
    $self->BordChar('vl') if($self->{'_btyp'});
  }
  # pad blank lines if height not full
  if(($lnum < ($self->{'_hite'} - 2)) ||
     ($lnum <  $self->{'_hite'} && !$self->{'_btyp'})) {
    $ltxt  = ' ' x ($self->{'_widt'} - 2);
    $ltxt .= '  ' unless($self->{'_btyp'});
    while($lnum < $self->{'_hite'}) {
      if($self->{'_btyp'}) {
        $self->BordChar('vl', 1);
        $self->InitPair('b', 'b'); # black blanks
      }
      $self->{'_wind'}->addstr($ltxt);
      if($self->{'_btyp'}) {
        $self->BordChar('vl');
        $lnum+=2 if($lnum >= ($self->{'_hite'} - 3));
      }
      $lnum++;
    }
  }
  if($self->{'_btyp'}) {
    $self->BordChar('ll');
    $self->BordChar('hl', 1) foreach(2..$self->{'_widt'});
    $self->BordChar('lr', 1);
    if     ($self->{'_flagdrop'} && !$self->{'_flagdown'}) {
      $self->{'_wind'}->move(1, ($self->{'_widt'} - 4));
      $self->BordChar('vl', 1); $self->{'_wind'}->addstr('\/');
      $self->{'_wind'}->move(($self->{'_hite'} - 1), ($self->{'_widt'} - 4));
      $self->BordChar('bt', 1);
    } elsif($self->{'_flagscrl'}) {
      $self->{'_wind'}->move(1, ($self->{'_widt'} - 4));
      $self->BordChar('vl', 1); $self->{'_wind'}->addstr('/\\');
      for(my $lndx = 2; $lndx < ($self->{'_hite'} - 2); $lndx++) {
        $self->{'_wind'}->move($lndx, ($self->{'_widt'} - 4));
        $self->BordChar('vl', 1); $self->{'_wind'}->addstr('..');
      }
      $self->{'_wind'}->move(($self->{'_hite'} - 2), ($self->{'_widt'} - 4));
      $self->BordChar('vl', 1); $self->{'_wind'}->addstr('\/');
      $self->{'_wind'}->move(($self->{'_hite'} - 1), ($self->{'_widt'} - 4));
      $self->BordChar('bt', 1);
    }
  }
  $self->{'_valudol8'} = $dol8 if(defined($dol8));
  $self->Move(); # replace cursor position && refresh the window
  return();
}

sub Wait { 
  my $self = shift;  my $wait = 0;
  my ($keey, $valu); my $foun;
  while(@_) { # load key/vals like new()
    ($keey, $valu) = (shift, shift); $foun = 0;
    if(defined($valu)) { 
      foreach my $attr ( $self->AttrNamz() ) { 
        if     ($attr =~ /$keey/i ||
                $_verbose_attrnamz{$attr} eq $keey) { # exact match
          $self->{$attr} = $valu;
          $foun = 1;
        }
      }
      unless($foun) {
        if($keey =~ /wait/i) {
          $wait = $valu;
        } else {
          croak "!*EROR*! Curses::Simp::Wait key:$keey was not recognized!\n";
#        $keey =~ s/^_*/_/; # auto-add unfound
#        $self->{$keey} = $valu; 
        }
      }
    } else {
      $wait = $keey;
    }
  }
  if     ( $self->{'_flagfram'}) { # cnv from Time::Frame        to Curses ms
    $wait = Time::Frame->new($wait) unless(ref($wait) eq "Time::Frame");
    $wait = int($wait->total_frames() / 60.0 * 1000);
  } elsif(!$self->{'_flagmili'}) { # cnv from Dflt float seconds to Curses ms
    $wait = int($wait * 1000);
  }
  return(napms($wait)); 
}

sub GetK { 
  my $self = shift;  my $tmot = 0; my $tsdl = 0;
  my ($keey, $valu); my $foun;
  while(@_) { # load key/vals like new()
    ($keey, $valu) = (shift, shift); $foun = 0;
    if(defined($valu)) { 
      foreach my $attr ( $self->AttrNamz() ) { 
        if     ($attr =~ /$keey/i ||
                $_verbose_attrnamz{$attr} eq $keey) { # exact match
          $self->{$attr} = $valu;
          $foun = 1;
        }
      }
      unless($foun) {
        if     ($keey =~ /tmot/i || $keey eq 'Timeout') {
          $tmot = $valu;
        } elsif($keey =~ /tsdl/i || $keey eq 'TempSDLKey') {
          $tsdl = $valu;
        } else {
          croak "!*EROR*! Curses::Simp::GetK key:$keey was not recognized!\n";
#        $keey =~ s/^_*/_/; # auto-add unfound
#        $self->{$keey} = $valu; 
        }
      }
    } else {
      $tmot = $keey;
    }
  }
  if($tmot ne '-1') {
    if     ( $self->{'_flagfram'}) { # cnv from Time::Frame        to Curses ms
      $tmot = Time::Frame->new($tmot) unless(ref($tmot) eq "Time::Frame");
      $tmot = int($tmot->total_frames() / 60.0 * 1000);
    } elsif(!$self->{'_flagmili'}) { # cnv from Dflt float seconds to Curses ms
      $tmot = int($tmot * 1000);
    }
  }
  timeout($tmot); 
  if($self->{'_flagsdlk'} || $tsdl) {
    my $char = getch(); my $ordc = ord($char);
    foreach(@KMODNAMZ) { $self->{'_kmod'}->{$_} = 0; }
    $self->{'_kmod'}->{'KMOD_NONE'} = 1;
    if($char =~ /^[A-Z]$/) {
      $self->{'_kmod'}->{'KMOD_NONE'}  = 0;
      $self->{'_kmod'}->{'KMOD_SHIFT'} = 1;
      $char = lc($char);
    }
    return($char)                          if($char eq '-1'); # $tmot reached
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
    my $char = getch(); #my $ordc = ord($char);
    if(exists($knum{$char})) { # return "KEY_" names if exists
      return("$knum{$char}");
    } else {
      return(       $char  );
    }
  }
}

sub KMod { # accessor for the %{$self->{'_kmod'}} hash
  my $self = shift;  my $kmod = 'KMOD_NONE';
  my ($keey, $valu); my $foun;
  while(@_) { # load key/vals like new()
    ($keey, $valu) = (shift, shift); $foun = 0;
    if(defined($valu)) { 
      foreach my $attr ( $self->AttrNamz() ) { 
        if     ($attr =~ /$keey/i ||
                $_verbose_attrnamz{$attr} eq $keey) { # exact match
          $self->{$attr} = $valu;
          $foun = 1;
        }
      }
      unless($foun) {
        if($keey =~ /kmod/i) {
          $kmod = $valu;
        } else {
          croak "!*EROR*! Curses::Simp::KMod key:$keey was not recognized!\n";
#        $keey =~ s/^_*/_/; # auto-add unfound
#        $self->{$keey} = $valu; 
        }
      }
    } else {
      $kmod = $keey;
    }
  }
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
    if     (($ycrs == $self->{'_hite'} - 1 &&
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
  my $self = shift;  my $noch = 0; # No Changes flag
  my ($keey, $valu); my $foun;
  while(@_) { # load key/vals like new()
    ($keey, $valu) = (shift, shift); $foun = 0;
    if(defined($valu)) { 
      foreach my $attr ( $self->AttrNamz() ) { 
        if     ($attr =~ /$keey/i ||
                $_verbose_attrnamz{$attr} eq $keey) { # exact match
          $self->{$attr} = $valu;
          $foun = 1;
        }
      }
      unless($foun) {
        if($keey =~ /noch/i) {
          $noch = $valu;
        } else {
          croak "!*EROR*! Curses::Simp::Updt key:$keey was not recognized!\n";
#        $keey =~ s/^_*/_/; # auto-add unfound
#        $self->{$keey} = $valu; 
        }
      }
    } else {
      $noch = $keey;
    }
  }
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
      $self->{'_hite'}  = getmaxy() if($self->{'_hite'} > getmaxy());
      $self->{'_widt'}  =  1;
      $self->{'_widt'} += (1 + length($self->{'_titl'})) if(length($self->{'_titl'}));
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
      $self->Rsiz();
#      $self->{'_wind'}->resize($self->{'_hite'}, $self->{'_widt'});
      if($hite >  $self->{'_hite'} || $widt >  $self->{'_widt'}) { 
        $self->ShokScrn(2); # Clear/Refresh main screen because window shrank
      }
      $noch = 0;
    }
    if($yoff != $self->{'_yoff'} || $xoff != $self->{'_xoff'}) {
      $self->{'_wind'}->mvwin( $self->{'_yoff'}, $self->{'_xoff'});
      $self->ShokScrn(2); # Clear/Refresh main screen because window moved
      $noch = 0;
    }
  }
  return(!$noch); # return flag telling whether self resized or moved
}

# Mesg() is a special Curses::Simp object constructor which creates a 
#   completely temporary Message window.
# If params are supplied, they must be hash key => value pairs.
sub Mesg {
  my $main = shift; my ($keey, $valu); my $char = -1;
  my $self = bless({}, ref($main));
  foreach my $attr ( $self->AttrNamz() ) { 
    $self->{$attr} = $self->DfltValu($attr); # init defaults
  }
  # special Mesg window defaults
  $self->{'_flagmaxi'} = 0; # not maximized 
  $self->{'_flagcvis'} = 0; # don't show cursor
  $self->{'_mesg'} =   '';#EROR!';
  $self->{'_text'} = [ ];
  $self->{'_colr'} = [ 'Cu$'   ];
  $self->{'_titl'} =   'Message:';
  $self->{'_tclr'} =   'Gb$';
  $self->{'_flagpres'} = 1;
  $self->{'_pres'} =   'Press A Key...';
  $self->{'_pclr'} =   'Yr$';
  $self->{'_wait'} =     0;
  $self->{'_type'} =    ''; # type can be set to special message types
                            #   like 'help' or 'info'
  $self->{'_stat'} =     0; # checkbox status
  $self->{'_elmo'} =    ''; # special field to make this Mesg an ELeMent Of
  foreach(@KMODNAMZ) { $self->{'_kmod'}->{$_} = 0; }
  # there were init params with no colon (classname)
  while(@_) {
    ($keey, $valu) = (shift, shift);
    if(defined($valu)) {
      if($keey =~ /^(mesg|pres|wait|type|stat|elmo)$/) {
        $self->{"_$keey"} = $valu;
      } else {
        foreach my $attr ( $self->AttrNamz() ) { 
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
  if($self->{'_type'}) {
    $self->{'_titl'} = '' if($self->{'_titl'} eq 'Message:');
    if     ($self->{'_type'} =~ /^(help|info)$/) {
      if($self->{'_text'}->[0] =~ /^(\s*)(\w+)(\s*)(v\d+\.)(\d+\.\S{7})(\s*-\s*)((written|hacked|coded|made)?\s*by\s*)(.+)$/i) {
        my %mtch = ();
        $mtch{'1'} = $1 if(defined($1));
        $mtch{'2'} = $2 if(defined($2));
        $mtch{'3'} = $3 if(defined($3));
        $mtch{'4'} = $4 if(defined($4));
        $mtch{'5'} = $5 if(defined($5));
        $mtch{'6'} = $6 if(defined($6));
        $mtch{'7'} = $7 if(defined($7));
        $mtch{'9'} = $9 if(defined($9));
        $self->{'_colr'}->[0]  = ';';
        $self->{'_colr'}->[0] .= ' u' x length($mtch{'1'}) if(exists($mtch{'1'}));
        $self->{'_colr'}->[0] .= 'Gu' x length($mtch{'2'});
        $self->{'_colr'}->[0] .= ' u' x length($mtch{'3'}) if(exists($mtch{'3'}));
        $self->{'_colr'}->[0] .= 'Wu' . 'Yu' x (length($mtch{'4'}) - 2) . 'Wu';
        $self->{'_colr'}->[0] .=        'Cu' x (length($mtch{'5'}) - 8) . 'Wu';
        if($ptim) { $self->{'_colr'}->[0] .= '!' . ptcc() . ';'; }
        else      { $self->{'_colr'}->[0] .= 'Gu' x 7; }
        $self->{'_colr'}->[0] .= 'Uu' x length($mtch{'6'});
        $self->{'_colr'}->[0] .= 'Wu' x length($mtch{'7'});
        if     ($mtch{'9'} =~ /^([^<]+)<([^@]+)@([^.]+)\.([^>]+)>/) {
          $mtch{'91'} = $1;
          $mtch{'92'} = $2;
          $mtch{'93'} = $3;
          $mtch{'94'} = $4;
          $self->{'_colr'}->[0] .= 'Cu' x length($mtch{'91'}) . 'Wu';
          $self->{'_colr'}->[0] .= 'Gu' x length($mtch{'92'}) . 'Wu';
          $self->{'_colr'}->[0] .= 'Yu' x length($mtch{'93'}) . 'Wu';
          $self->{'_colr'}->[0] .= 'Cu' x length($mtch{'94'}) . 'Wu';
        } elsif($mtch{'9'} =~ /^([^@]+)@([^.]+)\.(\S+)/) {
          $mtch{'91'} = $1;
          $mtch{'92'} = $2;
          $mtch{'93'} = $3;
          $self->{'_colr'}->[0] .= 'Gu' x length($mtch{'91'}) . 'Wu';
          $self->{'_colr'}->[0] .= 'Yu' x length($mtch{'92'}) . 'Wu';
          $self->{'_colr'}->[0] .= 'Cu' x length($mtch{'93'});
        }
        if     ($self->{'_type'} eq 'help') {
          $self->{'_titl'} = "$mtch{'2'} Help Text:" unless($self->{'_titl'}); 
          $self->{'_colr'}->[1]  = ';Wu';
          $self->{'_text'}->[1]  = ' ' unless(length($self->{'_text'}->[1]));
        } elsif($self->{'_type'} eq 'info') {
          $self->{'_titl'} = "$mtch{'2'} Info Text:" unless($self->{'_titl'}); 
          $self->{'_colr'}->[1]  = ';Cu';
          $self->{'_text'}->[1]  = ' ' unless(length($self->{'_text'}->[1]));
        }
      }
    } elsif($self->{'_type'} =~ /^(butn|ckbx)$/) {
      $self->{'_flagpres'} = 0;
      $self->{'_flagcntr'} = 0;
      $self->{'_flagsdlk'} = 1;
      if     ($self->{'_type'} eq 'butn') {
        my $widt = 3;
        if($self->{'_titl'}) {
          $self->{'_btyp'} = 1 unless($self->{'_btyp'});
        } else {
          foreach(@{$self->{'_text'}}) {
            $widt = (length($_) + 2) if($widt < (length($_) + 2));
          }
          $self->{'_widt'} = $widt unless($self->{'_widt'});
        }
      } elsif($self->{'_type'} eq 'ckbx') {
        my $ndnt;
        $self->{'_onbx'} = '[X] - ' unless(exists($self->{'_onbx'}));
        unless(exists($self->{'_ofbx'})) {
          $self->{'_ofbx'} = $self->{'_onbx'};
          $self->{'_ofbx'} =~ s/^(.)./$1 /;
        }
        $ndnt = ' ' x length($self->{'_ofbx'});
        foreach(@{$self->{'_text'}}) {
          $_ =~ s/^/$ndnt/;
        }
        if($self->{'_stat'}) { 
          $self->{'_text'}->[0] =~ s/^$ndnt/$self->{'_onbx'}/;
        } else { 
          $self->{'_text'}->[0] =~ s/^$ndnt/$self->{'_ofbx'}/;
        }
        $self->{'_colr'}->[0] = 'cb$';
      }
    }
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
  $self->{'_bclr'} = $self->ExpandCC($self->{'_bclr'}) unless($self->{'_bclr'} =~ /\$$/);
  $self->{'_flagshrk'} = 0 if($self->{'_hite'} && $self->{'_widt'});
  $self->Updt(1);
  $self->{'_wind'} = newwin($self->{'_hite'}, $self->{'_widt'}, 
                            $self->{'_yoff'}, $self->{'_xoff'});
  unless(exists($self->{'_wind'}) && defined($self->{'_wind'})) {
    croak "!*EROR*! Curses::Simp::Mesg could not create new window with hite:$self->{'_hite'}, widt:$self->{'_widt'}, yoff:$self->{'_yoff'}, xoff:$self->{'_xoff'}!\n";
  }
  $self->FlagCVis(); # set cursor visibility to new object state
  # newwin doesn't auto draw so if there's init _text && autodraw is on...
  if($self->{'_text'} && @{$self->{'_text'}} && $self->{'_flagaudr'}) {
    $self->Draw();
  }
  if     ($self->{'_flagpres'}) { 
    if($self->{'_wait'}) { $char = $self->GetK($self->{'_wait'}); }
    else                 { $char = $self->GetK(-1); }
    $char = '#' . $char if($self->{'_kmod'}->{'KMOD_SHIFT'});
    $char = '^' . $char if($self->{'_kmod'}->{'KMOD_CTRL'});
    $char = '@' . $char if($self->{'_kmod'}->{'KMOD_ALT'});
  } elsif($self->{'_wait'}) { 
    $self->Wait($self->{'_wait'});
  }
  $self->{'_dndx'} = @DISPSTAK; # add object to display order stack
  push(@DISPSTAK, \$self); 
  if($self->{'_type'} =~ /^(butn|ckbx)$/) {
    return($self); # special types Button && CheckBox persist
  } else {
    $self->DelW();
    $main->ShokScrn(2);# redraw rest
    $main->FlagCVis(); # reset  cursor visibility to calling object state
    return($char);     # return character pressed to dismiss Mesg (if any)
  }
}

# Prmt() is a special Curses::Simp object constructor which creates a 
#   completely temporary Prompt window.
# If params are supplied, they must be hash key => value pairs.
sub Prmt {
  my $main = shift; my ($keey, $valu); my $char; my $tchr; my $data;
  my $self = bless({}, ref($main));    my $twid; my $indx;
  foreach my $attr ( $self->AttrNamz() ) { 
    $self->{$attr} = $self->DfltValu($attr); # init defaults
  }
  # special Prmt window defaults
  $self->{'_flagsdlk'} = 1;         # get SDLKeys
  $self->{'_flagmaxi'} = 0;         # not maximized 
  $self->{'_flagcvis'} = 1;         # show cursor
  $self->{'_flagbkgr'} = 1;         # use background colors
  $self->{'_flagedit'} = 1;         # editable
  $self->{'_flagescx'} = 0;         # Escape key eXits
  $self->{'_widt'} = getmaxx() - 4; # but almost full screen wide
  $self->{'_hite'} = 3;             #   && start 1 text line high
#  $self->{'_dref'} = \$data;        # default text data ref !exist at start
  $self->{'_dtxt'} =   '';
  $self->{'_text'} = [ ];
  $self->{'_dclr'} =   'Gu$';
  $self->{'_colr'} = [ $self->{'_dclr'} ];
  $self->{'_titl'} =   'Enter Text:';
  $self->{'_tclr'} =   'Cb$';
  $self->{'_hclr'} =   'Wg$';
  $self->{'_curs'} =       0; # special prompt cursor index
  $self->{'_sscr'} =       0; # special prompt side-scrolling index
  $self->{'_type'} =  'prmt'; # type can be set to special prompt types
                              #   like 'drop', 'cbls', or 'rdls'
  $self->{'_lndx'} =       0; # special line index for drop down types
  $self->{'_elmo'} =      ''; # special field to make this Prmt an ELeMent Of
  foreach(@KMODNAMZ) { $self->{'_kmod'}->{$_} = 0; }
  # there were init params with no colon (classname)
  while(@_) {
    ($keey, $valu) = (shift, shift);
    if(defined($valu)) {
      if     ($keey =~ /^(dref|dtxt|type|lndx|elmo|flagedit|flagescx)$/) {
        $self->{"_$keey"} = $valu;
      } else {
        foreach my $attr ( $self->AttrNamz() ) { 
          $self->{$attr} = $valu if($attr =~ /$keey/i);
        }
      }
    } else {
      $self->{'_dref'} = $keey;
    }
  }
  if     (exists($self->{'_dref'})) {
    $self->{'_dtxt'} = ${$self->{'_dref'}};
  } elsif(exists($self->{'_text'}) && @{$self->{'_text'}}) {
    $self->{'_dtxt'} = $self->{'_text'}->[0];
    for($indx = 1; $indx < @{$self->{'_text'}}; $indx++) {
      $self->{'_colr'}->[$indx] = $self->{'_dclr'} unless($self->{'_colr'}->[$indx]);
    }
  }
  $self->{'_data'}     = $self->{'_dtxt'};
  if($self->{'_type'} eq 'drop') {
    $self->{'_flagdrop'} = 1;
    $self->{'_flagdown'} = 0;
    $self->{'_flagcntr'} = 0;
    $self->{'_lndx'}     = 0 unless($self->{'_lndx'});
    $self->{'_hite'}     = 3;
    if($self->{'_widt'} == (getmaxx() - 4) && @{$self->{'_text'}}) {
      $self->{'_widt'}   = 3;
      foreach(@{$self->{'_text'}}) {
        $self->{'_widt'} = (length($_) + 6) if($self->{'_widt'} < (length($_) + 6));
      }
      $self->{'_dtxt'} = $self->{'_text'}->[$self->{'_lndx'}];
      $self->{'_data'} = $self->{'_dtxt'};
    }
    unshift(@{$self->{'_text'}}, $self->{'_data'});
  } else {
    $self->{'_text'}->[0] = $self->{'_data'} unless(@{$self->{'_text'}});
  }
  $self->{'_curs'} = length($self->{'_data'});
  if($self->{'_widt'} < length($self->{'_titl'}) + 4) {
    $self->{'_widt'} = length($self->{'_titl'}) + 4;
  }
  $twid = $self->{'_widt'} - 2;
  unless($self->{'_curs'} <= $twid) { # scrolling necessary off to the left
    substr($self->{'_text'}->[0], 0,  $twid, substr($self->{'_data'}, -$twid, $twid));
  }
  $self->{'_colr'}->[0] = $self->{'_hclr'} if($self->{'_curs'});
  $self->{'_ycrs'} = 0;
  $self->{'_xcrs'} = $self->{'_curs'};
  $self->{'_bclr'} = $self->ExpandCC($self->{'_bclr'}) unless($self->{'_bclr'} =~ /\$$/);
  $self->{'_flagshrk'} = 0 if($self->{'_hite'} && $self->{'_widt'});
  $self->Updt(1);
  $self->{'_wind'} = newwin($self->{'_hite'}, $self->{'_widt'}, 
                            $self->{'_yoff'}, $self->{'_xoff'});
  unless(exists($self->{'_wind'}) && defined($self->{'_wind'})) {
    croak "!*EROR*! Curses::Simp::Prmt could not create new window with hite:$self->{'_hite'}, widt:$self->{'_widt'}, yoff:$self->{'_yoff'}, xoff:$self->{'_xoff'}!\n";
  }
  $self->FlagCVis(); # set cursor visibility to new object state
  # newwin doesn't auto draw so if there's init _text && autodraw is on...
  if($self->{'_text'} && @{$self->{'_text'}} && $self->{'_flagaudr'}) {
    $self->Draw();
  }
  $self->{'_dndx'} = @DISPSTAK; # add object to display order stack
  push(@DISPSTAK, \$self); 
  if($self->{'_type'} =~ /^(drop)$/) {
    return($self); # $self must be given explicit focus via Focu()
  } else {
    $self->Focu(); # give Prompt focus (to handle GetK loops)
    ${$self->{'_dref'}} = $self->{'_data'} if(exists($self->{'_dref'}));
    $data = $self->{'_data'};
    $self->DelW();
    $main->ShokScrn(2);# redraw rest
    $main->FlagCVis(); # reset  cursor visibility to calling object state
    return($data);     # return updated text data
  }
}

# Focu() is a Curses::Simp method which give focus to special 
#   typed objects like CheckBoxes or DropDownMenus.
# Maybe later, it will change the border type / color of normal 
#   Simp object windows as they gain focus.
sub Focu {
  my $self = shift; return() unless(exists($self->{'_type'}));
  my $updt = shift || 0; my $char = -1; my $tchr;
  unless($updt) { 
    if     ($self->{'_type'} eq 'ckbx') {
      $self->Draw('colr' => [ 'Cb$' ]);
      $char = $self->GetK(-1);
      $self->Draw('colr' => [ 'cb$' ]);
      if($char =~ /^SDLK_(SPACE)$/) {        # checkbox toggle keys
        $self->{'_stat'} ^= 1;               # any other key loses focus
        $updt = 1;                           #   leaving ckbx state same
      }
    } elsif($self->{'_type'} =~ /^(prmt|drop)$/) { # big Prmt (drop)? focus
      my $cmov; my $done = 0;                      #   input handler
      $self->CVis(1);
      while(!$done) {
        $char = $self->GetK(-1);
        $tchr =  $char;
        $tchr =~ s/SDLK_//;
        $done = 1 if($tchr eq 'RETURN');
        if($self->{'_elmo'} eq 'brws' && $self->{'_flagdrop'} &&
           (($tchr eq 'F1') ||
            ($tchr =~ /^[bcfhu]$/ && $self->{'_kmod'}->{'KMOD_CTRL'}) ||
            ($tchr =~ /^(ESCAPE|SPACE|TILDE|BACKQUOTE)$/ &&  $self->{'_flagdown'}) ||
            ($tchr =~ /^(UP|DOWN|LEFT|RIGHT|j|k)$/       && !$self->{'_flagdown'}) ||
             $tchr =~ /^(TAB)$/)) {
          if($self->{'_flagdrop'} && !$self->{'_flagdown'}) {
            $self->{'_dtxt'} = $self->{'_data'};
            $self->{'_colr'}->[$self->{'_lndx'}] = $self->{'_hclr'};
          }
          $self->{'_echg'} = 1;
          $done = 1;
        } elsif($tchr eq 'TAB') {
          $tchr = '  ';
        }
        $tchr = uc($tchr) if($self->{'_kmod'}->{'KMOD_SHIFT'});
        if($self->{'_flagdrop'} && $self->{'_flagdown'}) { # DropIsDown
          if($char ne 'SDLK_TAB') {
            if     ($tchr =~ /^(RETURN|ESCAPE|SPACE|TILDE|BACKQUOTE)$/) { 
              $self->{'_flagdown'} = 0; # Close Drop down
              $self->{'_dtxt'} = $self->{'_text'}->[$self->{'_lndx'}];
              $self->{'_data'} = $self->{'_dtxt'};
              unshift(@{$self->{'_text'}}, $self->{'_data'});
              $self->{'_hite'} = 3;
              $self->{'_colr'}->[$self->{'_lndx'}] = $self->{'_dclr'};
              $self->{'_colr'}->[0]                = $self->{'_hclr'};
              $char = -1 if($tchr eq 'RETURN');
              $self->{'_echg'} = 1 if($self->{'_elmo'} eq 'brws');
            } elsif($tchr =~ /^(UP|LEFT|k)$/) { 
              if($self->{'_lndx'}) {
                $self->{'_lndx'}--;
                $self->{'_dtxt'} = $self->{'_text'}->[$self->{'_lndx'}    ];
                $self->{'_data'} = $self->{'_dtxt'};
                $self->{'_colr'}->[$self->{'_lndx'} + 1] = $self->{'_dclr'};
                $self->{'_colr'}->[$self->{'_lndx'}    ] = $self->{'_hclr'};
                $self->{'_curs'} = length($self->{'_data'});
                $self->{'_echg'} = 1 if($self->{'_elmo'} eq 'brws');
              }
            } elsif($tchr =~ /^(DOWN|RIGHT|j)$/) { 
              if($self->{'_lndx'} < (@{$self->{'_text'}} - 1)) {
                $self->{'_lndx'}++;
                $self->{'_dtxt'} = $self->{'_text'}->[$self->{'_lndx'}    ];
                $self->{'_data'} = $self->{'_dtxt'};
                $self->{'_colr'}->[$self->{'_lndx'} - 1] = $self->{'_dclr'};
                $self->{'_colr'}->[$self->{'_lndx'}    ] = $self->{'_hclr'};
                $self->{'_curs'} = length($self->{'_data'});
                $self->{'_echg'} = 1 if($self->{'_elmo'} eq 'brws');
              }
            }
            $self->{'_xcrs'} = $self->{'_curs'};
            $self->{'_ycrs'} = $self->{'_lndx'};
            $self->Draw();
          }
        } elsif(  $char ne 'SDLK_RETURN' && (!$self->{'_flagdrop'}       ||
                                            ( $self->{'_elmo'} eq 'brws' &&
                  $char ne 'SDLK_TAB'    &&   $self->{'_flagdrop'}       &&
                 ($char !~ /^SDLK_[bcfhu]$/ || !$self->{'_kmod'}->{'KMOD_CTRL'})))) {
          $cmov = 0; # mostly regular Prmt stuff
          if     ($self->{'_flagdrop'} && ($tchr =~ /^(TILDE|BACKQUOTE)$/ ||
                  $self->{'_colr'}->[0] eq $self->{'_hclr'} &&
                                           $tchr eq 'SPACE')) { 
            $self->{'_flagdown'} = 1; # drop Down
            shift(@{$self->{'_text'}});
            $self->{'_hite'} = @{$self->{'_text'}} + 2;
            $self->{'_dtxt'} = $self->{'_text'}->[$self->{'_lndx'}];
            $self->{'_data'} = $self->{'_dtxt'};
            $self->{'_colr'}->[0] = $self->{'_dclr'};
            $self->{'_curs'} = length($self->{'_data'});
            $self->{'_sscr'} = 0;
          } elsif($tchr eq 'UP'  ) { 
            if($self->{'_flagdrop'} && !$self->{'_flagdown'}) {
              if($self->{'_lndx'}) {
                $self->{'_lndx'}--;
                $self->{'_dtxt'} = $self->{'_text'}->[$self->{'_lndx'} + 1];
                $self->{'_data'} = $self->{'_dtxt'};
                $self->{'_text'}->[0] = $self->{'_data'};
                $self->{'_colr'}->[0] = $self->{'_hclr'};
                $self->{'_curs'} = length($self->{'_data'});
                $self->{'_echg'} = 1 if($self->{'_elmo'} eq 'brws');
              }
            } elsif($self->{'_flagedit'} && $self->{'_curs'}) { # uppercase
              my $temp = substr($self->{'_data'}, $self->{'_curs'}, 1);
                         substr($self->{'_data'}, $self->{'_curs'}, 1, uc($temp)); 
            }
          } elsif($tchr eq 'DOWN') { 
            if($self->{'_flagdrop'} && !$self->{'_flagdown'}) {
              if($self->{'_lndx'} < (@{$self->{'_text'}} - 2)) {
                $self->{'_lndx'}++;
                $self->{'_dtxt'} = $self->{'_text'}->[$self->{'_lndx'} + 1];
                $self->{'_data'} = $self->{'_dtxt'};
                $self->{'_text'}->[0] = $self->{'_data'};
                $self->{'_colr'}->[0] = $self->{'_hclr'};
                $self->{'_curs'} = length($self->{'_data'});
                $self->{'_echg'} = 1 if($self->{'_elmo'} eq 'brws');
              }
            } elsif($self->{'_flagedit'} && $self->{'_curs'}) { # lowercase
              my $temp = substr($self->{'_data'}, $self->{'_curs'}, 1);
                         substr($self->{'_data'}, $self->{'_curs'}, 1, lc($temp)); 
            }
          } elsif($self->{'_flagedit'}) {
            if     ($tchr eq 'LEFT' ) { # move cursor left
              if($self->{'_curs'}) {
                $self->{'_curs'}--;
                $self->{'_sscr'}-- if($self->{'_sscr'});
              }
              $cmov = 1;
            } elsif($tchr eq 'RIGHT') { # move cursor right
              if($self->{'_curs'} < length($self->{'_data'})) {
                $self->{'_curs'}++;
              }
              $cmov = 1;
            } elsif($tchr eq 'HOME' ) { # move cursor to beginning
              $self->{'_curs'} = 0;
              $self->{'_sscr'} = 0 if($self->{'_sscr'});
              $cmov = 1;
            } elsif($tchr eq 'END'  ) { # move cursor to end
              $self->{'_curs'} = length($self->{'_data'});
              if(length($self->{'_data'}) < $self->{'_widt'} - 2) {
                $self->{'_sscr'} = (length($self->{'_data'}) - $self->{'_widt'} - 2);
              }
              $cmov = 1;
            } elsif($tchr eq 'INSERT') {
              $self->FlagInsr('togl');
              if($self->FlagInsr) { $self->{'_titl'} =~ s/\[O\]$//; }
              else                { $self->{'_titl'} .= '[O]'; 
                unless($self->Widt() > length($self->Titl()) + 4) {
                  $self->Widt(length($self->Titl()) + 4);
                  $self->Draw(); # was $main
                }
              }
            } elsif($tchr eq 'BACKSPACE') {
              if($self->{'_curs'}) {
                substr($self->{'_data'}, --$self->{'_curs'}, 1, '');
                $self->{'_sscr'}-- if($self->{'_sscr'});
              }
            } elsif($tchr eq 'DELETE') {
              if($self->{'_curs'} < length($self->{'_data'})) {
                substr($self->{'_data'},   $self->{'_curs'}, 1, '');
                $self->{'_sscr'}-- if($self->{'_sscr'});
              }
            } elsif($tchr eq 'ESCAPE') {
              if($self->{'_flagescx'}) {
                $self->{'_data'} = '';
                $self->{'_curs'} = 0;
              } else {
                $self->{'_colr'}->[0] = $self->{'_hclr'};
                $self->{'_data'} = $self->{'_dtxt'};
                $self->{'_curs'} = length($self->{'_data'});
                $self->{'_sscr'} = 0;
              }
            } else {
              foreach(keys(%SDLKCHRM)) {
                $tchr = $_ if($tchr eq $SDLKCHRM{$_});
              }
              if($tchr ne 'F1') {
                if($self->{'_colr'}->[0] eq $self->{'_hclr'}) {
                  $self->{'_data'} = $tchr;
                  $self->{'_curs'} = length($self->{'_data'});
                } else {
                  if     ($self->{'_curs'} == length($self->{'_data'})) { 
                    $self->{'_data'} .= $tchr; 
                  } elsif($self->FlagInsr()) {
                    substr($self->{'_data'}, $self->{'_curs'},            0,$tchr);
                  } else { 
                    substr($self->{'_data'}, $self->{'_curs'},length($tchr),$tchr);
                  }
                  $self->{'_curs'} += length($tchr);
                }
              }
            }
            while((($self->{'_curs'} - $self->{'_sscr'}) >= ($self->{'_widt'} - 2)) ||
                  (($self->{'_curs'} - $self->{'_sscr'}) >= ($self->{'_widt'} - 5) && $self->{'_flagdrop'} && !$self->{'_flagdown'})) {
              $self->{'_sscr'}++;
            }
            if( $self->{'_colr'}->[0] eq $self->{'_hclr'} &&
               ($self->{'_data'}      ne $self->{'_dtxt'} || $cmov)) {
              $self->{'_colr'}->[0] = $self->{'_dclr'};
            }
          } else { # test !editable keys to jump in drop etc.
          }
          if($self->{'_flagdrop'} && $self->{'_flagdown'}) {
            $self->{'_xcrs'} = $self->{'_curs'};
            $self->{'_ycrs'} = $self->{'_lndx'};
            $self->{'_colr'}->[$self->{'_lndx'}] = $self->{'_hclr'};
          } else {
            $self->{'_xcrs'} = ($self->{'_curs'} - $self->{'_sscr'});
            $self->{'_text'}->[0] = $self->{'_data'};
            if($self->{'_sscr'}) {
              substr($self->{'_text'}->[0], 0, $self->{'_sscr'} + 3, '...');
            }
          }
          $self->Draw();
        }
      }
    }
  }
  if($updt) { 
    if     ($self->{'_type'} eq 'ckbx') {
      if($self->{'_stat'}) {
        substr($self->{'_text'}->[0], 0, length($self->{'_ofbx'}), '');
        $self->{'_text'}->[0] =~ s/^/$self->{'_onbx'}/;
      } else { 
        substr($self->{'_text'}->[0], 0, length($self->{'_onbx'}), '');
        $self->{'_text'}->[0] =~ s/^/$self->{'_ofbx'}/;
      }
    }
    $self->Draw();
  }
  return($char);
}

sub BildBlox { # a sub used by CPik to construct color blocks in @text && @colr
  my $self = shift; 
  @{$self->{'_text'}} = ( );
  @{$self->{'_colr'}} = ( );
  if     ($self->{'_styl'} eq 'barz') {
    if($self->{'_flagbakg'}) {
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
    if($self->{'_flagbakg'}) {
      for(my $rowe = 0; $rowe < 7; $rowe++) {
        push(@{$self->{'_text'}},  '  ');
        push(@{$self->{'_colr'}}, '!  ');
        for(my $cndx = 0; $cndx < @telc; $cndx++) {
          if     ($rowe < 5) {
            $self->{'_text'}->[-1] .= $self->{'_bchr'} x 8;
            $self->{'_colr'}->[-1] .= $telc[$cndx]     x 8;
          } elsif($rowe < 6) {
            $self->{'_text'}->[-1] .= '  ' . hex($cndx) . 
                                      '  ' . $telc[$cndx] . '  ';
            if($cndx == $self->{'_hndx'}) {
              $self->{'_colr'}->[-1] .= ';bwbwBwbwbwbwbwbw!';
            } else {
              $self->{'_colr'}->[-1] .= '  w  W  ';
            }
          }
        }
        $self->{'_text'}->[-1] .= ' ';
        $self->{'_colr'}->[-1] .= ' ';
      }
    }
    if($self->{'_flagforg'}) {
      for(my $rowe = 0; $rowe < 7; $rowe++) {
        push(@{$self->{'_text'}},  '  ');
        push(@{$self->{'_colr'}}, '!  ');
        for(my $cndx = 0; $cndx < @telc; $cndx++) {
          if     ($rowe < 5) {
            $self->{'_text'}->[-1] .= $self->{'_bchr'} x 8;
            $self->{'_colr'}->[-1] .= uc($telc[$cndx]) x 8;
          } elsif($rowe < 6) {
            if(hex($cndx+@telc) eq 'B' || hex($cndx+@telc) eq 'C') {
              $self->{'_text'}->[-1] .= '  ' . '!' . 
                                        '  ' . uc($telc[$cndx]) . '  ';
            } else {
              $self->{'_text'}->[-1] .= '  ' . hex($cndx+@telc) . 
                                        '  ' . uc($telc[$cndx]) . '  ';
            }
            if($cndx == ($self->{'_hndx'} - 8)) {
              $self->{'_colr'}->[-1] .= ';bwbwBwbwbwbwbwbw!';
            } else {
              $self->{'_colr'}->[-1] .= '  w  W  ';
            }
          }
        }
        $self->{'_text'}->[-1] .= ' ';
        $self->{'_colr'}->[-1] .= ' ';
      }
    }
    if($self->{'_hndx'} < 8) {
      $self->Move( 5, (( $self->{'_hndx'}      * 8) + 2));
    } else {
      $self->Move(12, ((($self->{'_hndx'} - 8) * 8) + 2));
    }
  } elsif($self->{'_styl'} eq 'squr') {
    if($self->{'_flagbakg'}) {
      for(my $rowe = 0; $rowe < 5; $rowe++) {
        push(@{$self->{'_text'}},  '  ');
        push(@{$self->{'_colr'}}, '!  ');
        for(my $cndx = 0; $cndx < int(@telc / 2); $cndx++) {
          if     ($rowe < 3) {
            $self->{'_text'}->[-1] .= $self->{'_bchr'} x 16;
            $self->{'_colr'}->[-1] .= $telc[$cndx]     x 16;
          } elsif($rowe < 4) {
            $self->{'_text'}->[-1] .= '     ' . hex($cndx) . 
                                      '    '  . $telc[$cndx] . '     ';
            if($cndx == $self->{'_hndx'}) {
              $self->{'_colr'}->[-1] .= ';bwbwbwbwbwBwbwbwbwbwbwbwbwbwbwbw!';
            } else {
              $self->{'_colr'}->[-1] .= '     w    W     ';
            }
          }
        }
        $self->{'_text'}->[-1] .= ' ';
        $self->{'_colr'}->[-1] .= ' ';
      }
      for(my $rowe = 0; $rowe < 5; $rowe++) {
        push(@{$self->{'_text'}},  '  ');
        push(@{$self->{'_colr'}}, '!  ');
        for(my $cndx = int(@telc / 2); $cndx < @telc; $cndx++) {
          if     ($rowe < 3) {
            $self->{'_text'}->[-1] .= $self->{'_bchr'} x 16;
            $self->{'_colr'}->[-1] .= $telc[$cndx]     x 16;
          } elsif($rowe < 4) {
            $self->{'_text'}->[-1] .= '     ' . hex($cndx) . 
                                      '    '  . $telc[$cndx] . '     ';
            if($cndx == $self->{'_hndx'}) {
              $self->{'_colr'}->[-1] .= ';bwbwbwbwbwBwbwbwbwbwbwbwbwbwbwbw!';
            } else {
              $self->{'_colr'}->[-1] .= '     w    W     ';
            }
          }
        }
        $self->{'_text'}->[-1] .= ' ';
        $self->{'_colr'}->[-1] .= ' ';
      }
    }
    if($self->{'_flagforg'}) {
      for(my $rowe = 0; $rowe < 5; $rowe++) {
        push(@{$self->{'_text'}},  '  ');
        push(@{$self->{'_colr'}}, '!  ');
        for(my $cndx = 0; $cndx < int(@telc / 2); $cndx++) {
          if     ($rowe < 3) {
            $self->{'_text'}->[-1] .= $self->{'_bchr'} x 16;
            $self->{'_colr'}->[-1] .= uc($telc[$cndx]) x 16;
          } elsif($rowe < 4) {
            if(hex($cndx+@telc) eq 'B' || hex($cndx+@telc) eq 'C') {
              $self->{'_text'}->[-1] .= '     ' . '!' . 
                                        '    '  . uc($telc[$cndx]) . '     ';
            } else {
              $self->{'_text'}->[-1] .= '     ' . hex($cndx+@telc) . 
                                        '    '  . uc($telc[$cndx]) . '     ';
            }
            if($cndx == ($self->{'_hndx'} - 8)) {
              $self->{'_colr'}->[-1] .= ';bwbwbwbwbwBwbwbwbwbwbwbwbwbwbwbw!';
            } else {
              $self->{'_colr'}->[-1] .= '     w    W     ';
            }
          }
        }
        $self->{'_text'}->[-1] .= ' ';
        $self->{'_colr'}->[-1] .= ' ';
      }
      for(my $rowe = 0; $rowe < 5; $rowe++) {
        push(@{$self->{'_text'}},  '  ');
        push(@{$self->{'_colr'}}, '!  ');
        for(my $cndx = int(@telc / 2); $cndx < @telc; $cndx++) {
          if     ($rowe < 3) {
            $self->{'_text'}->[-1] .= $self->{'_bchr'} x 16;
            $self->{'_colr'}->[-1] .= uc($telc[$cndx]) x 16;
          } elsif($rowe < 4) {
            if(hex($cndx+@telc) eq 'B' || hex($cndx+@telc) eq 'C') {
              $self->{'_text'}->[-1] .= '     ' . '!' . 
                                        '    '  . uc($telc[$cndx]) . '     ';
            } else {
              $self->{'_text'}->[-1] .= '     ' . hex($cndx+@telc) . 
                                        '    '  . uc($telc[$cndx]) . '     ';
            }
            if($cndx == ($self->{'_hndx'} - 8)) {
              $self->{'_colr'}->[-1] .= ';bwbwbwbwbwBwbwbwbwbwbwbwbwbwbwbw!';
            } else {
              $self->{'_colr'}->[-1] .= '     w    W     ';
            }
          }
        }
        $self->{'_text'}->[-1] .= ' ';
        $self->{'_colr'}->[-1] .= ' ';
      }
    }
    if     ($self->{'_hndx'} <  4) {
      $self->Move( 3, (( $self->{'_hndx'}       * 16) + 2));
    } elsif($self->{'_hndx'} <  8) {
      $self->Move( 8, ((($self->{'_hndx'} -  4) * 16) + 2));
    } elsif($self->{'_hndx'} < 12) {
      $self->Move(13, ((($self->{'_hndx'} -  8) * 16) + 2));
    } else {
      $self->Move(18, ((($self->{'_hndx'} - 12) * 16) + 2));
    }
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
#    '��������������������������������','��������������������������������',
  my @bchz = ( 'X', '@', '#', '$', '�', '�', '�', '�'); # block chars
  my @styz = ( 'barz', 'blox', 'squr' ); # color display styles
  foreach my $attr ( $self->AttrNamz() ) { 
    $self->{$attr} = $self->DfltValu($attr); # init defaults
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
  $self->{'_dclr'} =   'Gu$';
  $self->{'_colr'} = [ $self->{'_dclr'} ];
  $self->{'_titl'} =   'Color Picker:';
  $self->{'_tclr'} =   'RpOgYcGuUp  Gu$';
  $self->{'_flagpres'} = 1;
  $self->{'_pres'} =   'Pick A Color... (Arrows+Enter, Letter, or Number)';
  $self->{'_pclr'} =   'Yb$'; # Pick message Color
  $self->{'_hclr'} =   'Wg$'; # highlight color
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
        foreach my $attr ( $self->AttrNamz() ) { 
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
  $self->{'_bclr'} = $self->ExpandCC($self->{'_bclr'}) unless($self->{'_bclr'} =~ /\$$/);
  $self->{'_flagshrk'} = 0 if($self->{'_hite'} && $self->{'_widt'});
  $self->Updt(1);
  $self->{'_wind'} = newwin($self->{'_hite'}, $self->{'_widt'}, 
                            $self->{'_yoff'}, $self->{'_xoff'});
  unless(exists($self->{'_wind'}) && defined($self->{'_wind'})) {
    croak "!*EROR*! Curses::Simp::CPik could not create new window with hite:$self->{'_hite'}, widt:$self->{'_widt'}, yoff:$self->{'_yoff'}, xoff:$self->{'_xoff'}!\n";
  }
  $self->FlagCVis(); # set cursor visibility to new object state
  $self->BildBlox(); # build color block data into @text && @colr && Draw()
  $self->Move($self->{'_hndx'}, 0);
  while(!defined($char) || !$done) {
    $char = $self->GetK(-1);
    if($char =~ /^SDLK_(RETURN|[0-9A-FRGYUPW])$/i) { # gonna be done
      $char =~ s/^SDLK_//;
      if     ($char =~ /^[BRGYUPCW]$/i) {
        $pick = $char;
        $pick = uc($pick) if($self->{'_kmod'}->{'KMOD_SHIFT'});
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
      if     ($tchr eq 'PAGEUP') { # Page keys cycle Block Char
        $self->{'_bndx'}++;
        $self->{'_bndx'} = 0 if($self->{'_bndx'} == @bchz);
      } elsif($tchr eq 'PAGEDOWN') { 
        $self->{'_bndx'} = @bchz unless($self->{'_bndx'});
        $self->{'_bndx'}--;
      } elsif($tchr eq 'END') {    # Home/End cycles layout Style
        $self->{'_sndx'}++;
        $self->{'_sndx'} = 0 if($self->{'_sndx'} == @styz);
      } elsif($tchr eq 'HOME') { 
        $self->{'_sndx'} = @styz unless($self->{'_sndx'});
        $self->{'_sndx'}--;
      }
      $self->{'_bchr'} = $bchz[$self->{'_bndx'}];
      $self->{'_styl'} = $styz[$self->{'_sndx'}];
      if     ($self->{'_styl'} eq 'barz') {
        if     ($tchr eq 'LEFT'  or $tchr eq 'UP') { 
          $self->{'_hndx'} = 16 unless($self->{'_hndx'});
          $self->{'_hndx'}--;
        } elsif($tchr eq 'RIGHT' or $tchr eq 'DOWN') { 
          $self->{'_hndx'}++;
          $self->{'_hndx'} = 0 if($self->{'_hndx'} == 16);
        }
      } elsif($self->{'_styl'} eq 'blox') {
        if     ($tchr eq 'DOWN'  or $tchr eq 'UP') { 
          $self->{'_hndx'} +=  8;
          $self->{'_hndx'} -= 16 if($self->{'_hndx'} >= 16);
        } elsif($tchr eq 'LEFT') {
          $self->{'_hndx'} = 16 unless($self->{'_hndx'});
          $self->{'_hndx'}--;
        } elsif($tchr eq 'RIGHT') {
          $self->{'_hndx'}++;
          $self->{'_hndx'} = 0 if($self->{'_hndx'} == 16);
        }
      } elsif($self->{'_styl'} eq 'squr') {
        if     ($tchr eq 'UP') { 
          $self->{'_hndx'} -=  4;
          $self->{'_hndx'} += 16 if($self->{'_hndx'} < 0);
        } elsif($tchr eq 'DOWN') {
          $self->{'_hndx'} +=  4;
          $self->{'_hndx'} -= 16 if($self->{'_hndx'} >= 16);
        } elsif($tchr eq 'LEFT') {
          $self->{'_hndx'} = 16 unless($self->{'_hndx'});
          $self->{'_hndx'}--;
        } elsif($tchr eq 'RIGHT') {
          $self->{'_hndx'}++;
          $self->{'_hndx'} = 0 if($self->{'_hndx'} == 16);
        }
      }
      $self->BildBlox();
    }
  }
  # delete the CPik window, redraw rest
  delwin($self->{'_wind'});
  $main->ShokScrn(2);
  $main->FlagCVis(); # reset  cursor visibility to calling object state
  return($pick);     # return picked color code
}

sub BrwsHelp { # BrwsHelp() just prints a help text message for Brws()
  my $self = shift;
     $self->Mesg('type' => 'help', 
                 'titl' => 'File / Directory Browser Help: (F1)',
"This Browser dialog exists to make it easy to choose a file (or directory).

You can <TAB> between elements.  Ctrl-I and TAB are interpreted as the same
key by Curses so either one can be pressed to cycle forward through Browse
elements.  Ctrl-U cycles backwards.  Ctrl-H toggles hidden files.
Ctrl-F toggles file highlighting.  Ctrl-C shows the configuration screen.

All drop downs can be navigated with the arrow keys, typed directly into,
or have their drop state toggled with the tilde '~' or backtick '`' keys.

  The '=C' button is supposed to look like a wrench for configuration.
    Pressing enter on it will bring up the Browse configuration screen.
  The 'md' button allows you to make a new directory in the current path.
  The 'Path:' drop down lets you specify which directory to apply 'Filter:'
    to when populating the main view box in the center.
  The '..' button moves path up one directory.
  The '??' button brings up this help text.
  The main view box can be navigated with the arrow keys and a file can be
    chosen with Enter.
  The 'Filename:' drop down lets you type the filename specificially or 
    pick from recent choices.
  The button following 'Filename:' will likely be labeled 'Open' or 
    'Save As' for the purpose of the Browsing.  This button accepts
    whatever name is in the 'Filename:' drop down.
  The 'Filter:' drop down lets you specify what globbing should happen in
    'Path:' to populate the main view.
  The 'Cancel' button quits without making a selection.
");
}

#  The '=C' button is supposed to look like a wrench for configuration.
#    Pressing enter on it will bring up the Browse configuration screen.
#  The 'md' button allows you to make a new directory in the current path.
#  The 'Path:' drop down lets you specify which directory to apply 'Filter:'
#    to when populating the main view box in the center.
#  The '..' button moves path up one directory.
#  The '??' button brings up this help text.
#  The main view box can be navigated with the arrow keys and a file can be
#    chosen with Enter.
#  The 'Filename:' drop down lets you type the filename specificially or 
#    pick from recent choices.
#  The button following 'Filename:' will likely be labeled 'Open' or 
#    'Save As' for the purpose of the Browsing.  This button accepts
#    whatever name is in the 'Filename:' drop down.
#  The 'Filter:' drop down lets you specify what globbing should happen in
#    'Path:' to populate the main view.
#  The 'Cancel' button quits without making a selection.
sub BrwsCnfg { # BrwsCnfg() brings up a dialog of checkboxes for elements
  my $self = shift; my $char; my $cndx = 0;
  my %cdsc = ('_cnfg' => '=C - Configuration       Button',
              '_mkdr' => 'md - Make Directory      Button',
              '_path' => 'Path:                 Drop Down',
              '_cdup' => '.. - Change Directory Up Button',
              '_help' => '?? - Help                Button',
              '_view' => 'Main View Area                 ',
              '_file' => 'Filename:             Drop Down',
              '_open' => 'Open/SaveAs/etc.         Button',
              '_filt' => 'Filter:               Drop Down',
              '_cncl' => 'Cancel                   Button',
             );
  my $cfgb = $self->Mesg('type' => 'butn', 'titl'=>'Browser Configuration:',
    'hite' => $self->{'_hite'}, 'widt' => $self->{'_widt'}, 
    'yoff' => $self->{'_yoff'}, 'xoff' => $self->{'_xoff'}, 'flagsdlk' => 1,
    'mesg' => " Tab or Arrows go between fields, Space toggles, Enter accepts all.",
  );
  for(my $indx = 0; $indx < @{$self->{'_elem'}}; $indx++) { # make ckboxes
    $cfgb->{'_cbob'}->{ $self->{'_elem'}->[$indx] } = $cfgb->Mesg(
      'type' => 'ckbx', 
      'yoff' => ($self->{'_yoff'} + ($indx * 2) + 4), 
      'xoff' => ($self->{'_xoff'} + 4),
      'stat' => $self->{'_eflz'}->{ $self->{'_elem'}->[$indx] },
      "$cdsc{$self->{'_elem'}->[$indx]} Visible"
    );
  }
  while(!defined($char) || $char ne 'SDLK_RETURN') {
    $char = $cfgb->{'_cbob'}->{ $self->{'_elem'}->[ $cndx ] }->Focu();
    if     ($char =~ /^SDLK_(TAB|DOWN|j)$/) {
      $cndx++;
      $cndx = 0 if($cndx >= @{$self->{'_elem'}});
    } elsif($char =~ /^SDLK_(UP|k)$/ ||
           ($char eq 'SDLK_u' && $cfgb->{'_cbob'}->{ $self->{'_elem'}->[ $cndx ] }->{'_kmod'}->{'KMOD_CTRL'})) {
      $cndx = @{$self->{'_elem'}} unless($cndx);
      $cndx--;
    }
  }
  for(my $indx = 0; $indx < @{$self->{'_elem'}}; $indx++) { # make ckboxes
    $self->{'_eflz'}->{ $self->{'_elem'}->[$indx] } = 
      $cfgb->{'_cbob'}->{ $self->{'_elem'}->[$indx] }->{'_stat'};
    $cfgb->{'_cbob'}->{ $self->{'_elem'}->[$indx] }->DelW();
  }
  $cfgb->DelW();
  $self->BildBrws(1);
  return();
}

sub BrwsCdUp { # BrwsCdUp() just moves the browse path up one directory
  my $self = shift;
  if($self->{'_path'} =~ s/^(.*\/).+\/?$/$1/) {
    $self->{'_bobj'}->{'_path'}->{'_text'}->[ 
      ($self->{'_bobj'}->{'_path'}->{'_lndx'} + 1) ] = $self->{'_path'};
    $self->{'_bobj'}->{'_path'}->{'_dtxt'}           = $self->{'_path'};
    $self->{'_bobj'}->{'_path'}->{'_data'}           = $self->{'_path'};
    $self->{'_bobj'}->{'_path'}->{'_text'}->[0]      = $self->{'_path'};
    $self->{'_bobj'}->{'_path'}->{'_curs'}    = length($self->{'_path'});
    $self->{'_bobj'}->{'_path'}->{'_xcrs'}    = length($self->{'_path'});
    $self->{'_bobj'}->{'_path'}->{'_echg'} = 1;
  }
}

# BildBrws() is a utility of Brws() which creates or updates all the 
#   elements of a Browse Window.
#  Brws() bare-bones dialog should look something like:
#  +------------------------{Open File:}-------------------------------+
#  |+--------------------{cwd: /home/pip }----------------------------+|
#  ||../                                                              ||
#  ||.LS_COLORS                                                       ||
#  ||.ssh/                                                            ||
#  ||.zshrc *Highlighted line*                                        ||
#  ||dvl/                                                             ||
#  |+-----------------------------------------------------------------+|
#  |+-----------------{Filename:}--------------+--++========++--------+|
#  ||.zshrc                                    |\/||  Open  || Cancel ||
#  |+------------------------------------------+--++========++--------+|
#  +-------------------------------------------------------------------+
#    or Brws() with frills
#  +---------------------------{Open File:}----------------------------+
#  |+--++--++-----------------------{Path:}----------------+--++--++--+|
#  ||=C||md||/home/pip                                     |\/||..||??||
#  |+--++--++----------------------------------------------+--++--++--+|
#  |+-----------------------------------------------------------------+|
#  ||../                                                              ||
#  ||.LS_COLORS                                                       ||
#  ||.ssh/                                                            ||
#  ||.zshrc *Highlighted line*                                        ||
#  ||dvl/                                                             ||
#  |+-----------------------------------------------------------------+|
#  |+----------------------{Filename:}-------------------+--++========+|
#  ||.zshrc                                              |\/||  Open  ||
#  |+----------------------------------------------------+--++========+|
#  |+-----------------------{Filter:}--------------------+--++--------+|
#  ||* (All Files)                                       |\/|| Cancel ||
#  |+----------------------------------------------------+--++--------+|
#  +-------------------------------------------------------------------+
#  heh... this one is complicated enough that it should probably be 
#    Curses::Simp::Brws.pm instead ... too bad =)
#  =C is configure wrench for new dialog of all toggles (&& hotkeys)
#  md is mkdir dialog
#  \/ drop down bar to show recent or common options
#  .. is `cd ..`
#  ?? is help / F1
#  ==== box is highlighted (Enter selects)
#    Ultimately, Brws() should be able to handle easy Browsing for 
#      Files or Directories for any Open/SaveAs/etc. purposes
sub BildBrws {
  my $self = shift; my $updt = shift || 0; my $indx;
  $self->CVis(); # set cursor visibility to main Brws object state
  $self->Draw();
  for($indx = 0; $indx < @{$self->{'_elem'}}; $indx++) {
    if(!$self->{'_eflz'}->{$self->{'_elem'}->[$self->{'_endx'}]}) {
      $self->{'_endx'}++;
      $self->{'_endx'} = 0 if($self->{'_endx'} == @{$self->{'_elem'}});
    }
  } # this for && below if make sure a visible element is indexed
  if(!$self->{'_eflz'}->{$self->{'_elem'}->[$self->{'_endx'}]}) {
    $self->{'_eflz'}->{$self->{'_elem'}->[$self->{'_endx'}]} = 1;
  }
  for($indx = 0; $indx < @{$self->{'_elem'}}; $indx++) {
    my $elem = $self->{'_elem'}->[$indx];
    if(!$updt || $self->{'_eflz'}->{$elem}) {
      my ($yoff, $xoff) = ($self->{'_yoff'} + 1, $self->{'_xoff'} + 1);
      my ($widt, $hite) = ($self->{'_widt'} - 2, $self->{'_hite'} - 2);
      my $type = 'butn'; my $titl = ''; my $btyp = 1; my $bclr = 'wb$';
      my $scrl = 0;
      my $mesg; my @text = (); my @colr = ( 'wb$' );
      if     ($elem eq '_cnfg') { # do specific settings
        $hite = 3; $widt = 4; 
        $mesg = '=C';
      } elsif($elem eq '_mkdr') {
        $hite = 3; $widt = 4; 
        $xoff += 4 if($self->{'_eflz'}->{'_cnfg'});
        $mesg = 'md';
      } elsif($elem eq '_path') {
        $hite = 3;
        if($self->{'_eflz'}->{'_cnfg'}) { $xoff += 4; $widt -= 4; }
        if($self->{'_eflz'}->{'_mkdr'}) { $xoff += 4; $widt -= 4; }
        if($self->{'_eflz'}->{'_cdup'}) {             $widt -= 4; }
        if($self->{'_eflz'}->{'_help'}) {             $widt -= 4; }
        $type = 'drop';
        $titl = 'Path:';
        if(exists(  $self->{'_bobj'}->{'_path'})) {
          @text = @{$self->{'_bobj'}->{'_path'}->{'_text'}};
          @colr = @{$self->{'_bobj'}->{'_path'}->{'_colr'}};
        } else {
          @text = ( $self->{'_path'}, '/home/', '/tmp/' );
        }
      } elsif($elem eq '_cdup') {
        $hite = 3; $widt = 4; 
        $xoff  = $self->{'_widt'} - 3;
        $xoff -= 4 if($self->{'_eflz'}->{'_help'});
        $mesg = '..';
      } elsif($elem eq '_help') {
        $hite = 3; $widt = 4; 
        $xoff  = $self->{'_widt'} - 3;
        $mesg = '??';
      } elsif($elem eq '_view') {
        my $dtdt = 0;
        if($self->{'_eflz'}->{'_cnfg'} ||
           $self->{'_eflz'}->{'_mkdr'} ||
           $self->{'_eflz'}->{'_path'} ||
           $self->{'_eflz'}->{'_cdup'} ||
           $self->{'_eflz'}->{'_help'}) { $yoff += 3; $hite -= 3; }
        if($self->{'_eflz'}->{'_file'} ||
           $self->{'_eflz'}->{'_open'} ||
           $self->{'_eflz'}->{'_cncl'}) {             $hite -= 3; }
        if($self->{'_eflz'}->{'_filt'}) {             $hite -= 3; }
        if(exists(  $self->{'_bobj'}->{'_view'})) {
          @text = @{$self->{'_bobj'}->{'_view'}->{'_text'}};
          @colr = @{$self->{'_bobj'}->{'_view'}->{'_colr'}};
          if($self->{'_bobj'}->{'_view'}->{'_echg'}) {
            $self->{'_choi'} = $text[($self->{'_vndx'} - $self->{'_vscr'})];
            $self->{'_bobj'}->{'_file'}->{'_curs'} = length($self->{'_choi'});
            $self->{'_bobj'}->{'_file'}->{'_xcrs'} = length($self->{'_choi'});
          }
        }
        if(!$updt || $self->{'_bobj'}->{'_mkdr'}->{'_echg'} ||
                     $self->{'_bobj'}->{'_path'}->{'_echg'} ||
                     $self->{'_bobj'}->{'_view'}->{'_echg'} ||
                     $self->{'_bobj'}->{'_filt'}->{'_echg'}) {
          @text = (); @colr = ();
          unless($self->{'_choi'}) {
            $self->{'_vndx'} = 0; 
            $self->{'_choi'} = '';
          }
          unless($self->{'_flaghide'}) {
            foreach(glob($self->{'_path'} . '.' . $self->{'_filt'})) {
              $_ .= '/' if(-d $_);
              s/^$self->{'_path'}//;
              $dtdt = 1 if($_ eq '../');
              unless($_ eq './') { # || /\.swp$/)  # omit . && .swp
                push(@text, $_); 
                if(!$self->{'_choi'}) {
                  if(-f $_) { $self->{'_choi'} = $_; }
                  else      { $self->{'_vndx'}++;    }
                }
              }
            }
          }
          foreach(glob($self->{'_path'} . $self->{'_filt'})) {
            $_ .= '/' if(-d $_);
            s/^$self->{'_path'}//;
            unless($_ eq './' || ($_ eq '../' && $dtdt)) { # omit . or 2nd ..
              push(@text, $_);
              if(!$self->{'_choi'}) {
                if(-f $_) { $self->{'_choi'} = $_; }
                else      { $self->{'_vndx'}++;    }
              }
            }
          }
          $self->{'_vndx'} = (@text - 1) if($self->{'_vndx'} > (@text - 1));
          if($self->{'_flagflhi'}) {
            my $lclr;
            foreach(@text) {
              my $fulf = $self->{'_path'} . $_;
                                  $lclr = $GLBL{'TESTMAPP'}->{'NORMAL'};
              if     (-d $fulf) { $lclr = $GLBL{'TESTMAPP'}->{'DIR'};
              } elsif(-l $fulf) { $lclr = $GLBL{'TESTMAPP'}->{'LINK'};
              } elsif(-p $fulf) { $lclr = $GLBL{'TESTMAPP'}->{'FIFO'};
              } elsif(-S $fulf) { $lclr = $GLBL{'TESTMAPP'}->{'SOCK'};
              } elsif(-b $fulf) { $lclr = $GLBL{'TESTMAPP'}->{'BLK'};
              } elsif(-c $fulf) { $lclr = $GLBL{'TESTMAPP'}->{'CHR'};
              #} elsif(-O $fulf) { $lclr = $GLBL{'TESTMAPP'}->{'ORPHAN'}; # don't know test
              } elsif(-x $fulf) { $lclr = $GLBL{'TESTMAPP'}->{'EXEC'};
              } elsif(-f $fulf) { $lclr = $GLBL{'TESTMAPP'}->{'FILE'};
                foreach my $regx (keys(%{$GLBL{'DFLTMAPP'}})) { # test defaults
                  $lclr = $GLBL{'DFLTMAPP'}->{$regx} if($fulf =~ /$regx/i);
                }
                foreach my $regx (keys(%{$GLBL{'OVERMAPP'}})) { # test overridz
                  $lclr = $GLBL{'OVERMAPP'}->{$regx} if($fulf =~ /$regx/i);
                }
              }
              $lclr .= '$';
              push(@colr, $lclr);
            }
          } else { # don't highlight different files
            push(@colr, 'wb$') foreach(@text);
          }
          if($self->{'_vndx'} != -1) {
            if($self->{'_flagbgho'}) { # BackGround Highlight Only
              substr($colr[$self->{'_vndx'}], 1, 1, 
                substr(    $self->{'_hclr'},  1, 1));
            } else {                   # copy full highlight code to view index
              substr($colr[$self->{'_vndx'}], 0, 2, 
                substr(    $self->{'_hclr'},  0, 2));
            }
          }
          if($self->{'_vndx'} > ($hite - 3)) { # handle view scrolling
            my $vndx = $self->{'_vndx'};
            while($vndx-- > ($hite - 3)) {
              push(@text, shift(@text)); shift(@colr);
            }
            $self->{'_vscr'} = ($self->{'_vndx'} - ($hite - 3));
          } else {
            $self->{'_vscr'} = 0;
          }
        }
        $scrl = 1 if(@text > ($hite - 2));
      } elsif($elem eq '_file') {
        $hite = 3;
        $yoff = $self->{'_hite'} - 2;
        if   ($self->{'_eflz'}->{'_filt'}) { $yoff -= 3;              }
        elsif($self->{'_eflz'}->{'_cncl'}) {             $widt -= 12; }
        if   ($self->{'_eflz'}->{'_open'}) {             $widt -= 12; }
        $type = 'drop';
        $titl = 'Filename:';
        if(exists(  $self->{'_bobj'}->{'_file'})) {
          @text = @{$self->{'_bobj'}->{'_file'}->{'_text'}};
          @colr = @{$self->{'_bobj'}->{'_file'}->{'_colr'}};
        }
        if($updt || !@text) {
          $self->{'_bobj'}->{'_file'}->{'_data'} =        $self->{'_choi'};
          @text                                  =      ( $self->{'_choi'} );
        }
      } elsif($elem eq '_open') {
        $hite = 3; $widt = 12;
        $yoff = $self->{'_hite'} -  2;
        $xoff = $self->{'_widt'} - 11;
        if   ($self->{'_eflz'}->{'_filt'}) { $yoff -= 3;              }
        elsif($self->{'_eflz'}->{'_cncl'}) {             $xoff -= 12; }
        $btyp = 4;
        $mesg  = ' ' x int((10 - length($self->{'_acpt'})) / 2);
        $mesg .= $self->{'_acpt'}; # $mesg = '   Open   ';
        $mesg .= ' ' x (10 - length($mesg));
      } elsif($elem eq '_filt') {
        $hite = 3;
        $yoff = $self->{'_hite'} - 2;
        if($self->{'_eflz'}->{'_cncl'}) {             $widt -= 12; }
        $type = 'drop';
        $titl = 'Filter:';
        if(exists(  $self->{'_bobj'}->{'_filt'})) {
          @text = @{$self->{'_bobj'}->{'_filt'}->{'_text'}};
          @colr = @{$self->{'_bobj'}->{'_filt'}->{'_colr'}};
        } else {
          @text = ( $self->{'_filt'}, '.*', '*.pl' );
        }
      } elsif($elem eq '_cncl') {
        $hite = 3; $widt = 12;
        $yoff = $self->{'_hite'} -  2;
        $xoff = $self->{'_widt'} - 11;
        $mesg = '  Cancel  ';
      }
      if($self->{'_endx'} == $indx) {
        $btyp =  4;
        $bclr = 'Cu$';
      }
      @text = split(/\n/, $mesg) if($mesg);
      if($updt && $self->{'_bobj'}->{$elem}) { # just update existing elements
        $self->{'_bobj'}->{$elem}->Draw(
          'hite' => $hite, 'widt' => $widt, 'yoff' => $yoff, 'xoff' => $xoff,
                                            'btyp' => $btyp, 'bclr' => $bclr,
          'text' => [ @text ], 'colr' => [ @colr ],
          'flagscrl' => $scrl,
        );
      } else {
        if     ($type eq 'butn') { # create respective elements
          $self->{'_bobj'}->{$elem} = $self->Mesg( 
            'hite' => $hite, 'widt' => $widt, 'yoff' => $yoff, 'xoff' => $xoff,
            'type' => $type, 'titl' => $titl, 'btyp' => $btyp, 'bclr' => $bclr,
            'text' => [ @text ], 'colr' => [ @colr ], 'elmo' => 'brws',
            'flagscrl' => $scrl,
          );
        } elsif($type eq 'drop') {
          $self->{'_bobj'}->{$elem} = $self->Prmt(
            'hite' => $hite, 'widt' => $widt, 'yoff' => $yoff, 'xoff' => $xoff,
            'type' => $type, 'titl' => $titl, 'btyp' => $btyp, 'bclr' => $bclr,
            'text' => [ @text ], 'colr' => [ @colr ], 'elmo' => 'brws',
            'flagscrl' => $scrl,
          );
        }
      }
    } else {
      $self->{'_eflz'}->{$elem} = undef;
    }
  }
  # reset object changed flags
  $self->{'_bobj'}->{$_}->{'_echg'} = 0 foreach(@{$self->{'_elem'}});
}

# Brws() is a special Curses::Simp object constructor which creates a 
#   file or directory Browse Window.
# If params are supplied, they must be hash key => value pairs.
sub Brws {
  my $main = shift; my ($keey, $valu); my $char; my $tchr; my $choi = '';
  my $self = bless({}, ref($main));    my $indx; my $done = 0;
  foreach my $attr ( $main->AttrNamz() ) { 
    $self->{$attr} = $main->DfltValu($attr); # init defaults
  }
  # special Brws window defaults
  $self->{'_flagsdlk'} = 1;         # get SDLKeys
  $self->{'_flagmaxi'} = 0;         # not maximized 
  $self->{'_flagcvis'} = 0;         # don't show cursor
  $self->{'_flagview'} = 0;         # show 0=short (1=detailed) view
  $self->{'_flaghide'} = 0;         # don't hide .files by default
  $self->{'_flagquik'} = 0;         # don't show quick access panel
  $self->{'_flagsepd'} = 0;         # don't show separate directory pane
  $self->{'_flagflhi'} = 1;         # HIghlight FiLes in browser view
  $self->{'_flagbgho'} = 1;         # BackGround Highlight Only in view
  $self->{'_widt'} = getmaxx() - 4; # but almost full screen wide
  $self->{'_hite'} = getmaxy() - 4; #                     && high
  $self->{'_text'} = [ ' ' ];
  $self->{'_dclr'} =   'Gu$';
  $self->{'_colr'} = [ $self->{'_dclr'} ];
  $self->{'_elem'} = [ '_cnfg', '_mkdr', '_path', '_cdup', '_help', # elements
                       '_view', '_file', '_open', '_filt', '_cncl' ];
  $self->{'_eflz'} =     { }; $self->{'_eflz'}->{$_} = 1 foreach(@{$self->{'_elem'}}); # initialize element visibility flags
# BareBones settings below
#$self->{'_eflz'}->{$_} = 0 foreach('_cnfg','_mkdr','_cdup','_help','_filt');
  $self->{'_bobj'} =     { }; # Browse Objects (elements)
  $self->{'_brwt'} =  'File'; # Browse type ('File' or 'Dir')
  $self->{'_acpt'} =  'Open'; # acceptance button text like 'Open' or 'SaveAs'
  $self->{'_path'} =   `pwd`; # default path is the current working dir
  chomp($self->{'_path'});
  $self->{'_path'} =~ s/\/*$/\//;
  $self->{'_btyp'} =     1;   # border type
  $self->{'_titl'} =    '';   # gets set from Browse type below
  $self->{'_tclr'} =   'Gu$';
  $self->{'_hclr'} =   'Wg$'; # Highlight CoLoR
  $self->{'_hndx'} =     0;   # Highlight iNDeX
  $self->{'_endx'} =     6;   # Element iNDeX
  $self->{'_vndx'} =     0;   # View iNDeX (choice line)
  $self->{'_vscr'} =     0;   # View SCRolling (to get choice line in view)
  $self->{'_choi'} =    '';   # choice (the chosen file or dir name)
  $self->{'_filt'} =   '*';   # glob filter
  foreach(@KMODNAMZ) { $self->{'_kmod'}->{$_} = 0; }
  # there were init params with no colon (classname)
  while(@_) {
    ($keey, $valu) = (shift, shift);
    if(defined($valu)) {
      if     ($keey =~ /^_*(....)?....$/) {
        $keey =~ s/^_*//;
        $self->{"_$keey"} = $valu;
      } else {
        foreach my $attr ( $self->AttrNamz() ) { 
          $self->{$attr} = $valu if($attr =~ /$keey/i);
        }
      }
    } else {
      $self->{'_brwt'} = $keey;
    }
  }
  $self->{'_titl'} = "Open $self->{'_brwt'}:" unless($self->{'_titl'});
  if($self->{'_widt'} < length($self->{'_titl'}) + 4) {
    $self->{'_widt'} = length($self->{'_titl'}) + 4;
  }
  $self->{'_ycrs'} = $self->{'_hndx'};
  $self->{'_xcrs'} = 0;
  $self->{'_bclr'} = $self->ExpandCC($self->{'_bclr'}) unless($self->{'_bclr'} =~ /\$$/);
  $self->{'_flagshrk'} = 0 if($self->{'_hite'} && $self->{'_widt'});
  $self->Updt(1);
  $self->{'_wind'} = newwin($self->{'_hite'}, $self->{'_widt'}, 
                            $self->{'_yoff'}, $self->{'_xoff'});
  unless(exists($self->{'_wind'}) && defined($self->{'_wind'})) {
    croak "!*EROR*! Curses::Simp::Brws could not create new window with hite:$self->{'_hite'}, widt:$self->{'_widt'}, yoff:$self->{'_yoff'}, xoff:$self->{'_xoff'}!\n";
  }
  $self->{'_dndx'} = @DISPSTAK; # add object to display order stack
  push(@DISPSTAK, \$self); 
  $self->BildBrws(); # create all element objects
  while(!defined($char) || !$done) {
    my $elem = $self->{'_elem'}->[$self->{'_endx'}];
    my $sobj = $self->{'_bobj'}->{$elem};
    if($sobj->{'_type'} eq 'drop') { 
      $char = $sobj->Focu(); %{$self->{'_kmod'}} = %{$sobj->{'_kmod'}};
      $sobj->CVis(0); 
    } else {
      $char = $self->GetK(-1); 
    }
    if   ($elem eq '_path') { $self->{'_path'} = $sobj->{'_data'}; 
                              $self->{'_path'} =~ s/\/*$/\//;      }
    elsif($elem eq '_file') { $self->{'_choi'} = $sobj->{'_data'}; }
    elsif($elem eq '_filt') { $self->{'_filt'} = $sobj->{'_data'}; }
    if     ($char eq 'SDLK_RETURN') {
      if     ($elem eq '_cnfg') {
        $self->BrwsCnfg();
      } elsif($elem eq '_mkdr') {
        my $mdir = 'New_Dir';
        $self->Prmt('titl'     => "Make Directory: $self->{'_path'} ", 
                    'flagescx' => 1, \$mdir);
        if(length($mdir)) {
          $mdir = $self->{'_path'} .  $mdir unless($mdir =~ /^\//);
          if(-d $mdir) { 
            $self->Mesg('titl' => '!EROR! - Make Directory',
                                  "Directory: \"$mdir\" already exists!");
          } else {
            mkdir("$mdir", 0700);
            if(-d $mdir) { 
              $self->{'_bobj'}->{'_mkdr'}->{'_echg'} = 1;
            } else {
              $self->Mesg('titl' => '!EROR! - Make Directory',
                                    "Make directory: \"$mdir\" failed!");
            }
          }
        }
      } elsif($elem eq '_path') {
        $self->{'_bobj'}->{'_path'}->{'_echg'} = 1;
        $self->{'_endx'} = 6; # return from path jumps to file bar
      } elsif($elem eq '_cdup') {
        $self->BrwsCdUp();
      } elsif($elem eq '_help') {
        $self->BrwsHelp();
      } elsif($elem eq '_filt') {
        $self->{'_bobj'}->{'_filt'}->{'_echg'} = 1;
        $self->{'_endx'} = 5; # return from filt jumps to view box
      } else {
        $done = 1;
      }
    }
    $self->BildBrws(1);
    if     ( $char eq 'SDLK_TAB' ||                     # Ctrl-I == Tab
            ($char =~ /^SDLK_(RIGHT|DOWN)$/ && $elem =~ /^_(cnfg|mkdr|cdup|help|open|cncl)$/)) {
      $sobj->{'_bclr'} = 'wb$';
      $sobj->{'_btyp'} = $self->{'_btyp'} unless($elem eq '_open');
      $sobj->Draw();
      $self->{'_endx'}++;
      $self->{'_endx'} = 0 if($self->{'_endx'} == @{$self->{'_elem'}});
      while(!$self->{'_eflz'}->{$self->{'_elem'}->[$self->{'_endx'}]}) {
        $self->{'_endx'}++;
        $self->{'_endx'} = 0 if($self->{'_endx'} == @{$self->{'_elem'}});
      }
      $elem = $self->{'_elem'}->[$self->{'_endx'}];
      $sobj = $self->{'_bobj'}->{$elem};
      $sobj->{'_bclr'} = 'Cu$';
      $sobj->{'_btyp'} = 4;
      if($elem eq '_file') {
        $self->{'_choi'} =        $sobj->{'_data'};
        $sobj->{'_curs'} = length($self->{'_choi'});
        $sobj->{'_xcrs'} = length($self->{'_choi'});
      }
      $sobj->Draw();
    } elsif( $char eq 'SDLK_u' && $self->{'_kmod'}->{'KMOD_CTRL'} || # Ctrl-U ~ Shift-Tab
            ($char =~ /^SDLK_(LEFT|UP)$/ && $elem =~ /^_(cnfg|mkdr|cdup|help|open|cncl)$/)) {
      $sobj->{'_bclr'} = 'wb$';
      $sobj->{'_btyp'} = $self->{'_btyp'} unless($elem eq '_open');
      $sobj->Draw();
      $self->{'_endx'} = @{$self->{'_elem'}} unless($self->{'_endx'});
      $self->{'_endx'}--;
      while(!$self->{'_eflz'}->{$self->{'_elem'}->[$self->{'_endx'}]}) {
        $self->{'_endx'} = @{$self->{'_elem'}} unless($self->{'_endx'});
        $self->{'_endx'}--;
      }
      $elem = $self->{'_elem'}->[$self->{'_endx'}];
      $sobj = $self->{'_bobj'}->{$elem};
      $sobj->{'_bclr'} = 'Cu$';
      $sobj->{'_btyp'} = 4;
      if($elem eq '_file') {
        $self->{'_choi'} =        $sobj->{'_data'};
        $sobj->{'_curs'} = length($self->{'_choi'});
        $sobj->{'_xcrs'} = length($self->{'_choi'});
      }
      $sobj->Draw();
    } elsif($char eq 'SDLK_b' && $self->{'_kmod'}->{'KMOD_CTRL'}) { # Ctrl-B toggle view background only highlighting
      $self->{'_flagbgho'} ^= 1;
      $self->{'_bobj'}->{'_filt'}->{'_echg'} = 1;
      $self->BildBrws(1);
    } elsif($char eq 'SDLK_c' && $self->{'_kmod'}->{'KMOD_CTRL'}) { # Ctrl-C bring up configuration dialog
        $self->BrwsCnfg();
    } elsif($char eq 'SDLK_f' && $self->{'_kmod'}->{'KMOD_CTRL'}) { # Ctrl-F toggle view file highlighting
      $self->{'_flagflhi'} ^= 1;
      $self->{'_bobj'}->{'_filt'}->{'_echg'} = 1;
      $self->BildBrws(1);
    } elsif($char eq 'SDLK_h' && $self->{'_kmod'}->{'KMOD_CTRL'}) { # Ctrl-H toggle hidden file globbing
      $self->{'_flaghide'} ^= 1;
      $self->{'_bobj'}->{'_filt'}->{'_echg'} = 1;
      $self->BildBrws(1);
    } elsif($char eq 'SDLK_t' && $self->{'_kmod'}->{'KMOD_CTRL'}) { # Ctrl-T chg btyps
      $self->{'_btyp'}++;
      $self->{'_btyp'} = 0 if($self->{'_btyp'} > @BORDSETS);
      $self->Draw();
      foreach(@{$self->{'_elem'}}) { 
        $self->{'_bobj'}->{$_}->{'_btyp'} = $self->{'_btyp'} if($_ ne $elem); 
        $self->{'_bobj'}->{$_}->Draw(); 
      }
    } elsif($char eq 'SDLK_F1') {
      $self->BrwsHelp();
    } elsif($elem eq '_view') {
      if     ($char eq 'SDLK_UP') {
        if($self->{'_vndx'}) {
          $self->{'_vndx'}--;
          $self->{'_choi'} = $self->{'_bobj'}->{'_view'}->{'_text'}->[ $self->{'_vndx'} ];
          $self->{'_bobj'}->{'_view'}->{'_echg'} = 1;
          $self->BildBrws(1);
        }
      } elsif($char eq 'SDLK_DOWN') {
        if($self->{'_vndx'} < (@{$self->{'_bobj'}->{'_view'}->{'_text'}} - 1)){
          $self->{'_vndx'}++;
          $self->{'_choi'} = $self->{'_bobj'}->{'_view'}->{'_text'}->[ $self->{'_vndx'} ];
          $self->{'_bobj'}->{'_view'}->{'_echg'} = 1;
          $self->BildBrws(1);
        }
      } elsif($char eq 'SDLK_PAGEUP') {
        $self->{'_vndx'} -= ($self->{'_bobj'}->{'_view'}->{'_hite'} - 3);
        $self->{'_vndx'} = 0 if($self->{'_vndx'} < 0);
        $self->{'_choi'} = $self->{'_bobj'}->{'_view'}->{'_text'}->[ $self->{'_vndx'} ];
        $self->{'_bobj'}->{'_view'}->{'_echg'} = 1;
        $self->BildBrws(1);
      } elsif($char eq 'SDLK_PAGEDOWN') {
        $self->{'_vndx'} += ($self->{'_bobj'}->{'_view'}->{'_hite'} - 3);
        $self->{'_vndx'} = (@{$self->{'_bobj'}->{'_view'}->{'_text'}} - 1)
          if($self->{'_vndx'} >= @{$self->{'_bobj'}->{'_view'}->{'_text'}});
        $self->{'_choi'} = $self->{'_bobj'}->{'_view'}->{'_text'}->[ $self->{'_vndx'} ];
        $self->{'_bobj'}->{'_view'}->{'_echg'} = 1;
        $self->BildBrws(1);
      } elsif($char eq 'SDLK_LEFT') {
        $self->BrwsCdUp();
        $self->BildBrws(1);
      } elsif($char eq 'SDLK_RIGHT') {
        $choi = $self->{'_path'} . $self->{'_choi'};
        if(-d $choi) {
          $choi =~ s/^(.*\/)([^\/]+\/)\.\.\/$/$1/; # handle cd..
          $self->{'_path'} = $choi;
          $self->{'_bobj'}->{'_path'}->{'_text'}->[ 
            ($self->{'_bobj'}->{'_path'}->{'_lndx'} + 1) ] = $self->{'_path'};
          $self->{'_bobj'}->{'_path'}->{'_dtxt'}           = $self->{'_path'};
          $self->{'_bobj'}->{'_path'}->{'_data'}           = $self->{'_path'};
          $self->{'_bobj'}->{'_path'}->{'_text'}->[0]      = $self->{'_path'};
          $self->{'_bobj'}->{'_path'}->{'_curs'}    = length($self->{'_path'});
          $self->{'_bobj'}->{'_path'}->{'_xcrs'}    = length($self->{'_path'});
          $self->{'_bobj'}->{'_path'}->{'_echg'} = 1;
          $self->BildBrws(1);
        }
      }
    }
    if($done) { # clean up && save local choice so all objects can be destroyed
      if   ($elem eq '_cncl') { $choi = '-1'; }
      else                    { $choi = $self->{'_path'} . $self->{'_choi'};}
      if($self->{'_brwt'} eq 'File' && -d $choi) {
        $choi =~ s/^(.*\/)([^\/]+\/)\.\.\/$/$1/; # handle cd..
        $self->{'_path'} = $choi;
        $self->{'_bobj'}->{'_path'}->{'_text'}->[ 
          ($self->{'_bobj'}->{'_path'}->{'_lndx'} + 1) ] = $self->{'_path'};
        $self->{'_bobj'}->{'_path'}->{'_dtxt'}           = $self->{'_path'};
        $self->{'_bobj'}->{'_path'}->{'_data'}           = $self->{'_path'};
        $self->{'_bobj'}->{'_path'}->{'_text'}->[0]      = $self->{'_path'};
        $self->{'_bobj'}->{'_path'}->{'_curs'}    = length($self->{'_path'});
        $self->{'_bobj'}->{'_path'}->{'_xcrs'}    = length($self->{'_path'});
        $self->{'_bobj'}->{'_path'}->{'_echg'} = 1;
        $self->BildBrws(1);
        $done = 0; # don't accept directory when choosing file
      }
    }
  }
  $self->DelW();      # Delete Brws Window && all element windows
  $main->ShokScrn(2); # redraw all old stuff
  $main->FlagCVis();  # reset  cursor visibility to calling object state
  return($choi);      # return choice (file or dir name)
}

sub DESTROY { 
  my $self = shift || return(); my $dndx = $self->{'_dndx'};
  my $shok = 1; 
     $shok = 0 if(exists($self->{'_type'}) && length($self->{'_type'}));
  if($self->{'_wind'}) {
    delwin($self->{'_wind'});
    for(++$dndx; $dndx < @DISPSTAK; $dndx++) { 
      if($DISPSTAK[$dndx] && exists(${$DISPSTAK[$dndx]}->{'_dndx'})) {
        ${$DISPSTAK[$dndx]}->{'_dndx'}--; 
      }
    }
    splice(@DISPSTAK, $self->{'_dndx'}, 1); #remove deleted from displaystack
    $self->ShokScrn(2) if($shok);
  }
}

# VERBOSE METHOD NAME ALIASES
*AttributeNames        = \&AttrNamz;
*DefaultValues         = \&DfltValu;
*MakeMethods           = \&MkMethdz;
*InitializeColorPair   = \&InitPair;
*PrintBorderCharacter  = \&BordChar;
*ConvertAnsiColorCode  = \&CnvAnsCC;
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
*FocusWindow           = \&Focu;
*ColorPickWindow       = \&CPik;
*BrowseWindow          = \&Brws;
*DeleteWindow          = \&DelW;
*DelW                  = \&DESTROY;

127;

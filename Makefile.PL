use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
#   the contents of the Makefile that is written.
WriteMakefile(
  'NAME'         => 'Curses::Simp',
  'VERSION'      => '1.2.A7DDCh3',
  'ABSTRACT'     => 'Curses Not Quite Simple',
  'AUTHOR'       => 'Pip Stuart <Pip@CPAN.Org>',
  'EXE_FILES'    => [ 
                    ],
  'PREREQ_PM'    => {
    'Curses'                         => 0,
    'Math::BaseCnv'                  => 0,
    'Test'                           => 0,
    'Test::Pod'                      => 0,
    'Test::Pod::Coverage'            => 0,
    'Tie::Array'                     => 0,
    'Time::Frame'                    => 0,
    'Time::PT'                       => 0,
  }, # Module::Name => 1.1,
  'dist'         => { 'COMPRESS' => 'gzip', 'SUFFIX' => 'tgz' },
);
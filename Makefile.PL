use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# # the contents of the Makefile that is written.
WriteMakefile(
  'NAME'         => 'Curses::Simp',
  'VERSION'      => '1.0.41O4516',
  'ABSTRACT'     => 'a Simple Curses wrapper for easy application development',
  'AUTHOR'       => 'Pip Stuart <Pip@CPAN.Org>',
  'EXE_FILES'    => [ 
                      'bin/ptok/ptok',
                      'bin/qbix/qbix',
                    ],
  'PREREQ_PM'    => {
    'Math::BaseCnv'                  => 0,
    'Time::Frame'                    => 0,
    'Curses'                         => 0,
  }, # Module::Name => 1.1,
  'dist'         => { 'COMPRESS' => 'gzip', 'SUFFIX' => 'tgz' },
);
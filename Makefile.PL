use inc::Module::Install;
name 'Hash-RubyLike';
license 'Perl';
all_from 'lib/Hash/RubyLike.pm';

requires $_ for (qw/ /);

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

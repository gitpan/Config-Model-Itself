#
# This file is part of Config-Model-Itself
#
# This software is Copyright (c) 2011 by Dominique Dumont.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
#    Copyright (c) 2007-2010 Dominique Dumont.
#
#    This file is part of Config-Model-Itself.
#
#    Config-Model is free software; you can redistribute it and/or
#    modify it under the terms of the GNU Lesser Public License as
#    published by the Free Software Foundation; either version 2.1 of
#    the License, or (at your option) any later version.
#
#    Config-Model is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#    Lesser Public License for more details.
#
#    You should have received a copy of the GNU Lesser Public License
#    along with Config-Model; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
#    02110-1301 USA

use Module::Build;
use Data::Dumper ;

use warnings FATAL => qw(all) ;
use strict ;

my @version_info = @ARGV ? (dist_version => $ARGV[0]) : () ;

my $build = Module::Build->new
  (
   module_name   => 'Config::Model::Itself',
   license       => 'lgpl',
   dist_author   => "Dominique Dumont (ddumont at cpan dot org)",
   dist_abstract => "Graphical model editor for Config::Model",
   @version_info,

  'build_requires' => {
    'Module::Build' => '0.3601',
    'Test::Differences' => '0',
    'Test::More' => '0'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'requires' => {
    'Config::Model' => '1.263',
    'Config::Model::TkUI' => '1.210',
    'Log::Log4perl' => '0',
    'Pod::POM' => '0',
    'Tk' => '0',
    'YAML::Any' => '0'
  },

   script_files  => [ 'config-model-edit' ],
   add_to_cleanup => [qw/wr_test/] ,
  );


$build->add_build_element('pl');
$build->create_build_script;

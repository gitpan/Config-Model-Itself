# 
# This file is part of Config-Model-Itself
# 
# This software is Copyright (c) 2010 by Dominique Dumont.
# 
# This is free software, licensed under:
# 
#   The GNU Lesser General Public License, Version 2.1, February 1999
# 
# -*- cperl -*-
# $Author: ddumont $
# $Date: 2008-03-07 13:42:08 $
# $Name: not supported by cvs2svn $
# $Revision: 1.2 $


# this file is used by test script

[

  [
   name => 'MasterModel::X_base_class2',
   element => [
	       X => { type => 'leaf',
		      value_type => 'enum',
		      choice     => [qw/Av Bv Cv/]
		    },
	      ],
   class_description => 'rather dummy class to check include',
  ],

  [
   name => 'MasterModel::X_base_class',
   include => 'MasterModel::X_base_class2',
  ],

] ;

# do not put 1; at the end or Model-> load will not work

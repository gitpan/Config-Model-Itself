# $Author: ddumont $
# $Date: 2008-05-18 19:14:14 +0200 (Sun, 18 May 2008) $
# $Revision: 673 $

#    Copyright (c) 2007-2008 Dominique Dumont.
#
#    This file is part of Config-Model-Itself.
#
#    Config-Model-Itself is free software; you can redistribute it
#    and/or modify it under the terms of the GNU Lesser Public License
#    as published by the Free Software Foundation; either version 2.1
#    of the License, or (at your option) any later version.
#
#    Config-Model-Itself is distributed in the hope that it will be
#    useful, but WITHOUT ANY WARRANTY; without even the implied
#    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Lesser Public License for more details.
#
#    You should have received a copy of the GNU Lesser Public License
#    along with Config-Model-Itself; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA

[
  [
   name => "Itself::WarpableElement",

   include => 'Itself::CommonElement' ,

   'element' 
   => [

      [qw/follow_keys_from allow_keys_from/] 
       => { type => 'leaf',
	    level => 'hidden',
	    value_type => 'uniline' ,
	    warp => {  follow => { 't' => '?type'},
		       'rules'
		       => [ '$t eq "hash"' 
			    => {
				level => 'normal',
			       }
			  ]
		    }
	  },

      [qw/ordered/] 
       => { type => 'leaf',
	    level => 'hidden',
	    value_type => 'boolean' ,
	    warp => {  follow => { 't' => '?type' },
		       'rules'
		       => [ '$t eq "hash"'
			    => {
				level => 'normal',
			       }
			  ]
		    }
	  },


      [qw/default_keys auto_create allow_keys/] 
       => { type => 'list',
	    level => 'hidden',
	    cargo => { type => 'leaf', value_type => 'string'} ,
	    warp => {  follow => { 't' => '?type' },
		       'rules'
		       => [ '$t eq "hash" or $t eq "list"'
			    => {
				level => 'normal',
			       }
			  ]
		    }
	  },

      [qw/default_with_init/] 
       => { type => 'hash',
	    level => 'hidden',
	    index_type => 'string',
	    cargo => { type => 'leaf', value_type => 'string'} ,
	    warp => {  follow => { 't' => '?type' },
		       'rules'
		       => [ '$t eq "hash"'
			    => {
				level => 'normal',
			       }
			  ]
		    }
	  },

       'max_nb'
       => { type => 'leaf',
	    level => 'hidden',
	    value_type => 'integer',
	    warp => { follow => {
				 'type'  => '?type',
				},
		     'rules'
		      => [ '$type eq "hash"'
			   => {
			       level => 'normal',
			      }
			 ]
		    }
	  },



       [qw/replace help/]
       => {
	   type => 'hash',
	   index_type => 'string',
	   level => 'hidden',
	   warp => {  follow => { 't' => '?type' },
		      'rules'
		      => [ '$t eq "leaf" or $t eq "check_list"'
			   => {
			       level => 'normal',
			      }
			 ]
		   },
	   # TBD this could be a reference if we restrict replace to
	   # enum value...
	   cargo => { type => 'leaf', value_type => 'string' } ,
	  },
      ],

   'description' 
   => [
       value_type => 'specify the type of a leaf element.',
       default => 'Specify default value. This default value will be written in the configuration data',
       built_in => 'Another way to specify a default value. But this default value is considered as "built_in" the application and is not written in the configuration data (unless modified)',
       follow_keys_from => 'this hash will contain the same keys as the hash pointed by the path string',
       allow_keys_from =>'this hash will allow keys from the keys of the hash pointed by the path string', 
       ordered => 'keep track of the order of the elements of this hash',
       default_keys => 'default keys hashes.',
       auto_create => 'always create a set of keys',
       allow_keys => 'specify a set of allowed keys',
       default_with_init => 'specify a set of keys to create and initialization on some elements . E.g. \' foo => "X=Av Y=Bv", bar => "Y=Av Z=Cz"\' ',
       convert => 'When stored, the value will be converted to uppercase (uc) or lowercase (lc).',
       choice => 'Specify the possible values',
       help => 'Specify help string specific to possible values. E.g for "light" value, you could write " red => \'stop\', green => \'walk\' ',
       replace => 'Used for enum to substitute one value with another. This parameter must be used to enable user to upgrade a configuration with obsolete values. The old value is the key of the hash, the new one is the value of the hash',
      ],
  ],

];

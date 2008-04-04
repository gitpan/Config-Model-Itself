# $Author: ddumont $
# $Date: 2008-04-03 19:12:21 +0200 (Thu, 03 Apr 2008) $
# $Revision: 583 $

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
   name => "Itself::CargoElement",

   include => 'Itself::WarpableCargoElement' ,
   include_after => 'compute',

   'element' 
   => [
       'value_type' 
       => { type => 'leaf',
	    level => 'hidden',
	    value_type => 'enum',
	    'warp'
	    => { follow => { ct => '- - cargo_type' },
		 'rules'
		 => [ '$ct eq "leaf"' 
		      => {
			  choice => [qw/boolean enum integer reference
					number uniline string/],
			  level => 'normal',
			  mandatory => 1,
			 }
		    ]
	       }
	  },

       # node element (may be within a hash or list)

       # all but warped_node
       'warp' 
       => { type => 'warped_node' , # ?
	    level => 'hidden',
	    follow => { elt_type => '- - cargo_type' } ,
	    rules  => [
		       '$elt_type ne "node"' =>
		       {
			level => 'normal',
			config_class_name => 'Itself::WarpValue',
		       }
		      ] ,
	    description => "change the properties (i.e. default value or its value_type) dynamically according to the value of another Value object locate elsewhere in the configuration tree. "
	  },

       # warped_node: warp parameter for warped_node. They must be
       # warped out when type is not a warped_node
       'follow' => 
       => {
	   type => 'hash',
	   cargo_type => 'leaf',
	   index_type => 'string',
	   level      => 'hidden' ,
	   'warp'
	   => { follow => '- - cargo_type',
		'rules' => { 'warped_node' => {level => 'normal',},}
	      },
	   cargo_args => { value_type => 'uniline' },
	   description => "Specifies the path to the value elements that drive the change of this node. Each key of the has is a variable name used in the 'rules' parameter. The value of the hash is a path in the configuration tree",
	  },

       'rules' => {
                   type => 'hash',
		   ordered => 1,
		   level      => 'hidden' ,
		   cargo_type => 'node',
		   index_type => 'string',
		   warp => { follow => '- - cargo_type',
			     'rules'
			     => { 'warped_node' 
				  => {
				      config_class_name => 'Itself::WarpableCargoElement' ,
				      level => 'normal',
				     }
				}
			   },
		   description => "Each key of a hash is a boolean expression using variables declared in the 'follow' parameters. The value of the hash specifies the effects on the node",
		   },

       'morph' => 
       => {
	   type => 'leaf',
	   value_type => 'boolean', 
	   level      => 'hidden' ,
	   'warp'
	   => { follow => '- - cargo_type',
		'rules'
		=> { 'warped_node' 
		     => {
			 level => 'normal',
			 built_in => 0 ,
			},
		   }
	      },
	   description => "When set, a recurse copy of the value from the old object to the new object will be attemped. When a copy is not possible, undef values will be assigned.",
	  },

       # end warp elements for warped_node

       # leaf element


       'refer_to' 
       => { type => 'leaf',
	    level      => 'hidden' ,
	    value_type => 'uniline',
	    warp => { follow => { vt => '- value_type',
				  ct => '- - cargo_type',
				},
		     'rules'
		      => [ '   $ct eq "check_list"
                            or $vt eq "reference"  '
			   => {
			       level => 'important',
			      },
			 ]
		    },
	    description => "points to an array or hash element in the configuration tree using the path syntax. The available choice of this reference value (or check list)is made from the available keys of the pointed hash element or the values of the pointed array element.",
	  },

       'computed_refer_to' 
       => { type => 'warped_node',
	    follow => { vt => '- value_type',
			ct => '- - cargo_type',
		      },
	    'rules'
	    => [ '   $ct eq "check_list"
                  or $vt eq "reference"  '
		 => {
		     level => 'normal',
		     config_class_name => 'Itself::ComputedValue',
		    },
	       ],
	    description => "points to an array or hash element in the configuration tree using a path computed with value from several other elements in the configuration tree. The available choice of this reference value (or check list) is made from the available keys of the pointed hash element or the values of the pointed array element.",
	  },

 
       'compute' 
       => { type => 'warped_node',

	    follow => { ct => '- - cargo_type',
		      },
	    'rules' => [ '$ct eq "leaf" '
			 => {
			     level => 'normal',
			     config_class_name => 'Itself::ComputedValue',
			    },
		       ],
	    description => "compute the default value according to a formula and value from other elements in the configuration tree.",
	  },

      ],

  ],

];

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
        name => "Itself::Class",

        class_description =>
          "Configuration class. This class will contain elements",

        'element' => [

            'element' => {
                type       => 'hash',
                level      => 'important',
                ordered    => 1,
                index_type => 'string',
                cargo      => {
                    type              => 'node',
                    config_class_name => 'Itself::Element',
                },
            },

            'include' => {
                type  => 'list',
                cargo => {
                    type       => 'leaf',
                    value_type => 'reference',
                    refer_to   => '! class',
                }
            },

            'include_after' => {
                type       => 'leaf',
                value_type => 'reference',
                refer_to   => '- element',
            },

            'class_description' => {
                type       => 'leaf',
                value_type => 'string',
            },

            [qw/write_config_dir read_config_dir/] => {
                type       => 'leaf',
                value_type => 'uniline',
                status     => 'deprecated',
            },

            generated_by => {
                type       => 'leaf',
                value_type => 'uniline',
            },
            'read_config' => {
                type  => 'list',
                cargo => {
                    type              => 'node',
                    config_class_name => 'Itself::ConfigRead',
                },
            },

            'write_config' => {
                type  => 'list',
                cargo => {
                    type              => 'node',
                    config_class_name => 'Itself::ConfigWrite',
                },
            },
            'accept' => {
                type       => 'hash',
                index_type => 'string',
                ordered    => 1,
                cargo      => {
                    type              => 'node',
                    config_class_name => 'Itself::ConfigAccept',
                },
            },
        ],
        'description' => [
            element => "Specify the elements names of this configuration class.",
            include => "Include the specification of another class into this class.",
            include_after => "insert the included elements after a specific element",
            class_description => "Explain the purpose of this configuration class",
            read_config => "Specify the Perl class(es) and function(s) used to read configuration data. The specified function will be tried in sequence to get configuration data. ",
            write_config => "Specify the Perl class and function used to write configuration data.",
            generated_by => "When set, this class was generated by some program. You should not edit it as your modification may be clobbered later on",
            accept => "Specifies names of the elements this configuration class will accept as valid (based on a regular expression)"
        ],
    ],

    [
        name => "Itself::ConfigWR",

        'element' => [

            'syntax' => {
                type       => 'leaf',
                value_type => 'enum',
                choice     => [qw/cds perl ini custom/],
                status     => 'deprecated',
                description => 'Deprecated parameter that specified the file syntax to store permanently configuration data. Replaced by "backend"',
            },

            'backend' => {
                type         => 'leaf',
                class        => 'Config::Model::Itself::BackendDetector',
                value_type   => 'enum',
                choice       => [qw/cds_file perl_file ini_file augeas custom/],
                migrate_from => {
                    formula   => '$old',
                    variables => { old => '- syntax' },
                    replace   => {
                        perl => 'perl_file',
                        ini  => 'ini_file',
                        cds  => 'cds_file',
                    },
                },
                description => 'specifies the backend to store permanently configuration data.',
                help => {
                    cds_file => "file with config data string. This is Config::Model own serialisation format, designed to be compact and readable. Configuration filename is made with instance name",
                    ini_file =>
"Ini file format. Beware that the structure of your model must match the limitations of the INI file format, i.e only a 2 levels hierarchy. Configuration filename is made with instance name",
                    perl_file =>
"file with a perl data structure. Configuration filename is made with instance name",
                    custom =>
"Custom format. You must specify your own class and method to perform the read or write function. See Config::Model::AutoRead doc for more details",
                    augeas =>
"Experimental backend with RedHat's Augeas library. See http://augeas.net for details",
                }
            },

            'file' => {
                type       => 'leaf',
                value_type => 'uniline',
                level      => 'normal',
                summary    => 'target configuration file name',
                description =>
'specify the configuration file name. This parameter may not be applicable depending on your application. It may also be hardcoded in a custom backend. If not specified, the instance name will be used as base name for your configuration file.',
                migrate_from => {
                    variables => { old => '- config_file' },
                    formula   => '$old',
                }
            },

            'class' => {
                type       => 'leaf',
                value_type => 'uniline',
                level      => 'hidden',
                warp       => {
                    follow => '- backend',
                    rules  => [
                        custom => {
                            level     => 'normal',
                            mandatory => 1,
                        }
                    ],
                }
            },

            'save' => {
                type       => 'leaf',
                value_type => 'enum',
                choice     => [qw/backup newfile/],
                level      => 'hidden',
                description =>
'Specify how to save the configuration file. Either create a newfile (with extension .augnew, and do not overwrite the original file) or move the original file into a backup file (.augsave extension). Configuration files are overwritten by default',
                warp => {
                    follow => '- backend',
                    rules  => [ augeas => { level => 'normal', } ],
                }
            },
            'config_file' => {
                type       => 'leaf',
                value_type => 'uniline',
                status     => 'deprecated',
                level      => 'normal',
                description =>
'Specify the configuration file (without path) that will store configuration information',
            },
            'comment_delimiter' => {
                type             => 'leaf',
                value_type       => 'uniline',
                level            => 'hidden',
                description      => 'comment starts with this character',
                upstream_default => '#',
                warp             => {
                    follow => '- backend',
                    rules  => [ ini_file => { level => 'normal', } ],
                }
            },
            'set_in' => {
                type       => 'leaf',
                value_type => 'reference',
                refer_to   => '- - element',
                level      => 'hidden',
                description =>
'Sometimes, the structure of a file loaded by Augeas starts directly with a list of items. For instance, /etc/hosts structure starts with a list of lines that specify hosts and IP adresses. This parameter specifies an element name in Config::Model root class that will hold the configuration data retrieved by Augeas',
                warp => {
                    follow => '- backend',
                    rules  => [ augeas => { level => 'normal', } ],
                }
            },
            'sequential_lens' => {
                type  => 'list',
                level => 'hidden',
                cargo => {
                    type       => 'leaf',
                    value_type => 'uniline',
                },
                warp => {
                    follow => { b                => '- backend' },
                    rules  => [ '$b eq "augeas"' => { level => 'normal', } ],
                },
                description =>
'List of hash or list Augeas lenses where value are stored in sequential Augeas nodes. See Config::Model::Backend::Augeas for details.',
            },
        ],

    ],

    [
        name    => 'Itself::ConfigRead',
        include => "Itself::ConfigWR",

        'element' => [
            'function' => {
                type       => 'leaf',
                value_type => 'uniline',
                level      => 'hidden',
                warp       => {
                    follow => '- backend',
                    rules  => [
                        custom => {
                            level            => 'normal',
                            upstream_default => 'read',
                        }
                    ],
                }
            },

            'config_dir' => {
                type         => 'leaf',
                value_type   => 'uniline',
                level        => 'normal',
                mandatory    => 1,
                migrate_from => {
                    formula   => '$old',
                    variables => { old => '- - read_config_dir' },
                }
            },

            'auto_create' => {
                type             => 'leaf',
                value_type       => 'boolean',
                level            => 'normal',
                upstream_default => 0,
                summary          => 'Creates configuration files as needed',
                migrate_from     => {
                    formula   => '$old',
                    variables => { old => '- allow_empty' },
                },
            },

            'allow_empty' => {
                type             => 'leaf',
                value_type       => 'boolean',
                level            => 'normal',
                status           => 'deprecated',
                upstream_default => 0,
                summary          => 'deprecated in favor of auto_create',
            },

        ],
    ],

    [
        name    => 'Itself::ConfigWrite',
        include => "Itself::ConfigWR",

        'element' => [
            'function' => {
                type       => 'leaf',
                value_type => 'uniline',
                level      => 'hidden',
                warp       => {
                    follow => '- backend',
                    rules  => [
                        custom => {
                            level            => 'normal',
                            upstream_default => 'write',
                        }
                    ],
                }
            },
            'config_dir' => {
                type         => 'leaf',
                value_type   => 'uniline',
                level        => 'normal',
                mandatory    => 1,
                migrate_from => {
                    formula   => '$old',
                    variables => { old => '- - write_config_dir' },
                }
            },

            # move to ConfigRW when removing legacy allow_empty
            'auto_create' => {
                type             => 'leaf',
                value_type       => 'boolean',
                level            => 'normal',
                upstream_default => 0,
                summary          => 'Creates configuration files as needed',
            },

        ],
    ],

    [
        name => 'Itself::ConfigAccept',

        include       => "Itself::Element",
        include_after => 'name_match',
        'element'     => [
            'name_match' => {
                type             => 'leaf',
                value_type       => 'uniline',
                level            => 'normal',
                upstream_default => '.*',
                summary => 'Accepted parameters must match this regexp',
                description =>
                  'Define a Perl regular expression that is tested agaisnt 
           candidate parameters. When the parameter matches the regular expression, 
           a new parameter is created in the model using the description provided
           within the "accept" declaration. Note that the regexp must match the whole 
           candidate parameter name. I.e. the specified regexp will be eval\'ed 
           with a leading ^ and a trailing $. Without a specification, all parameters
           are accepted',
            },

        ],
    ],

];

#
# This file is part of Config-Model-Itself
#
# This software is Copyright (c) 2012 by Dominique Dumont.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
[
    [
        name => 'MasterModel::SshdWithAugeas',

        'read_config' => [
            {
                backend         => 'augeas',
                config_dir      => '/etc/ssh',
                file            => 'sshd_config',
                sequential_lens => [qw/HostKey Subsystem Match/],
            },
            {
                backend     => 'perl_file',
                config_dir  => '/etc/ssh',
                auto_create => 1,
            },
        ],

        element => [
            'AcceptEnv',
            {
                'cargo' => {
                    'value_type' => 'uniline',
                    'type'       => 'leaf'
                },
                'type' => 'list',
            },
            'HostbasedAuthentication',
            {
                'value_type' => 'boolean',
                'type'       => 'leaf',
            },
            'HostKey',
            {
                'cargo' => {
                    'value_type' => 'uniline',
                    'type'       => 'leaf'
                },
                'type' => 'list',
            },
            'Subsystem',
            {
                'cargo' => {
                    'value_type' => 'uniline',
                    'mandatory'  => '1',
                    'type'       => 'leaf'
                },
                'type'       => 'hash',
                'index_type' => 'string'
            },
        ],
    ]
];

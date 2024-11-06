#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# @copyright    Copyright (c) 2019-present, Duc Ng. (bitst0rm)
# @link         https://github.com/bitst0rm
# @license      The MIT License (MIT)

import logging
from ..core import common

log = logging.getLogger(__name__)
EXECUTABLES = ['topiary']
MODULE_CONFIG = {
    'source': 'https://github.com/tweag/topiary',
    'name': 'Topiary',
    'uid': 'topiary',
    'type': 'beautifier',
    'syntaxes': ['json', 'nickel', 'ocaml', 'ocamllex', 'toml'],
    'exclude_syntaxes': None,
    'executable_path': '/path/to/bin/topiary',
    'args': None,
    'config_path': {
        'default': 'topiary_rc.toml'
    }
}


class TopiaryFormatter(common.Module):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def get_cmd(self):
        executable = self.get_executable(runtime_type=None)
        if not executable:
            return None

        cmd = [executable, 'format']

        cmd.extend(['--language', self.get_assigned_syntax()])

        cmd.extend(self.get_args())

        path = self.get_config_path()
        if path:
            cmd.extend(['--configuration', path])

        cmd.extend(['--'])

        log.debug('Current arguments: %s', cmd)
        cmd = self.fix_cmd(cmd)

        return cmd

    def format(self):
        cmd = self.get_cmd()
        if not self.is_valid_cmd(cmd):
            return None

        try:
            exitcode, stdout, stderr = self.exec_cmd(cmd)

            if exitcode > 0:
                self.print_exiterr(exitcode, stderr)
            else:
                return stdout
        except OSError:
            self.print_oserr(cmd)

        return None

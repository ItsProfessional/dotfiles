#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# @copyright    Copyright (c) 2019-present, Duc Ng. (bitst0rm)
# @link         https://github.com/bitst0rm
# @license      The MIT License (MIT)

import logging
from ..core import common

log = logging.getLogger(__name__)
INTERPRETERS = ['python3', 'python']
EXECUTABLES = ['nginxfmt']
MODULE_CONFIG = {
    'source': 'https://github.com/slomkowski/nginx-config-formatter',
    'name': 'NGINXfmt',
    'uid': 'nginxfmt',
    'type': 'beautifier',
    'syntaxes': ['nginx'],
    'exclude_syntaxes': None,
    'executable_path': '/path/to/bin/nginxfmt',
    'args': ['--indent', '4'],
    'config_path': None,
    'comment': 'requires "environ": {"PYTHONPATH": ["/lib/python3.7/site-packages"]}. no config, use args instead. requires python on PATH if omit interpreter_path'
}


class NginxfmtFormatter(common.Module):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def get_cmd(self):
        cmd = self.get_combo_cmd(runtime_type='python')
        if not cmd:
            return None

        cmd.extend(['--pipe', '--'])

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

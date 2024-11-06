#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# @copyright    Copyright (c) 2019-present, Duc Ng. (bitst0rm)
# @link         https://github.com/bitst0rm
# @license      The MIT License (MIT)

import os
import logging
import tempfile
from ..core import common

log = logging.getLogger(__name__)
INTERPRETERS = ['php']
EXECUTABLES = ['php-cs-fixer-v3.phar', 'php-cs-fixer-v3', 'phpcsfixer.phar', 'phpcsfixer', 'php-cs-fixer.phar', 'php-cs-fixer', 'php-cs-fixer-v2.phar', 'php-cs-fixer-v2']
MODULE_CONFIG = {
    'source': 'https://github.com/FriendsOfPHP/PHP-CS-Fixer',
    'name': 'PHP CS Fixer',
    'uid': 'phpcsfixer',
    'type': 'beautifier',
    'syntaxes': ['php'],
    'exclude_syntaxes': None,
    'executable_path': '/path/to/bin/php-cs-fixer.phar',
    'args': None,
    'config_path': {
        'default': 'php_cs_fixer_rc.php'
    },
    'comment': 'requires php on PATH if omit interpreter_path'
}


class PhpcsfixerFormatter(common.Module):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def get_cmd(self):
        cmd = self.get_combo_cmd(runtime_type=None)
        if not cmd:
            return None

        path = self.get_config_path()
        if path:
            cmd.extend(['--config=' + path, '--allow-risky=yes'])

        tmp_file = self.create_tmp_file()
        cmd.extend(['fix', tmp_file])

        log.debug('Current arguments: %s', cmd)
        cmd = self.fix_cmd(cmd)

        return cmd, tmp_file

    def format(self):
        cmd, tmp_file = self.get_cmd()
        if not self.is_valid_cmd(cmd):
            self.remove_tmp_file(tmp_file)
            return None

        try:
            exitcode, stdout, stderr = self.exec_com(cmd)

            result = None

            if exitcode > 0 or not stdout:
                self.print_exiterr(exitcode, stderr)
            else:
                with open(tmp_file, 'r', encoding='utf-8') as file:
                    result = file.read()
                    file.close()
        except OSError:
            self.print_oserr(cmd)

        self.remove_tmp_file(tmp_file)

        return result

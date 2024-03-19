#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# @copyright    Copyright (c) 2019-present, Duc Ng. (bitst0rm)
# @link         https://github.com/bitst0rm
# @license      The MIT License (MIT)

import logging
from ..core import common

log = logging.getLogger(__name__)
INTERPRETERS = ['java']
EXECUTABLES = ['cljfmt']
MODULE_CONFIG = {
    'source': 'https://github.com/weavejester/cljfmt',
    'name': 'CLJfmt',
    'uid': 'cljfmt',
    'type': 'beautifier',
    'syntaxes': ['clojure'],
    'exclude_syntaxes': None,
    'interpreter_path': '/path/to/bin/java.exe or /path/to/bin/lein',
    'executable_path': '/path/to/bin/cljfmt',
    'args': None,
    'config_path': {
        'default': 'cljfmt_rc.edn'
    },
    'comment': 'omit interpreter_path if use cljfmt standalone version'
}


class CljfmtFormatter(common.Module):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def get_cmd(self):
        executable = self.get_executable(runtime_type=None)
        if not executable:
            return None

        interpreter = self.get_interpreter()
        if interpreter:
            interpreter_base = common.basename(interpreter).lower()
            if 'java' in interpreter_base and executable.endswith('jar'):
                cmd = [interpreter, '-jar', executable]
            elif 'lein' in interpreter_base:
                cmd = [interpreter, executable]
            else:
                cmd = [executable]
        else:
            cmd = [executable]

        cmd.extend(['fix'])

        cmd.extend(self.get_args())

        path = self.get_config_path()
        if path:
            cmd.extend(['--config', path])

        cmd.extend(['-'])

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

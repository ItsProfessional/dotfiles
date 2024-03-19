#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# @copyright    Copyright (c) 2019-present, Duc Ng. (bitst0rm)
# @link         https://github.com/bitst0rm
# @license      The MIT License (MIT)

import logging
from ..core import common

log = logging.getLogger(__name__)
EXECUTABLES = ['terraform']
MODULE_CONFIG = {
    'source': 'https://developer.hashicorp.com/terraform/cli/commands/fmt',
    'name': 'Terraform fmt',
    'uid': 'terraformfmt',
    'type': 'beautifier',
    'syntaxes': ['terraform'],
    'exclude_syntaxes': None,
    'executable_path': '/path/to/bin/terraform',
    'args': None,
    'config_path': None,
    'comment': 'opinionated, no config'
}


class TerraformfmtFormatter(common.Module):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def get_cmd(self):
        executable = self.get_executable(runtime_type=None)
        if not executable:
            return None

        cmd = [executable, 'fmt']

        cmd.extend(self.get_args())

        cmd.extend(['-no-color', '-'])

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

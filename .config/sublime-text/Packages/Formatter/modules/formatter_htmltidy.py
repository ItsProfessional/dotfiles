#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# @copyright    Copyright (c) 2019-present, Duc Ng. (bitst0rm)
# @link         https://github.com/bitst0rm
# @license      The MIT License (MIT)

import logging
from ..core import common

log = logging.getLogger(__name__)
EXECUTABLES = ['tidy']
MODULE_CONFIG = {
    'source': 'https://github.com/htacg/tidy-html5',
    'name': 'HTML Tidy',
    'uid': 'htmltidy',
    'type': 'beautifier',
    'syntaxes': ['html', 'xml'],
    'exclude_syntaxes': None,
    'executable_path': '/path/to/bin/tidy',
    'args': None,
    'config_path': {
        'html': 'htmltidy_html_rc.cfg',
        'xml': 'htmltidy_xml_rc.cfg'
    }
}


class HtmltidyFormatter(common.Module):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def get_cmd(self):
        executable = self.get_executable(runtime_type=None)
        if not executable:
            return None

        cmd = [executable]

        cmd.extend(self.get_args())

        path = self.get_config_path()
        if path:
            cmd.extend(['-config', path])

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

            if exitcode > 1:
                self.print_exiterr(exitcode, stderr)
            else:
                if exitcode == 1:
                    log.warning('File formatted but with warnings (exitcode=%d): "%s"', exitcode, stderr)
                return stdout
        except OSError:
            self.print_oserr(cmd)

        return None

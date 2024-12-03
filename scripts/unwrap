#!/bin/sh
# unwrap the calling script
# source this script in wrapper scripts to remove wrapper directory from path, so that original binary can be called
# useful for nesting wrappers
PATH="$(echo "$PATH" | tr ':' '\n' | grep -v "$(dirname "$0")" | tr '\n' ':' | sed 's/:$//')"
export PATH


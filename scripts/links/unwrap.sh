#!/bin/sh
# unwrap the calling script
# source this script in wrapper scripts to remove wrapper directory from path, so that original binary can be called
# useful for nesting wrappers
. "$(dirname "$0")"/../../wrappers/unwrap.sh
exec "$(basename "$0")" "$@"


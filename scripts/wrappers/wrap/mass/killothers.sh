#!/bin/sh
# kill other instances of calling script

# https://stackoverflow.com/questions/38435772/bash-script-kill-all-same-processes-instead-of-this-one
kill $(pgrep -x "$(basename "$0")" | grep -v ^$$$) > /dev/null 2>&1

. "$(dirname "$0")"/../../../unwrap.sh
exec "$(basename "$0")" "$@"


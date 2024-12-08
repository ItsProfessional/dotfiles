#!/bin/sh
# only run if no other instances of the script are running

. "$(dirname "$0")"/../../../unwrap.sh
pgrep -x "$(basename "$0")" | grep -v ^$$$ > /dev/null 2>&1 || exec "$(basename "$0")" "$@"


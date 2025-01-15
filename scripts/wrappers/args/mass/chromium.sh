#!/bin/sh
# use electron-flags.conf for chromium browsers too
# useful for enabling things like middle click autoscroll, etc.
# NOTE: realized that (chromium|chrome|brave)-flags.conf can just be symlinked to electron-flags.conf. so, this wrapper is useless, but still going to keep around in case it is useful later

. "$(dirname "$0")"/../../../unwrap.sh
eval exec "$(basename "$0")" $(cat "$XDG_CONFIG_HOME"/electron-flags.conf) "$@"


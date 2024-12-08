#!/bin/sh
# kill other instances of calling script

. "$(dirname "$0")"/../../../unwrap.sh
exec "$(basename "$0")" "$@" << EOF
$(cat)
EOF



#!/bin/sh
# don't redirect piped data into stdin until the piped command has finished running
# useful for launchers, so that they show the menu after all the items have been passed

. "$(dirname "$0")"/../../../unwrap.sh
exec "$(basename "$0")" "$@" << EOF
$(cat)
EOF


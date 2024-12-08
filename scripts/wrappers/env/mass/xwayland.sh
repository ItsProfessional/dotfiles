#!/bin/sh
# run program as xwayland

. "$(dirname "$0")"/../../../unwrap.sh
exec env QT_QPA_PLATFORM=xcb "$(basename "$0")" "$@"


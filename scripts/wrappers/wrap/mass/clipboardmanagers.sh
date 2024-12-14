#!/bin/sh
# don't save passwords into clipboard history

. "$(dirname "$0")"/../../../unwrap.sh
if [ "$(hyprctl activewindow -j | jq -r .class)" = "org.keepassxc.KeePassXC" ]; then
  exit 1
fi

exec "$(basename "$0")" "$@"


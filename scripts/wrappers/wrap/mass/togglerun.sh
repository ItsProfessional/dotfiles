#!/bin/sh
# only run if no other instances of the script are running, otherwise kill the instances

instances="$(pgrep -x "$(basename "$0")" | grep -v ^$$$)"

echo "i: $instances"
if [ -n "$instances" ]; then
  echo lol
  kill $instances > /dev/null 2>&1
  echo lol
  exit 0
fi

. "$(dirname "$0")"/../../../unwrap.sh
exec "$(basename "$0")" "$@"


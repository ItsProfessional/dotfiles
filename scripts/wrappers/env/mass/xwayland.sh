#!/bin/sh
# run program as xwayland. this is necessary for some programs, as otherwise they refuse to start automatically as xwayland and just crash saying that wayland isn't supported

. "$(dirname "$0")"/../../../unwrap.sh
exec env QT_QPA_PLATFORM=xcb \
  MOZ_ENABLE_WAYLAND=0 \
  GDK_BACKEND=x11 \
  QT_QPA_PLATFORM=xcb \
  SDL_VIDEODRIVER=x11 \
  CLUTTER_BACKEND=x11 \
  ECORE_EVAS_ENGINE=x11 \
  ELM_ENGINE=x11 \
  WINIT_UNIX_BACKEND=x11 \
  ELECTRON_OZONE_PLATFORM_HINT=x11 \
  WAYLAND_DISPLAY=\
  "$(basename "$0")" "$@"


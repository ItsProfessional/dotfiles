environment=hyprland

# Start the graphical environment
if [ -z "${DISPLAY}" ] && [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] && [ "$(tty)" = "/dev/tty1" ]; then

    # XDG Session variables -- I don't exactly recall why I added these; probably because not every WM sets them. See: https://man.sr.ht/~kennylevinsen/greetd/#how-to-set-xdg_session_typewayland
    export XDG_SESSION_TYPE=wayland
    if [ "$environment" = "hyprland" ]; then
      export XDG_CURRENT_DESKTOP=Hyprland
      export XDG_SESSION_DESKTOP=Hyprland
    elif [ "$environment" = "sway" ]; then
      export XDG_CURRENT_DESKTOP=$environment
      export XDG_SESSION_DESKTOP=$environment
    elif [ "$environment" = "qtile" ]; then
      export XDG_CURRENT_DESKTOP=$environment
      export XDG_SESSION_DESKTOP=$environment
    fi

    # Force native wayland
    export MOZ_ENABLE_WAYLAND=1
    export GDK_BACKEND=wayland,x11,*
    export QT_QPA_PLATFORM="wayland;xcb"
    export SDL_VIDEODRIVER=wayland
    export CLUTTER_BACKEND=wayland
    export ECORE_EVAS_ENGINE=wayland_egl
    export ELM_ENGINE=wayland_egl
    
    # Wayland fixes
    # Fix graphical java programs being blank
    export _JAVA_AWT_WM_NONREPARENTING=1

    # Load GTK/QT env vars from config files -- sometimes these are not set by the DE/WM so I do it manually just in case.
    config="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini" # this file is written to by nwg-look
    if [ -f "$config" ]; then
      export GTK_THEME="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      #export XCURSOR_THEME="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      #export XCURSOR_SIZE="$(grep 'gtk-cursor-theme-size' "$config" | sed 's/.*\s*=\s*//')"
    fi
    # Force libreoffice to use gtk
    export SAL_USE_VCLPLUGIN=gtk4

    # Start the environment
    if [ "$environment" = "plasma" ]; then
      export QT_QPA_PLATFORMTHEME=kde
      exec startplasma-wayland
    else
      export QT_QPA_PLATFORMTHEME=qt5ct:qt6ct
      #export QT_QPA_PLATFORMTHEME=kde # use plasma's systemsettings for qt stuff -- I prefer this over something like qt5ct because it's so much more customizable
      #export KDE_SESSION_VERSION=6 # This is important, as even though it's specifically a kde env var; without it, qt5 applications won't respect what you configure in systemsettings (only qt6 applications will)

      gsettings set org.gnome.desktop.wm.preferences button-layout ':' # Remove titlebar buttons -- it's important to make this gsettings command run every time I log in, because if I just set it once, it will get reset when I log into a DE such as plasma.

      if [ "$environment" = "hyprland" ]; then
          exec Hyprland
      elif [ "$environment" = "qtile" ]; then
          exec qtile start -b wayland
      fi
    fi

fi


environment=Hyprland

# Start the graphical environment
if [ -z "${DISPLAY}" ] && [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] && [ "$TTY" = "/dev/tty1" ]; then

    # XDG Session variables -- I don't exactly recall why I added these; probably because not every WM sets them. See: https://man.sr.ht/~kennylevinsen/greetd/#how-to-set-xdg_session_typewayland
    export XDG_SESSION_TYPE=wayland
    case "$environment" in
    sway|Hyprland|qtile|river)
      export XDG_CURRENT_DESKTOP=$environment
      export XDG_SESSION_DESKTOP=$environment
      ;;
    *) # for esoteric compositors, default to using sway as usually it just works
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_DESKTOP=sway
      ;;
    esac

    # Toolkit stuff
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    # Force native wayland
    export MOZ_ENABLE_WAYLAND=1
    export GDK_BACKEND="wayland,x11,*"
    export QT_QPA_PLATFORM="wayland;xcb"
    export SDL_VIDEODRIVER="wayland,x11"
    export CLUTTER_BACKEND=wayland
    export ECORE_EVAS_ENGINE=wayland_egl
    export ELM_ENGINE=wayland_egl
    
    # Wayland fixes
    # Fix graphical java programs being blank
    export _JAVA_AWT_WM_NONREPARENTING=1

    # https://wiki.archlinux.org/title/Uniform_look_for_Qt_and_GTK_applications#Consistent_file_dialog_under_KDE_Plasma
    export GTK_USE_PORTAL=1
    export GDK_DEBUG=portals

    # Load GTK/QT env vars from config files -- sometimes these are not set by the DE/WM so I do it manually just in case
    # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland#setting-values-in-gsettings
    config="$XDG_CONFIG_HOME/gtk-3.0/settings.ini" # this file is written to by nwg-look
    if [ -f "$config" ]; then
      gtk_theme="$(awk -F "=" '/gtk-theme-name/ {print $2}' "$config")"
      icon_theme="$(awk -F "=" '/gtk-icon-theme-name/ {print $2}' "$config")"
      cursor_theme="$(awk -F "=" '/gtk-cursor-theme-name/ {print $2}' "$config")"
      cursor_size="$(awk -F "=" '/gtk-cursor-theme-size/ {print $2}' "$config")"
      font_name="$(awk -F "=" '/gtk-font-name/ {print $2}' "$config")"
      document_font_name="$font_name"
      monospace_font_name="$font_name"

      if which gsettings; then
        gsettings set org.gnome.desktop.interface gtk-theme             "$gtk_theme"
        gsettings set org.gnome.desktop.interface icon-theme            "$icon_theme"
        gsettings set org.gnome.desktop.interface cursor-theme          "$cursor_theme"
        gsettings set org.gnome.desktop.interface font-name             "$font_name"
        gsettings set org.gnome.desktop.interface document-font-name    "$document_font_name"
        gsettings set org.gnome.desktop.interface monospace-font-name   "$monospace_font_name"
      elif which dconf; then
        dconf write /org/gnome/desktop/interface/gtk-theme           "'$gtk_theme'"
        dconf write /org/gnome/desktop/interface/icon-theme          "'$icon_theme'"
        dconf write /org/gnome/desktop/interface/cursor-theme        "'$cursor_theme'"
        dconf write /org/gnome/desktop/interface/font-name           "'$font_name'"
        dconf write /org/gnome/desktop/interface/document-font-name  "'$document_font_name'"
        dconf write /org/gnome/desktop/interface/monospace-font-name "'$monospace_font_name'"
      fi

      export GTK_THEME="$gtk_theme"
      export XCURSOR_THEME="$cursor_theme"
      export XCURSOR_SIZE="$cursor_size"
    fi

    # Force libreoffice to use gtk
    export SAL_USE_VCLPLUGIN=gtk4

    # Start the environment
    COMMAND=""
    if [ "$environment" = "plasma" ] || [ "$environment" = "kde" ]; then
      export QT_QPA_PLATFORMTHEME=kde
      COMMAND="/usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland"
    else
      #export QT_QPA_PLATFORMTHEME=qt5ct:qt6ct

      # https://www.reddit.com/r/linux/comments/1c2ts9p/guide_a_potentially_better_way_to_theme_qt_apps/
      export XDG_CURRENT_DESKTOP=KDE
      export QT_QPA_PLATFORMTHEME=kde
      export QT_PLATFORM_PLUGIN=kde
      export KDE_SESSION_VERSION=6
      export KDE_FULL_SESSION=true

      # Dconf options - sometimes they get reset by DE's like plasma, so I set them on start
      if which gsettings; then
        gsettings set org.gnome.desktop.wm.preferences button-layout ':'
      elif which dconf; then
        dconf write /org/gnome/desktop/wm/preferences/button-layout "':'"
      fi

      # Environment specific configuration
      if [ "$environment" = "Hyprland" ]; then
          export HYPRCURSOR_THEME="theme_NotwaitaBlack"
          export HYPRCURSOR_SIZE="$XCURSOR_SIZE"
          COMMAND="Hyprland"
      elif [ "$environment" = "qtile" ]; then
          COMMAND="qtile start -b wayland"
      elif [ "$environment" = "river" ]; then
          COMMAND="river"
      fi
    fi

    eval exec "$COMMAND"

fi


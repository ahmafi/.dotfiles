#!/usr/bin/env bash

printf "\n★ use dnf fastest mirror"
fastest_mirror="fastest_mirror=True"
dnf_config="/etc/dnf/dnf.conf"
if ! grep -q -F "$fastest_mirror" "$dnf_config"; then
  echo "$fastest_mirror" | sudo tee -a "$dnf_config" >/dev/null
fi

printf "\n★ installing dnf updates"
sudo dnf update -y

printf "\n★ installing dnf packages"
sudo dnf install -y \
  vlc \
  zsh \
  mpv \
  gimp \
  gnome-extensions-app \
  gnome-tweaks \
  inkscape \
  obs-studio \
  snapd \
  python3-pip \
  /

printf "\n★ installing vscode"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf makecache
sudo dnf install -y code

printf "\n★ installing github cli"
sudo dnf install -y 'dnf-command(config-manager)'
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install -y gh

printf "\n★ installing snap packages"
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install \
  skype \
  motrix \
  mysql-workbench-community \
  breaktimer \
  spotify \
  telegram-desktop \
  /

printf "\n★ installing pip packages"
python3 -m pip install --user pipx
python3 -m pipx ensurepath
pipx install spotdl

printf "\n★ installing gnome extensions"
pipx install gnome-extensions-cli --system-site-packages
gext --filesystem install \
  activitiesworkspacename@ahmafi.ir \
  appindicatorsupport@rgcjonas.gmail.com \
  autoselectheadset@josephlbarnett.github.com \
  clipboard-history@alexsaveau.dev \
  crypto@alipirpiran.github \
  gestureImprovements@gestures \
  gsconnect@andyholmes.github.io \
  RemoveAppMenu@Dragon8oy.com \
  scroll-workspaces@gfxmonk.net \
  shamsi-calendar@gnome.scr.ir \
  ShutdownTimer@deminder \
  spotify-controller@koolskateguy89 \
  user-theme@gnome-shell-extensions.gcampax.github.com \
  Vitals@CoreCoding.com \
  window-app-switcher-on-active-monitor@NiKnights.com \
  /

printf "\n★ changing gnome settings"
settings=(
  "org.gnome.TextEditor spellcheck false"
  "org.gnome.calculator show-thousands true"
  "org.gnome.desktop.input-sources sources [('xkb', 'us'), ('xkb', 'ir')]"
  "org.gnome.desktop.input-sources per-window true"
  "org.gnome.desktop.input-sources xkb-options ['caps:escape_shifted_capslock']"
  "org.gnome.desktop.interface clock-format '12h'"
  "org.gnome.desktop.interface clock-show-seconds true"
  "org.gnome.desktop.interface color-scheme 'prefer-dark'"
  "org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"
  "org.gnome.desktop.peripherals.touchpad natural-scroll false"
  "org.gnome.desktop.peripherals.touchpad tap-to-click true"
  "org.gnome.desktop.search-providers disabled ['org.gnome.Characters.desktop']"
  "org.gnome.desktop.wm.keybindings activate-window-menu @as []"
  "org.gnome.desktop.wm.keybindings minimize @as []"
  "org.gnome.desktop.wm.keybindings move-to-monitor-down ['<Shift><Super>j']"
  "org.gnome.desktop.wm.keybindings move-to-monitor-left @as []"
  "org.gnome.desktop.wm.keybindings move-to-monitor-right @as []"
  "org.gnome.desktop.wm.keybindings move-to-monitor-up ['<Shift><Super>k']"
  "org.gnome.desktop.wm.keybindings move-to-workspace-left ['<Shift><Super>h']"
  "org.gnome.desktop.wm.keybindings move-to-workspace-right ['<Shift><Super>l']"
  "org.gnome.desktop.wm.keybindings switch-applications @as []"
  "org.gnome.desktop.wm.keybindings switch-applications-backward @as []"
  "org.gnome.desktop.wm.keybindings switch-input-source ['<Super>space']"
  "org.gnome.desktop.wm.keybindings switch-input-source-backward ['<Shift><Super>space']"
  "org.gnome.desktop.wm.keybindings switch-to-workspace-left ['<Super>h']"
  "org.gnome.desktop.wm.keybindings switch-to-workspace-right ['<Super>l']"
  "org.gnome.desktop.wm.keybindings switch-windows ['<Alt>Tab']"
  "org.gnome.desktop.wm.keybindings switch-windows-backward ['<Shift><Alt>Tab']"
  "org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'"
  "org.gnome.mutter center-new-windows true"
  "org.gnome.mutter dynamic-workspaces false"
  "org.gnome.mutter workspaces-only-on-primary false"
  "org.gnome.rhythmbox.plugins seen-plugins ['grilo', 'rb', 'webremote', 'replaygain', 'rbzeitgeist', 'pythonconsole', 'notification', 'mtpdevice', 'ipod', 'fmradio', 'dbus-media-server', 'daap', 'cd-recorder', 'audioscrobbler', 'artsearch', 'im-status', 'listenbrainz', 'lyrics', 'magnatune']"
  "org.gnome.rhythmbox.rhythmdb locations ['file:///home/amir/Music']"
  "org.gnome.settings-daemon.plugins.media-keys next ['<Super>F12']"
  "org.gnome.settings-daemon.plugins.media-keys play ['<Super>F10']"
  "org.gnome.settings-daemon.plugins.media-keys previous ['<Super>F11']"
  "org.gnome.settings-daemon.plugins.media-keys screensaver @as []"
  "org.gnome.shell favorite-apps ['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'telegram-desktop_telegram-desktop.desktop']"
  "org.gnome.shell.app-switcher current-workspace-only true"
  "org.gnome.shell.extensions.appindicator tray-pos 'right'"
  "org.gnome.shell.keybindings open-application-menu @as []"
  "org.gnome.tweaks show-extensions-notice false"
  "org.gtk.Settings.FileChooser clock-format '12h'"
)
for setting in "${settings[@]}"; do
  gsettings set $setting
done

printf "\n★ adding fonts"

printf "\n★ interactive session ★"

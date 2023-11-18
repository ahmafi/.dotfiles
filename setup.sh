#!/usr/bin/env bash

# TODO: remove sudo

trap "echo; exit" INT

create() {
  mkdir -p -- "$(dirname "$1")" && cat >"$1"
}

printf "★ use dnf fastest mirror\n"
fastest_mirror="fastest_mirror=True"
dnf_config="/etc/dnf/dnf.conf"
if ! grep -q -F "$fastest_mirror" "$dnf_config"; then
  echo "$fastest_mirror" | sudo tee -a "$dnf_config" >/dev/null
fi

printf "\n★ installing dnf updates\n"
sudo dnf update -y

printf "\n★ add rpm fusion\n"
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf makecache

printf "\n★ installing dnf packages\n"
sudo dnf install -y \
  vlc \
  zsh \
  mpv \
  gimp \
  git \
  gnome-extensions-app \
  gnome-tweaks \
  inkscape \
  obs-studio \
  snapd \
  python3-pip \
  neovim \
  gparted \
  tmux \
  make \
  gcc \
  ripgrep \
  fd-find \
  git-delta

printf "\n★ installing vscode\n"
if ! command -v code $ >/dev/null; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  sudo dnf makecache
  sudo dnf install -y code
fi

printf "\n★ installing fnm and node\n"
if ! command -v fnm $ >/dev/null; then
  curl -fsSL https://fnm.vercel.app/install | bash
  fnm install --lts
fi

printf "\n★ installing bun\n"
if ! command -v bun $ >/dev/null; then
  curl -fsSL https://bun.sh/install | bash
fi

printf "\n★ installing docker\n"
if ! command -v docker $ >/dev/null; then
  curl -fsSL https://get.docker.com | bash
fi

printf "\n★ installing github cli\n"
if ! command -v gh $ >/dev/null; then
  sudo dnf install -y 'dnf-command(config-manager)'
  sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install -y gh
fi

printf "\n★ installing snap packages\n"
if [ ! -d "/snap" ]; then
  sudo ln -s "/var/lib/snapd/snap" "/snap"
fi
sudo snap install skype
sudo snap install motrix
sudo snap install mysql-workbench-community
sudo snap install breaktimer
sudo snap install spotify
sudo snap install telegram-desktop
sudo snap install obsidian --classic

printf "\n★ installing pipx\n"
if ! command -v pipx $ >/dev/null; then
  python3 -m pip install --user pipx
  python3 -m pipx ensurepath
fi

printf "\n★ installing pipx packages\n"
if ! command -v spotdl $ >/dev/null; then
  pipx install spotdl
fi

printf "\n★ installing gnome extensions\n"
if ! command -v gext $ >/dev/null; then
  pipx install gnome-extensions-cli --system-site-packages
fi
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
  window-app-switcher-on-active-monitor@NiKnights.com

printf "\n★ changing gnome settings\n"
settings=(
  "org.gnome.TextEditor spellcheck false"
  "org.gnome.calculator show-thousands true"
  "org.gnome.desktop.input-sources sources [('xkb','us'),('xkb','ir')]"
  "org.gnome.desktop.input-sources per-window true"
  "org.gnome.desktop.input-sources xkb-options ['caps:escape_shifted_capslock']"
  "org.gnome.desktop.interface clock-format '12h'"
  "org.gnome.desktop.interface clock-show-seconds true"
  "org.gnome.desktop.interface color-scheme 'prefer-dark'"
  "org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"
  "org.gnome.desktop.peripherals.touchpad natural-scroll false"
  "org.gnome.desktop.peripherals.touchpad tap-to-click true"
  "org.gnome.desktop.search-providers disabled ['org.gnome.Characters.desktop']"
  "org.gnome.desktop.wm.keybindings activate-window-menu []"
  "org.gnome.desktop.wm.keybindings minimize []"
  "org.gnome.desktop.wm.keybindings move-to-monitor-down ['<Shift><Super>j']"
  "org.gnome.desktop.wm.keybindings move-to-monitor-left []"
  "org.gnome.desktop.wm.keybindings move-to-monitor-right []"
  "org.gnome.desktop.wm.keybindings move-to-monitor-up ['<Shift><Super>k']"
  "org.gnome.desktop.wm.keybindings move-to-workspace-left ['<Shift><Super>h']"
  "org.gnome.desktop.wm.keybindings move-to-workspace-right ['<Shift><Super>l']"
  "org.gnome.desktop.wm.keybindings switch-applications []"
  "org.gnome.desktop.wm.keybindings switch-applications-backward []"
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
  "org.gnome.rhythmbox.plugins seen-plugins ['grilo','rb','webremote','replaygain','rbzeitgeist','pythonconsole','notification','mtpdevice','ipod','fmradio','dbus-media-server','daap','cd-recorder','audioscrobbler','artsearch','im-status','listenbrainz','lyrics','magnatune']"
  "org.gnome.rhythmbox.rhythmdb locations ['file://$HOME/Music']"
  "org.gnome.settings-daemon.plugins.media-keys next ['<Super>F12']"
  "org.gnome.settings-daemon.plugins.media-keys play ['<Super>F10']"
  "org.gnome.settings-daemon.plugins.media-keys previous ['<Super>F11']"
  "org.gnome.settings-daemon.plugins.media-keys screensaver []"
  "org.gnome.shell favorite-apps ['firefox.desktop','org.gnome.Nautilus.desktop','org.gnome.Terminal.desktop','code.desktop','telegram-desktop_telegram-desktop.desktop']"
  "org.gnome.shell.app-switcher current-workspace-only true"
  "org.gnome.shell.keybindings open-application-menu []"
  "org.gnome.tweaks show-extensions-notice false"
  "org.gtk.Settings.FileChooser clock-format '12h'"
)
for setting in "${settings[@]}"; do
  # TODO: use eval here
  gsettings set $setting
done

printf "\n★ adding fonts\n"
mkdir "$HOME/.local/share/fonts"
ln -s "$PWD"/.fonts/* "$HOME/.local/share/fonts"

printf "\n★ changing dconf settings\n"
dconfSettings=(
  "font \"'VazirCodeHack Nerd Font 14'\""
  "custom-command \"'zsh'\""
  "use-custom-command \"true\""
  "use-system-font \"false\""
)
for setting in "${dconfSettings[@]}"; do
  eval "dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/$setting"
done

printf "\n★ setup zsh\n"
if command -v zsh $ >/dev/null; then
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
  rm "$HOME/.zshrc" "$HOME/.aliases" "$HOME/.functions"
fi

ln -s "$PWD/.zshrc" "$HOME/.zshrc"
ln -s "$PWD/.aliases" "$HOME/.aliases"
ln -s "$PWD/.functions" "$HOME/.functions"

if command -v fnm $ >/dev/null; then
  fnm completions --shell zsh | create "$HOME/.oh-my-zsh/completions/_fnm"
fi

printf "\n★ setup git\n"
rm "$HOME/.gitconfig"
ln -s "$PWD/.gitconfig" "$HOME/.gitconfig"

printf "\n★ setup tmux\n"
ln -s "$PWD/.tmux.conf" "$HOME/.tmux.conf"
tpmFile="$HOME/.tmux/plugins/tpm"
if ! test -f "$tpmFile"; then
  git clone https://github.com/tmux-plugins/tpm "$tpmFile"
fi

printf "\n★ setup neovim\n"
initLuaFile="$HOME/.config/nvim/init.lua"
if ! test -f "$initLuaFile"; then
  mkdir -p "$HOME/.config/nvim"
  ln -s "$PWD/init.lua" "$initLuaFile"
fi

printf "\n★ setup lazygit\n"
if ! command -v lazygit $ >/dev/null; then
  ln -s "$PWD/lazygit.yml" "$HOME/.config/lazygit/config.yml"
  sudo dnf copr enable atim/lazygit -y
  sudo dnf install lazygit -y
fi

printf "\n★ setup idea\n"
ln -s "$PWD/.ideavimrc" "$HOME/.ideavimrc"

printf "\n★ interactive session ★\n"

#!/usr/bin/env bash

set -e

sudo pacman -S --needed git base-devel

if ! command -v yay >/dev/null; then
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
    cd ..
    rm -rf yay-bin
fi

timedatectl set-timezone Europe/Berlin

yay -Sy --needed --noconfirm --sudoloop archlinux-keyring
yay -Syu --noconfirm --sudoloop

# yay -S --needed hyprwayland-scanner-git
yay -S --needed --sudoloop --noconfirm \
    nvidia-dkms \
    linux \
    linux-headers \
    libva \
    libva-nvidia-driver-git \
    sddm \
    seatd \
    hyprland \
    pipewire \
    wireplumber \
    qt5-wayland \
    qt5ct \
    qt5-styleplugins \
    qt6-wayland \
    qt6ct \
    qt6gtk2 \
    qt6-svg \
    qt6-declarative \
    xdg-desktop-portal \
    xdg-desktop-portal-hyprland \
    wofi \
    alacritty \
    cliphist \
    dante \
    dnsmasq \
    docker \
    docker-buildx \
    fd \
    fzf \
    github-cli \
    firefox \
    google-chrome \
    go-yq \
    httpie \
    hyprpicker \
    jq \
    k9s \
    keepassxc \
    lazygit \
    less \
    man-db \
    man-pages \
    mise \
    neofetch \
    neovim \
    network-manager-applet \
    nm-connection-editor \
    python-gobject \
    python-pyqt6 \
    qemu-desktop \
    ripgrep \
    ruby \
    scdoc \
    solaar \
    tlrc \
    tmux \
    tree \
    ttf-font-awesome \
    ttf-meslo-nerd \
    ttf-ubuntu-nerd \
    vim \
    waybar \
    wl-clipboard \
    wlr-randr \
    zip unzip \
    zsh \
    wireshark-qt \
    nwg-look \
    polkit-gnome \
    libvirt \
    virt-manager \
    gvfs \
    thunar \
    thunar-volman \
    bottom \
    gtk-engine-murrine \
    gnome-themes-extra \
    hyprlock \
    hypridle \
    hyprpaper \
    libvips \
    rsync \
    kubectl \
    kubectx \
    helm \
    cilium-cli \
    k3d \
    go-task \
    kubeseal \
    noto-fonts-emoji \
    noto-fonts \
    spotify-launcher \
    swayosd-git \
    firewalld \
    grim \
    slurp \
    nmap \
    p7zip \
    ttf-ms-win11-auto \
    imv \
    azure-kubelogin \
    azure-cli \
    discord \
    python-pynvim \
    tesseract-data-eng \
    tesseract-data-deu \
    zathura \
    zathura-pdf-mupdf \
    python-pysocks \
    webapp-manager \
    golangci-lint \
    git-credential-manager \
    yt-dlp \
    postgresql-client \
    eza \
    lazydocker \
    tumbler \
    swappy \
    pavucontrol \
    icoextract \
    thunar-archive-plugin \
    file-roller \
    gvfs-mtp \
    android-file-transfer \
    bluez \
    blueman \
    teams-for-linux \
    gnome-disk-utility \
    ldns \
    aria2 \
    argocd \
    mktorrent \
    nvtop \
    whois \
    flatpak \
    flatseal \
    aylurs-gtk-shell \
    gnome-bluetooth-3.0 \
    brightnessctl \
    heroic-games-launcher-bin \
    cmake \
    ninja \
    meson \
    docker-compose \
    easyeffects \
    libdeep_filter_ladspa-bin \
    mission-center \
    gnome-calculator \
    parabolic \
    bat \
    mpv \
    gcolor3 \
    valgrind \
    git-delta \
    vulkan-devel \
    tree-sitter-cli \
    grimblast-git \
    evince \
    hyprshot \
    sane \
    sane-airscan \
    simple-scan \
    cups \
    nautilus \
    wayfreeze-git \
    satty

# mise use -g node@20
mise use -g java@corretto-17
# mise use -g go@1.21
# mise use -g rust
mise use -g usage

# yay -S --sudoloop --noconfirm

chsh -s $(which zsh)

sudo usermod -aG docker "$USER"
sudo usermod -aG wireshark "$USER"
sudo usermod -aG disk "$USER"

sudo systemctl enable --now libvirtd.socket
sudo systemctl enable --now docker.socket
sudo systemctl enable --now cups.socket
sudo systemctl enable --now avahi-daemon.socket
sudo systemctl enable --now sddm.service
# sudo systemctl enable --now swayosd-libinput-backend.service
sudo systemctl enable --now seatd

sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

sudo ln -s /usr/bin/alacritty /usr/bin/xterm
# sudo ln -s /usr/bin/go-task /usr/bin/task

# yay -S --sudoloop --noconfirm firewalld

sudo systemctl enable --now firewalld.service

sudo firewall-cmd --permanent --add-service=sane
sudo firewall-cmd --permanent --add-service=mdns

git-credential-manager configure

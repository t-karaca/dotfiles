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

yay -Sy --needed archlinux-keyring
yay -Syu

# yay -S --needed hyprwayland-scanner-git
yay -S --needed \
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
    go-task-bin \
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
    bat \
    git-delta

if [ "1" = "0" ]; then
    yay -S --needed \
        lib32-nvidia-utils \
        lib32-alsa-lib \
        lib32-alsa-plugins \
        lib32-libpulse \
        lib32-pipewire \
        steam \
        bottles \
        wine
fi

if [ "1" = "0" ]; then
    yay -S --needed \
        texlive-basic \
        texlive-latex \
        texlive-latexrecommended \
        texlive-latexextra \
        texlive-fontsrecommended \
        texlive-plaingeneric \
        texlive-bibtexextra \
        texlive-mathscience \
        texlive-xetex \
        texlive-binextra \
        texlive-langgerman \
        biber
fi

# curl https://fedoraproject.org/fedora.gpg | gpg --import
# yay -S butane-bin

mise use -g node@20
mise use -g java@corretto-17
mise use -g go@1.21
mise use -g rust
mise use -g usage

chsh -s $(which zsh)

sudo usermod -aG docker "$USER"
sudo usermod -aG wireshark "$USER"

sudo systemctl enable --now sddm.service
sudo systemctl enable --now libvirtd.socket
sudo systemctl enable --now docker.socket
# sudo systemctl enable --now swayosd-libinput-backend.service
sudo systemctl enable --now seatd

sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

sudo ln -s /usr/bin/alacritty /usr/bin/xterm
# sudo ln -s /usr/bin/go-task /usr/bin/task

git-credential-manager configure

if ! command -v grimblast >/dev/null; then
    git clone https://github.com/hyprwm/contrib.git
    cd contrib/grimblast

    sudo make install

    cd ../..
    rm -rf contrib
fi

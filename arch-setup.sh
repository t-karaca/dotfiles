#!/usr/bin/env bash

set -e

sudo pacman -S --needed git base-devel

if ! command -v yay >/dev/null; then
	git clone https://aur.archlinux.org/yay-bin.git
	cd yay-bin
	makepkg -si
fi

sudo pacman -R hyprland || true

yay -S \
	sddm \
	nvidia-dkms \
	linux \
	linux-headers \
	hyprwayland-scanner-git \
	hyprland-git \
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
	libva \
	libva-nvidia-driver-git

# echo "options nvidia-drm modeset=1" >>/etc/modprobe.d/nvidia.conf
echo "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf

# add 'nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1" to options in /boot/loader/entries/arch.conf
# MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm) in /etc/mkinitcpio.conf

sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img

timedatectl set-timezone Europe/Berlin

yay -Sy archlinux-keyring
yay -Syu

yay -S \
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
	google-chrome \
	go-yq \
	httpie \
	hyprpicker-git \
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
	catppuccin-gtk-theme-mocha \
	polkit-gnome \
	libvirt \
	virt-manager \
	gvfs \
	thunar \
	thunar-volman \
	bottom \
	gtk-engine-murrine \
	gnome-themes-extra \
	qalculate-gtk \
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
	spotify-launcher \
	swayosd-git \
	firewalld

mise use -g node@20
mise use -g node@corretto-17
mise use -g go@1.21
mise use -g rust
mise use -g usage

chsh -s $(which zsh)

sudo usermod -aG docker "$USER"
sudo usermod -aG wireshark "$USER"
sudo systemctl enable --now libvirtd.socket
sudo systemctl enable --now docker.socket
sudo systemctl enable --now swayosd-libinput-backend.service

systemctl enable --force --now seatd

gh auth login

sudo ln -s /usr/bin/alacritty /usr/bin/xterm
sudo ln -s /usr/bin/go-task /usr/bin/task

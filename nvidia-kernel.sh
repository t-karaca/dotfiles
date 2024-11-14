#!/usr/bin/env bash

# echo "options nvidia-drm modeset=1" >>/etc/modprobe.d/nvidia.conf
echo "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf

# add 'nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1 nvidia.NVreg_EnableGpuFirmware=0" to options in /boot/loader/entries/arch.conf
# MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm) in /etc/mkinitcpio.conf

sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-nvidia.img

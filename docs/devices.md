# devices

## device config

location: devices/{device}

- ROOTFMT: root partition type, ext4 or fat32
- BOOTFMT: boot partition type, ext4 or fat32
- NORESIZE: do not shrink root partition on creation
- NOGROWROOT: do not set systemd grow in fstab for root partition for resize2fs
- NOREPARTROOT: do not set systemd-repart to expand root partition in GPT
- NOTAILSPACE: do not add tail space (256M) to the end of root partition
- TARGET_DEVICE: device name
- TARGET_ARCH: device arch, same as deepin repo
- DISKSIZE: root disk size, may reduced later
- BOOTSIZE: boot disk size, 0 to disable boot partition
- PKGPROFILE: package list profile
- REPOPROFILE: repo list profile
- BOOTLOADER: bootloader type, grub or extlinux, unset to disable bootloader
- IMGGPU: add img gpu driver, must be ddk*
- AMDGPU: use external gpu, allows desktop effects
- COMPONENTS: component in repo, usually beige
- EXTRAPKGS: extra packages to install, seperated by ','
- IMGPROFILE: full image profile, unset to disable image generation

## device hooks

location: devices/{device}-hooks/{hook}

executed after global hooks

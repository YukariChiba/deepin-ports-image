# devices

## device config

location: `devices/{device}`

- `ROOTFMT`: root partition type, ext4 or fat32 or tarball
- `BOOTFMT`: boot partition type, ext4 or fat32
- `NOGROWROOT`: do not set systemd grow in fstab for root partition for resize2fs
- `NOREPARTROOT`: do not set systemd-repart to expand root partition in GPT
- `NOTAILSPACE`: do not add tail space (256M) to the end of root partition
- `TAILSPACE`: 256M by default
- `TARGET_DEVICE`: device name
- `TARGET_ARCH`: device arch, same as deepin repo
- `DISKSIZE`: root disk size, may reduced later
- `BOOTSIZE`: boot disk size, 0 to disable boot partition
- `PKGPROFILE`: package list profile
- `REPOPROFILE`: repo list profile
- `BOOTLOADER`: bootloader type, currently extlinux only, unset to disable bootloader
- `COMPONENTS`: component in repo, usually beige
- `EXTRAPKGS`: extra packages to install, seperated by ','
- `IMGPROFILE`: full image profile, unset to disable image generation

## device hooks

location: `devices/{device}-hooks/{hook}`

executed after global hooks

# Binary Injection

## Bootloader

Location: `injectbin/bootloaders/{device}`

Bootloaders to be used in genimage

## Kernel

### Binary Kernel modules

Location: `injectbin/kernelbin/{device}/modules`

Kernel modules, installed to `/lib/modules/`

### Kernel boot files

Location: `injectbin/kernelbin/{device}/boot`

Kernel boot files, installed to `/boot`

### Deb Kernel

Location: `injectbin/kerneldeb/{device}/*.deb`

Binary debian kernel to install, dtb will be extracted to `/boot/dtbs/linux-image-*`

## Extra Packages

Location: `injectbin/extradeb/{device}/*.deb`

Extra deb packages to install

## Firmwares

Location: `injectbin/firmwares/{device}`

Contents added to `/lib/firmwares/`

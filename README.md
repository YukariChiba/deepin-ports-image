# deepin-ports image creation tool

Currently works with:

- LicheePi 4A

## Usage

- Download latest kernel image (with dtb) to `linux-image.deb`
- Place firmware files into bootbin (currently lpi4a)
- Flash uboot image to lpi4a
- Use `mkimg-noconf{,-minimal}.sh` to create boot image and flash boot/root image

## TODO

- customized kernel deb url
- device-specific boot binary folders
- device-spefific flashing methods


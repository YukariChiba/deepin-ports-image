# deepin-ports image creation tool

Currently works with:

- LicheePi 4A
- Phytium Pi
- DC ROMA

## Usage

- Download latest kernel image (with dtb) to `linux-image.deb`
- Download uboot image
- Place firmware files into bootbin (currently lpi4a)
- Use `mkimg-noconf{,-minimal}.sh` to create boot/root image
- Use `flash_fastboot.sh` to flash uboot/boot/root image

## TODO

- customized kernel deb url


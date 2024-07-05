# deepin-ports image creation tool

For supported devices, check `./devices/`.

Non-free `injectbin` submodule is needed for some boards

## Usage

```
COMPRESS=1 # set if compressed tar.xz file is needed
./build.sh {device}
```

## Dependency

- mmdebstrap
- systemd-container
- systemd-binfmt
- qemu-user-static

## Docs

See `./docs/`.

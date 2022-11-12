# Cross compiling with Clang & CMake

**This is an example project, that demonstrates Clang cross compiling in combination with CMake.**

The Clang toolchain is an inherent cross compiler. It can target multiple platforms like _aarch64_ Linux or _x86_ Windows, while running on _x86_ Linux or on _ARM64_ macOS hosts.

Clang includes a versatile linker called **lld**, that allows building binaries in multiple executable formats, like *ELF*, *PE*, *Mach-O* and others.

## Prerequisites

* Clang, the community build. (Apple's version does not include the `lld` linker.)
* A target system *sysroot*, meaning the targets *libc*, *libstdc++* and *libgcc*. And all their header files.
* CMake

(On macOS use `brew` to install the community's *clang* variant.)

## Build

```sh
$ mkdir build && cd build
$ cmake --toolchain ../toolchain-aarch64-linux-clang.cmake ..
$ cmake --build .
```

This will build and link an executable `test`, that is build for *aarch64* Linux, targeting the *libc* you provided in the *sysroot*.

> Note, the toolchain file contains hard references to file paths for clang and sysroot. You will probably have to change these.
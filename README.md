# ARM-Linux-Gnueabihf GCC 4.9.4 (Linaro 2017.01) for Apple Silicon

This project provides a reliable method to natively compile the **Linaro GCC 4.9.4** toolchain on **Apple Silicon (M1/M2/M3) Mac** using OrbStack or Docker.

## Background

Embedded development for boards like **i.MX6ULL (Cortex-A9)** often requires the specific GCC 4.9.4 version. Official pre-built binaries are only available for `x86_64`, which suffer from performance lag and compatibility issues when running via Rosetta 2 on macOS.

This solution builds a **Native ARM64 (AArch64)** toolchain that runs directly on Apple Silicon, offering superior performance and a directory structure 99% aligned with the official Linaro release.

## Built With

- **[crosstool-NG (v1.24.0)](https://github.com/crosstool-ng/crosstool-ng)**: A versatile (multi-platform) toolchain generator. It provides the essential patches and build scripts to compile legacy GCC versions on modern systems.
- **Docker / OrbStack**: Used to provide a consistent **Ubuntu 16.04 (ARM64)** build environment, bypassing macOS filesystem and host compiler limitations.

## Toolchain Specifications

- **Host**: `aarch64-apple-darwin` (Running in `arm64v8/ubuntu:16.04` container)
- **Target**: `arm-linux-gnueabihf`
- **GCC Version**: `4.9.4 (Linaro 2017.01)`
- **Optimization**:
  - Arch: `armv7-a`
  - CPU: `cortex-a9`
  - FPU: `vfpv3-d16`
  - Float: `hard`
  - Mode: `thumb`

## Critical Fixes for Apple Silicon

To successfully compile this legacy toolchain on ARM64, the following configurations are applied:

1. **Case-Sensitivity**: Compilation MUST occur within the container's internal filesystem. Compiling in a macOS-mounted directory (`-v`) will fail due to `.bss` section errors caused by case-insensitivity.
2. **ISL Library**: Graphite loop optimizations are disabled (`--with-isl=no`) because legacy ISL versions (0.15) do not recognize the `aarch64` architecture.

## How to Build

This project utilizes **crosstool-NG** as the core engine to manage the complex GCC build process:

1. **Environment Setup**: Build the Docker image which contains the `ct-ng` source and all necessary dependencies.
2. **Configuration**: The provided `.config` file contains the precise parameters (CPU, FPU, Vendor, etc.) to match the official Linaro toolchain.
3. **Execution**: Running `./ct-ng build` inside the container triggers the automated fetching, patching, and cross-compilation of GCC 4.9.4.

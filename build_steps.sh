#!/bin/bash

# Define paths
MOUNT_DIR="~/x-tools-mac" # Local Mac directory for persistent storage
CONFIG_FILE="arm-linux-gnueabihf-4.9.4.config"

# 1. Run the builder container
docker run -it --platform linux/arm64 \
    -v ${MOUNT_DIR}:/build \
    arm-gcc-builder /bin/bash -c "
        # Copy ct-ng to internal fast/case-sensitive storage
        cp -r /root/crosstool-ng /root/workspace && cd /root/workspace;
        
        # Load your fine-tuned crosstool-NG configuration
        cp /build/${CONFIG_FILE} .config;
        
        # Trigger the automated build process
        ./ct-ng build;
        
        echo '----------------------------------------------------------'
        echo 'Build Finished! Toolchain is located in /build/arm-gcc-4.9.4'
    "

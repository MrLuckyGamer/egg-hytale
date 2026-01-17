#!/bin/bash

detect_architecture() {
    local ARCH=$(uname -m)
    logger info "Platform: $ARCH"

    case "$ARCH" in
        x86_64)
            DOWNLOADER="./hytale-downloader-linux-amd64"
            ;;
        aarch64|arm64)
            DOWNLOADER="./hytale-downloader-linux-arm64"
            ;;
        *)
            logger error "Unsupported architecture: $ARCH"
            logger info "Supported architectures: x86_64 (amd64), aarch64/arm64"
            exit 1
            ;;
    esac
}

setup_environment() {
    # Get and export timezone
    export TZ=${TZ:-UTC}

    # Get and export the internal docker ip
    export INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')

    # Goto working directory
    cd /home/container || exit 1
}

setup_backup_directory() {
    if [ ! -d "backup" ]; then
        logger info "Backup directory does not exist. Creating it..."
        mkdir -p backup
        if [ $? -ne 0 ]; then
            logger error "Failed to create backup directory: /backup"
            exit 1
        fi
    fi
    chmod -R 755 backup
}

enforce_permissions() {
    if [ "$ENFORCE_PERMISSIONS" = "1" ]; then
        logger warn "Enforcing permissions... This might take a while. Please be patient."
        find . -type d -exec chmod 755 {} \;
        find . -type f \
            ! -name "hytale-downloader-linux-amd64" \
            ! -name "hytale-downloader-linux-arm64" \
            ! -name "start.sh" \
            -exec chmod 644 {} \;
        logger success "Permissions enforced (files: 644, folders: 755)"
    fi
}
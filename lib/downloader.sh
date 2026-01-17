#!/bin/bash

ensure_downloader() {
    if [ ! -f "$DOWNLOADER" ]; then
        logger error "Hytale downloader not found!"
        logger error "Please run the installation script first."
        exit 1
    fi

    if [ ! -x "$DOWNLOADER" ]; then
        logger info "Setting executable permissions for downloader..."
        chmod +x "$DOWNLOADER"
    fi
}

run_update_process() {
    local INITIAL_SETUP=0

    # Check if credentials file exists, if not run the updater
    if [ ! -f "$DOWNLOAD_CRED_FILE" ]; then
        INITIAL_SETUP=1
        logger warn "Credentials file not found, running initial setup..."
        logger info "Downloading server files..."

        $DOWNLOADER -check-update

        echo " "
        printc "{MAGENTA}╔══════════════════════════════════════════════════════════════════════════════════════╗"
        printc "{MAGENTA}║  {BLUE}NOTE: You must have purchased Hytale on the account you are using to authenticate.  {MAGENTA}║"
        printc "{MAGENTA}╚══════════════════════════════════════════════════════════════════════════════════════╝"
        echo " "

        if ! $DOWNLOADER -patchline $PATCHLINE -download-path server.zip; then
            echo ""
            logger error "Failed to download Hytale server files."
            logger warn "Removing invalid credential file..."
            rm -f $DOWNLOAD_CRED_FILE
            exit 1
        fi

        # Save version info after initial setup
        local DOWNLOADER_VERSION=$($DOWNLOADER -print-version 2>&1)
        if [ $? -eq 0 ] && [ -n "$DOWNLOADER_VERSION" ]; then
            echo "$DOWNLOADER_VERSION" > $VERSION_FILE
            logger success "Saved version info!"
        fi

        extract_server_files
    fi

    # Run automatic update if enabled
    if [ "$AUTOMATIC_UPDATE" = "1" ] && [ "$INITIAL_SETUP" = "0" ]; then
        logger info "Checking for updates..."

        local LOCAL_VERSION=""
        if [ -f "$VERSION_FILE" ]; then
            LOCAL_VERSION=$(cat $VERSION_FILE)
        else
            logger warn "Version file not found, forcing update"
        fi

        local DOWNLOADER_VERSION=$($DOWNLOADER -print-version 2>&1)

        if [ $? -ne 0 ] || [ -z "$DOWNLOADER_VERSION" ]; then
            logger error "Failed to get downloader version."
            exit 1
        else
            if [ -n "$LOCAL_VERSION" ]; then
                logger info "Local version: $LOCAL_VERSION"
            fi
            logger info "Downloader version: $DOWNLOADER_VERSION"

            if [ "$LOCAL_VERSION" != "$DOWNLOADER_VERSION" ]; then
                logger warn "Version mismatch, running update..."
                $DOWNLOADER -check-update
                $DOWNLOADER -patchline $PATCHLINE -download-path server.zip
                echo "$DOWNLOADER_VERSION" > $VERSION_FILE
                logger success "Saved version info!"
                extract_server_files
            else
                logger info "Versions match, skipping update"
            fi
        fi
    fi
}

validate_server_files() {
    if [ ! -f "HytaleServer.jar" ]; then
        logger error "HytaleServer.jar not found!"
        logger error "Server files were not downloaded correctly."
        exit 1
    fi
}
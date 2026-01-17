# Use Eclipse Temurin JDK 25 on Ubuntu Noble as the base image
FROM --platform=$TARGETOS/$TARGETARCH eclipse-temurin:25-jdk-noble

# Metadata
LABEL author="NATroutter" maintainer="contact@natroutter.fi"
LABEL org.opencontainers.image.source="https://github.com/NATroutter/egg-hytale"
LABEL org.opencontainers.image.description="Container for running hytale game servers"
LABEL org.opencontainers.image.licenses=MIT

# Switch to root user for installation
USER root

# Install necessary dependencies
RUN apt update -y \
	&& apt install -y \
	curl \
	lsof \
	ca-certificates \
	openssl \
	git \
	tar \
	sqlite3 \
	fontconfig \
	tzdata \
	iproute2 \
	libfreetype6 \
	tini \
	zip \
	unzip \
	ncurses-bin \
	jq

# Copy start.sh to /usr/local/bin (protected location, won't be overridden by volume mounts)
COPY --chmod=755 ./start.sh /usr/local/bin/start.sh

# Strip Windows line endings (\r) just in case the file was edited on Windows
RUN sed -i 's/\r$//' /usr/local/bin/start.sh

# Copy entrypoint script to root
COPY --chmod=755 ./entrypoint.sh /entrypoint.sh

# Strip Windows line endings (\r) just in case the file was edited on Windows
RUN sed -i 's/\r$//' /entrypoint.sh

# Create egg-hytale folder
RUN mkdir -p /egg-hytale

# Copy lib directory
COPY --chmod=755 ./lib /egg-hytale/lib
RUN sed -i 's/\r$//' /egg-hytale/lib/*.sh

# Create dmidecode shim for Docker usage
RUN echo "Creating local dmidecode for Docker usage." && \
    cat > /usr/local/bin/dmidecode << 'EOF'
#!/bin/sh
if [ "$1" = "-s" ] && [ "$2" = "system-uuid" ]; then
    UUID_FILE="$HOME/.hytale_system_uuid"

    if [ -f "$UUID_FILE" ]; then
        cat "$UUID_FILE"
    else
        if command -v uuidgen >/dev/null 2>&1; then
            uuidgen | tr "A-Z" "a-z" | tee "$UUID_FILE" >/dev/null
        else
            cat /proc/sys/kernel/random/uuid | tee "$UUID_FILE" >/dev/null
        fi
        cat "$UUID_FILE"
    fi

    printf "\n"
    exit 0
fi

echo "dmidecode shim: unsupported args: $*" >&2
exit 1
EOF
RUN chmod +x /usr/local/bin/dmidecode
RUN sed -i 's/\r$//' /entrypoint.sh

# Create the container user
RUN useradd -m -d /home/container -s /bin/bash container

# Switch to the container user
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

# Ensure clean shutdown
STOPSIGNAL SIGINT

# Use tini as init process to handle signals correctly
ENTRYPOINT    ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]

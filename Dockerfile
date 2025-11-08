FROM alpine:latest

ARG TARGETARCH
ARG TARGETVARIANT
ARG SUPERCRONIC_VERSION=v0.2.38

# Install dependencies
RUN apk add --no-cache ca-certificates curl tzdata

# Download and install supercronic based on architecture
RUN set -ex; \
    case "${TARGETARCH}${TARGETVARIANT}" in \
        amd64) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-amd64"; \
            SUPERCRONIC_SHA256SUM="bc072eba2ae083849d5f86c6bd1f345f6ed902d0"; `# amd64` \
            ;; \
        arm64) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-arm64"; \
            SUPERCRONIC_SHA256SUM="37842646e4c95b193c469afae400966565c383d3"; `# arm64` \
            ;; \
        armv7) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-arm"; \
            SUPERCRONIC_SHA256SUM="510b84b031b78ebe25b1f00c91ced3434edcd383"; `# arm` \
            ;; \
        386) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-386"; \
            SUPERCRONIC_SHA256SUM="86ed618afdcd554dc80242691af861941f826a86"; `# 386` \
            ;; \
        *) \
            echo "Unsupported architecture: ${TARGETARCH}${TARGETVARIANT}"; \
            exit 1; \
            ;; \
    esac; \
    curl -fsSL "${SUPERCRONIC_URL}" -o /usr/local/bin/supercronic; \
    echo "${SUPERCRONIC_SHA256SUM}  /usr/local/bin/supercronic" | sha256sum -c -; \
    chmod +x /usr/local/bin/supercronic

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create directory for crontab
RUN mkdir -p /etc/crontabs

ENTRYPOINT ["/entrypoint.sh"]

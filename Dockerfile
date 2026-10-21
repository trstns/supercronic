FROM alpine:latest

ARG TARGETARCH
ARG TARGETVARIANT
ARG SUPERCRONIC_VERSION=v0.2.51

# Install dependencies
RUN apk add --no-cache ca-certificates curl tzdata

# Download and install supercronic based on architecture
RUN set -ex; \
    case "${TARGETARCH}${TARGETVARIANT}" in \
        amd64) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-amd64"; \
            SUPERCRONIC_SHA256SUM="cc232108374e8e2b537045f2d5eaa1229f619db314c3ba6a14d38b35dc0aa123"; `# amd64` \
            ;; \
        arm64) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-arm64"; \
            SUPERCRONIC_SHA256SUM="4ae22576a78223d8ccdf5f3b3660a5cbb5288416bf0ca96afc4a36d195932b94"; `# arm64` \
            ;; \
        armv7) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-arm"; \
            SUPERCRONIC_SHA256SUM="cf8722c97a14d07f1dfa405ea8ce436de828cd4bf51f607c6d254d252400f355"; `# arm` \
            ;; \
        386) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-386"; \
            SUPERCRONIC_SHA256SUM="2f22af4b2f83e8b616bce06fef2da246157ab5ac3e85d3b52f6885abdc18dca3"; `# 386` \
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

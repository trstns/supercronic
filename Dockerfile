FROM alpine:latest

ARG TARGETARCH
ARG TARGETVARIANT
ARG SUPERCRONIC_VERSION=v0.2.48

# Install dependencies
RUN apk add --no-cache ca-certificates curl tzdata

# Download and install supercronic based on architecture
RUN set -ex; \
    case "${TARGETARCH}${TARGETVARIANT}" in \
        amd64) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-amd64"; \
            SUPERCRONIC_SHA256SUM="88c1b66b94c486f972fdd1a4d1f901e3e75ff04f749cddd60c5db573e3a33c6c"; `# amd64` \
            ;; \
        arm64) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-arm64"; \
            SUPERCRONIC_SHA256SUM="50ae8755e04fa72812d0a1bc47a112a856811cc91cce7b6c875c378a850788bc"; `# arm64` \
            ;; \
        armv7) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-arm"; \
            SUPERCRONIC_SHA256SUM="8a2eb0edfccd55778e006c33d69e9634f4ef42a73053d6522e79292f70029134"; `# arm` \
            ;; \
        386) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-386"; \
            SUPERCRONIC_SHA256SUM="100971e7f36d6a70f1cf30cfcb05bf0949716e6828923b0d906082204ad6a546"; `# 386` \
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

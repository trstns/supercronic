FROM alpine:latest

ARG TARGETARCH
ARG TARGETVARIANT
ARG SUPERCRONIC_VERSION=v0.2.46

# Install dependencies
RUN apk add --no-cache ca-certificates curl tzdata

# Download and install supercronic based on architecture
RUN set -ex; \
    case "${TARGETARCH}${TARGETVARIANT}" in \
        amd64) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-amd64"; \
            SUPERCRONIC_SHA256SUM="5adff01c5a797663948e656d2b61d10932369ee437eb5cb54fa872b2960f222b"; `# amd64` \
            ;; \
        arm64) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-arm64"; \
            SUPERCRONIC_SHA256SUM="c0576a8eb092e3f79108ed0a2155a25c7766af78456e5a6070e54757ef513bfe"; `# arm64` \
            ;; \
        armv7) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-arm"; \
            SUPERCRONIC_SHA256SUM="e7127c16dda0a215338661128e0541040b039041867d5de67bd6daca9691a083"; `# arm` \
            ;; \
        386) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-386"; \
            SUPERCRONIC_SHA256SUM="5c48011fb66b9a9d505850f09a9013cfdd1a286347adb13a6398199dd996487e"; `# 386` \
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

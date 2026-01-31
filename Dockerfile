FROM alpine:latest

ARG TARGETARCH
ARG TARGETVARIANT
ARG SUPERCRONIC_VERSION=v0.2.42

# Install dependencies
RUN apk add --no-cache ca-certificates curl tzdata

# Download and install supercronic based on architecture
RUN set -ex; \
    case "${TARGETARCH}${TARGETVARIANT}" in \
        amd64) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-amd64"; \
            SUPERCRONIC_SHA256SUM="810885e14bce16b48f954f36c22946483617658cfc8a721db1f76dbeae66c897"; `# amd64` \
            ;; \
        arm64) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-arm64"; \
            SUPERCRONIC_SHA256SUM="fef82735732ba808b079ddb57395d5c9c12862a2fdfd1564f0e11c95543d4b08"; `# arm64` \
            ;; \
        armv7) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-arm"; \
            SUPERCRONIC_SHA256SUM="4421818bd3791f14e137e7c18334d4360a5018774f48142500cd1400a1c7791b"; `# arm` \
            ;; \
        386) \
            SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-386"; \
            SUPERCRONIC_SHA256SUM="174161b5048af79c05b1e0b5c981bf8df0fe53fe331ba49644ab00f3736d77f2"; `# 386` \
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

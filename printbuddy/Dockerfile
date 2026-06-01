ARG RUNTIME_FROM=python:3.12-slim-bookworm

FROM node:22-bookworm-slim AS printbuddy-src
ARG PRINTBUDDY_REF=dev
WORKDIR /src

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl tar \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://github.com/vmhomelab/Printbuddy/archive/${PRINTBUDDY_REF}.tar.gz" \
    | tar -xz --strip-components=1

WORKDIR /src/frontend
RUN --mount=type=cache,target=/root/.npm npm ci
RUN npm run build

FROM ${RUNTIME_FROM}
ARG PRINTBUDDY_REF=dev

LABEL \
    io.hass.name="Printbuddy" \
    io.hass.description="Self-hosted 3D printer management for Bambu Lab, Klipper, and Mainsail/Moonraker printers" \
    io.hass.type="addon" \
    io.hass.version="0.1.3" \
    maintainer="Marko Buculovic <info@vmhomelab.de>" \
    org.opencontainers.image.title="Printbuddy Home Assistant Add-on" \
    org.opencontainers.image.description="Home Assistant add-on wrapper for Printbuddy" \
    org.opencontainers.image.source="https://github.com/vmhomelab/printbuddy-ha-addon" \
    org.opencontainers.image.licenses="AGPL-3.0"

WORKDIR /app
ENV DEBIAN_FRONTEND=noninteractive

RUN if command -v apt-get >/dev/null 2>&1; then \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            ffmpeg \
            gnupg \
            gosu \
            iproute2 \
            jq \
            libcap2-bin \
            openssh-client \
        && rm -rf /var/lib/apt/lists/*; \
    elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache \
            ca-certificates \
            curl \
            ffmpeg \
            gnupg \
            gosu \
            iproute2 \
            jq \
            libcap \
            openssh-client \
            python3 \
            py3-pip; \
    else \
        echo "Unsupported base image: no apt-get or apk found" >&2; \
        exit 1; \
    fi

# Install the Tailscale CLI only. If the host socket is unavailable, Printbuddy
# logs a hint and falls back to its normal non-Tailscale behavior.
RUN if command -v apt-get >/dev/null 2>&1; then \
        curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg \
            -o /usr/share/keyrings/tailscale-archive-keyring.gpg \
        && curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list \
            -o /etc/apt/sources.list.d/tailscale.list \
        && apt-get update \
        && apt-get install -y --no-install-recommends tailscale \
        && rm -rf /var/lib/apt/lists/*; \
    elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache tailscale; \
    else \
        echo "Unsupported base image: no apt-get or apk found" >&2; \
        exit 1; \
    fi

RUN setcap cap_net_bind_service=+ep "$(readlink -f "$(command -v python3)")"

COPY --from=printbuddy-src /src/requirements.txt ./requirements.txt
RUN printf 'numpy<2\n' > /tmp/old-cpu-constraints.txt \
    && python3 -m pip install --root-user-action=ignore --break-system-packages --upgrade 'pip>=26.1' \
    && python3 -m pip install --root-user-action=ignore --break-system-packages \
        --only-binary=numpy,fast-simplification,opencv-python-headless \
        -c /tmp/old-cpu-constraints.txt \
        -r requirements.txt

COPY --from=printbuddy-src /src/backend ./backend
COPY --from=printbuddy-src /src/static ./static
COPY --from=printbuddy-src /src/gcode_viewer ./gcode_viewer
COPY --from=printbuddy-src /src/deploy/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY rootfs/run.sh /run.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh /run.sh \
    && mkdir -p /app/data /app/logs /app/.git \
    && : > /app/data/.printbuddy \
    && : > /app/logs/.printbuddy \
    && printf 'ref: refs/heads/%s\n' "$PRINTBUDDY_REF" > /app/.git/HEAD

ENV PYTHONUNBUFFERED=1 \
    DATA_DIR=/data/printbuddy \
    LOG_DIR=/data/logs \
    PORT=8000 \
    HOME=/app \
    USER=printbuddy \
    LOGNAME=printbuddy \
    MPLCONFIGDIR=/tmp/matplotlib

EXPOSE 322 990 3000 3002 6000 8000 8883 50000-50100

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD python -c "import urllib.request, os; urllib.request.urlopen(f'http://127.0.0.1:{os.environ.get(\"PORT\", \"8000\")}/health')" || exit 1

CMD ["/run.sh"]

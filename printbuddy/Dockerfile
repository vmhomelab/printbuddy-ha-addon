ARG RUNTIME_FROM=python:3.12-slim-bookworm

FROM node:22-bookworm-slim AS printbuddy-src
ARG PRINTBUDDY_REF=dev
WORKDIR /src

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl tar \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://github.com/vmhomelab/Printbuddy/archive/${PRINTBUDDY_REF}.tar.gz" \
    | tar -xz --strip-components=1

# Home Assistant Ingress serves the add-on below /api/hassio_ingress/<token>/.
# Patch the frontend at build time so Vite emits relative assets and runtime
# calls to /api, /img, /icons, /fonts, /manifest.json, and /sw*.js stay under
# the ingress prefix instead of escaping to Home Assistant's own root origin.
RUN cat > /tmp/patch-ha-ingress.cjs <<'JS' \
    && node /tmp/patch-ha-ingress.cjs
const fs = require('fs');

function edit(path, transform) {
  const before = fs.readFileSync(path, 'utf8');
  const after = transform(before);
  if (after === before) throw new Error(`No change made to ${path}`);
  fs.writeFileSync(path, after);
}

fs.writeFileSync('frontend/src/ha-ingress.ts', `
export function printbuddyIngressBase(): string {
  if (typeof window === 'undefined') return '';
  const match = window.location.pathname.match(/^(.*\\/api\\/hassio_ingress\\/[^/]+)(?:\\/|$)/);
  return match?.[1] ?? '';
}

export function printbuddyWithIngressBase(url: string): string {
  const base = printbuddyIngressBase();
  if (!base || !url.startsWith('/') || url.startsWith('//') || url.startsWith(base + '/')) {
    return url;
  }
  return base + url;
}

const originalFetch = window.fetch.bind(window);
window.fetch = ((input: RequestInfo | URL, init?: RequestInit) => {
  if (typeof input === 'string') {
    return originalFetch(printbuddyWithIngressBase(input), init);
  }
  if (input instanceof URL && input.origin === window.location.origin) {
    return originalFetch(new URL(printbuddyWithIngressBase(input.pathname + input.search + input.hash), window.location.origin), init);
  }
  if (input instanceof Request) {
    const url = new URL(input.url);
    const path = url.pathname + url.search + url.hash;
    const rewritten = url.origin === window.location.origin ? printbuddyWithIngressBase(path) : path;
    if (rewritten !== path) {
      return originalFetch(new Request(rewritten, input), init);
    }
  }
  return originalFetch(input, init);
}) as typeof window.fetch;

for (const attr of ['src', 'href'] as const) {
  const descriptor = Object.getOwnPropertyDescriptor(Element.prototype, attr);
  if (!descriptor?.set || !descriptor?.get) continue;
  Object.defineProperty(Element.prototype, attr, {
    get: descriptor.get,
    set(value: string) { descriptor.set!.call(this, printbuddyWithIngressBase(value)); },
  });
}
`);

edit('frontend/vite.config.ts', (s) => s.replace('export default defineConfig({\n', "export default defineConfig({\n  base: './',\n"));
edit('frontend/src/main.tsx', (s) => s.replace("import './i18n' // Initialize i18n\n", "import './i18n' // Initialize i18n\nimport './ha-ingress'\n"));
edit('frontend/src/App.tsx', (s) => s
  .replace("import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';", "import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';\nimport { printbuddyIngressBase } from './ha-ingress';")
  .replace('<BrowserRouter>', '<BrowserRouter basename={printbuddyIngressBase() || undefined}>')
  .replace('                  <Route path="camera-tokens" element={<Navigate to="/settings?tab=apikeys#card-camera-tokens" replace />} />\n', '                  <Route path="camera-tokens" element={<Navigate to="/settings?tab=apikeys#card-camera-tokens" replace />} />\n                  <Route path="*" element={<Navigate to="/" replace />} />\n')
);
edit('frontend/src/contexts/AuthContext.tsx', (s) => s
  .replace("import { api, getAuthToken, setAuthToken } from '../api/client';", "import { api, getAuthToken, setAuthToken } from '../api/client';\nimport { printbuddyIngressBase, printbuddyWithIngressBase } from '../ha-ingress';")
  .replace('      const currentPath = window.location.pathname;', "      const currentPath = window.location.pathname.replace(printbuddyIngressBase(), '') || '/';")
  .replace("        window.location.href = '/setup';", "        window.location.href = printbuddyWithIngressBase('/setup');")
  .replace("    window.location.href = '/login';", "    window.location.href = printbuddyWithIngressBase('/login');")
);
edit('frontend/src/api/client.ts', (s) => s.replace("const API_BASE = '/api/v1';", "const INGRESS_BASE = window.location.pathname.match(/^(.*\\/api\\/hassio_ingress\\/[^/]+)(?:\\/|$)/)?.[1] ?? '';\nconst API_BASE = `${INGRESS_BASE}/api/v1`;"));
edit('frontend/src/hooks/useWebSocket.ts', (s) => s.replace(
  "    const wsUrl = `${protocol}//${window.location.host}/api/v1/ws`;",
  "    const ingressBase = window.location.pathname.match(/^(.*\\/api\\/hassio_ingress\\/[^/]+)(?:\\/|$)/)?.[1] ?? '';\n    const wsUrl = `${protocol}//${window.location.host}${ingressBase}/api/v1/ws`;"
));
edit('frontend/index.html', (s) => s.replace('    <script src="/sw-register.js"></script>\n', ''));
edit('backend/app/main.py', (s) => s.replace(
  `app = FastAPI(
    title=app_settings.app_name,
    description="Archive and manage Bambu Lab 3MF files",
    version=APP_VERSION,
    lifespan=lifespan,
)
`,
  `app = FastAPI(
    title=app_settings.app_name,
    description="Archive and manage Bambu Lab 3MF files",
    version=APP_VERSION,
    lifespan=lifespan,
)


@app.middleware("http")
async def home_assistant_ingress_path_middleware(request, call_next):
    """Normalize paths produced by HA Ingress prefix + absolute SPA assets."""
    path = request.scope.get("path", "")
    if isinstance(path, str) and path.startswith("//"):
        request.scope["path"] = "/" + path.lstrip("/")
        raw_path = request.scope.get("raw_path")
        if isinstance(raw_path, (bytes, bytearray)) and raw_path.startswith(b"//"):
            request.scope["raw_path"] = b"/" + bytes(raw_path).lstrip(b"/")
    return await call_next(request)
`
));
JS

WORKDIR /src/frontend
RUN --mount=type=cache,target=/root/.npm npm ci
RUN npm run build

FROM ${RUNTIME_FROM}
ARG PRINTBUDDY_REF=dev

LABEL \
    io.hass.name="Printbuddy" \
    io.hass.description="Self-hosted 3D printer management for Bambu Lab, Klipper, and Mainsail/Moonraker printers" \
    io.hass.type="addon" \
    io.hass.version="0.1.8" \
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

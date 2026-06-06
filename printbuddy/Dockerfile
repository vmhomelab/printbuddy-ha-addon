ARG RUNTIME_FROM=python:3.12-slim-bookworm

FROM node:22-bookworm-slim AS printbuddy-src
ARG PRINTBUDDY_REF=f5113d875668175f05a1011c004a757fb92b971a
WORKDIR /src

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl tar \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://github.com/vmhomelab/Printbuddy/archive/${PRINTBUDDY_REF}.tar.gz" \
    | tar -xz --strip-components=1

# Fail the image build if Home Assistant/Docker ever builds against a stale
# Printbuddy revision again. These fields are required by the Moonraker status
# serializer and websocket path; older commits missed them and produced
# AttributeError: hms_errors/raw_data at runtime.
RUN node - <<'JS'
const fs = require('fs');
const checks = {
  'backend/app/services/printer_providers/moonraker.py': [
    'raw_data: dict[str, Any] = field(default_factory=dict)',
    'hms_errors: list[Any] = field(default_factory=list)',
    'return self.state.connected',
    'def send_gcode(self, script: str) -> bool:',
    'self._post("printer/gcode/script", {"script": script})',
    'def set_nozzle_temperature(self, target: int | float) -> bool:',
    'def set_bed_temperature(self, target: int | float) -> bool:',
    'def _normalize_gcodes_path(self, remote_path: str) -> str:',
    '/home/mks/gcode_files',
    '/home/mks/printer_data/gcodes',
    'normalized == "/model" or normalized == "model"',
  ],
  'backend/app/services/printer_manager.py': [
    'Skipping saved printer %s during startup: %s',
  ],
  'frontend/src/pages/SetupPage.tsx': [
    "appAssetPath('/img/printbuddy_icon.png')",
    'Printbuddy app icon',
    'Bambu Lab · Klipper · Mainsail',
  ],
  'frontend/src/pages/PrintersPage.tsx': [
    'const PRINTER_MODEL_GROUPS',
    "label: 'Bambu Lab'",
    "label: 'Elegoo'",
    "value: 'Elegoo Neptune 4 Pro'",
    "label: 'Voron'",
    "value: 'Voron 2.4'",
    "label: 'Creality Klipper'",
    "label: 'Prusa'",
    "value: 'Prusa CORE One'",
    "value: 'Prusa MK4S'",
    "<option value=\"prusalink\">Prusa</option>",
    'provider={form.provider}',
    "value: 'Generic Klipper Printer'",
    'getPrinterFileRuleSet',
    'isPrintableForProvider',
    'printers.printUploadAccepts',
    'Printable files for this printer: {{extensions}}',
    'Only {{extensions}} files can be printed on this printer',
    'accept={printableFileRules.accept}',
    'acceptedFileDescription={printableFileDescription}',
    'PrinterModelImagePreview',
    'getDefaultPrinterImage',
    "value: 'A1 F'",
    "value: 'O1C'",
    "value: 'O1E'",
    "value: 'O1S'",
    '<PrinterModelImagePreview model={form.model} />',
    'const fanItems = [',
    "value: status.big_fan2_speed",
    "value: status.heatbreak_fan_speed",
    't(\'printers.fans.heatbreak\')',
    '].filter((fan) => fan.value !== null && fan.value !== undefined)',
    "{t('printers.indicators')}",
    '!showBedJogMenu',
    '!bedJogMutation',
    '!Move build plate',
    '<Collapsible',
    'defaultOpen={false}',
    'Manual controls',
    "printer.provider === 'prusalink' ? 'PrusaLink movement and extrusion' : 'Klipper movement, extrusion, and temperatures'",
    'const loadedSpoolAssignment = onGetAssignment?.(printer.id, -1, 0);',
    'const showLoadedSpoolPicker = (amsData.length === 0) && ((status?.vt_tray?.length ?? 0) === 0);',
    'Loaded spool',
    'const hasExternalCamera = Boolean(printer.external_camera_enabled && printer.external_camera_url);',
    "const canOpenCamera = hasPermission('camera:view') && (isConnected || hasExternalCamera);",
    'disabled={!canOpenCamera}',
    "aria-label={cameraViewMode === 'embedded' ? t('printers.openCameraOverlay') : t('printers.openCameraWindow')}",
    'Optional for non-Bambu printers. Add a camera stream or snapshot URL if available',
    '!Required for non-Bambu printers. Use the camera stream or snapshot URL',
  ],
  'frontend/src/components/SliceModal.tsx': [
    'function pickFilamentForLoadedSpool',
    'const loadedSpoolForSelectedPrinter = useMemo',
    'pickFilamentForLoadedSpool(',
    "queryKey: ['spool-assignments']",
  ],
  'backend/app/api/routes/inventory.py': [
    '``ams_id=-1, tray_id=0`` is the virtual "loaded spool" marker',
    'is_loaded_spool_marker = data.ams_id == -1 and data.tray_id == 0',
    'if is_loaded_spool_marker:',
  ],
  'frontend/src/utils/printerFileRules.ts': [
    'accept: \'.3mf,.gcode.3mf\'',
    "extensions: ['.3mf', '.gcode.3mf']",
    'accept: \'.bgcode,.gcode,.gco,.g\'',
    "extensions: ['.bgcode', '.gcode', '.gco', '.g']",
    'getPrinterFileRuleSet',
    'isPrintableForProvider',
  ],
  'frontend/src/utils/printer.ts': [
    'appAssetPath',
    'MODEL_IMAGE_ALIASES',
    'getDefaultPrinterImage',
    'normalizePrinterModel',
    "[/^a1f$/, 'a1f']",
    "[/^o1c$/, 'o1c']",
    "[/^o1e$/, 'o1e']",
    "[/^o1s$/, 'o1s']",
    "[/^elegooneptune3$/, 'elegoo-neptune-3']",
    "[/^elegooneptune3pro$/, 'elegoo-neptune-3-pro']",
    "[/^elegooneptune4pro$/, 'elegoo-neptune-4-pro']",
    "[/^elegooneptune4max$/, 'elegoo-neptune-4-max']",
    "[/^prusacoreone$/, 'prusa-core-one']",
    "[/^prusamk4s$/, 'prusa-mk4s']",
    "[/^(?:klipper|prusalink|genericklipperprinter|genericfdmprinter)$/, 'generic-printer']",
  ],
  'frontend/src/utils/assetPaths.ts': [
    'appAssetPath',
    'hassio_ingress',
  ],
  'frontend/src/components/Layout.tsx': [
    'appAssetPath',
    'printbuddy_logo_dark.png',
    'printbuddy_logo_light.png',
    "versionInfo?.display_version || versionInfo?.version || '...'",
  ],
  'frontend/src/pages/PrintersPage.tsx': [
    'appAssetPath(`/camera/${printer.id}`)',
  ],
  'frontend/src/pages/SettingsPage.tsx': [
    "versionInfo?.display_version || versionInfo?.version || '...'",
    'function inferExternalCameraType(url: string): string',
    'const handleTestExternalCamera = async (printerId: number, url: string, cameraType: string) => {',
    'const trimmedUrl = url.trim();',
    'data: { external_camera_snapshot_url: trimmedUrl }',
    'external_camera_url: trimmedUrl',
    'external_camera_enabled: true',
    'external_camera_type: cameraType || inferExternalCameraType(trimmedUrl)',
    'external_camera_type: inferExternalCameraType(trimmedUrl)',
    'external_camera_enabled: false',
  ],
  'backend/app/api/routes/updates.py': [
    'def _get_source_ref() -> str | None:',
    'PRINTBUDDY_REF',
    'source_ref_short',
    'display_version = f"{APP_VERSION} ({source_ref_short})"',
  ],
  'backend/app/services/printer_providers/prusalink.py': [
    'class PrusaLinkPrinterClient',
    'def pause_print',
    'def resume_print',
    'def stop_print',
    'X-Api-Key',
    'httpx.BasicAuth',
    'api/v1/status',
    'api/v1/job',
    'api/printer/printhead',
    'api/printer/tool',
    'disable_steppers',
  ],
  'backend/app/services/printer_providers/moonraker.py': [
    'def _moonraker_fan_percent',
    'def _apply_moonraker_fans',
    'printer/objects/list',
    'fan_generic ',
    'heater_fan ',
    'state.cooling_fan_speed = None',
    'state.heatbreak_fan_speed = percent',
    'Some Elegoo/Fluidd images do the inverse',
    'Therefore an explicit :7125 URL also gets a no-port fallback',
  ],
  'backend/app/api/routes/printers.py': [
    '/{printer_id}/disable-steppers',
    'normalize_external_camera_update(printer_data.model_dump(exclude_unset=True))',
  ],
  'backend/app/schemas/printer.py': [
    'def infer_external_camera_type(camera_url: str) -> str:',
    'def normalize_external_camera_update(update_data: dict) -> dict:',
    'update_data.setdefault("external_camera_enabled", True)',
    'data["external_camera_url"] = None',
    'data["external_camera_type"] = None',
    'data["external_camera_enabled"] = False',
    '!external_camera_url is required for non-Bambu printers',
  ],
  'frontend/src/components/KlipperControlPanel.tsx': [
    "printer.provider === 'prusalink'",
    "!<span className=\"text-[var(--accent)]\">{printer.name}</span> printer control",
    'const prusaBusy = moveMut.isPending || homeMut.isPending || disableSteppersMut.isPending',
    'onClick={() => homeMut.mutate(undefined)}',
    "onClick={() => homeMut.mutate(['x', 'y'])}",
    "onClick={() => homeMut.mutate(['z'])}",
    "onClick={() => moveMut.mutate({ axis: 'z', distance: xyStep })}",
    "onClick={() => moveMut.mutate({ axis: 'z', distance: -xyStep })}",
    "t('printers.klipper.extrusionLength', 'Extrusion length')",
    "t('printers.klipper.extrusionSpeed', 'Extrusion speed')",
    "t('printers.klipper.nozzle', 'Nozzle')",
    "t('printers.klipper.bed', 'Bed')",
    'Stepper motors',
    'Disable steppers',
    'bg-[var(--bg-secondary)]',
    'bg-[var(--bg-tertiary)]',
  ],
};
const missing = [];
const requiredFiles = [
  'static/img/printers/a1f.png',
  'static/img/printers/a1mini.png',
  'static/img/printers/o1c.png',
  'static/img/printers/o1e.png',
  'static/img/printers/o1s.png',
  'static/img/printers/h2dpro.png',
  'static/img/printers/elegoo-neptune-4-pro.png',
  'static/img/printers/prusa-mk4s.png',
  'static/img/printers/generic-printer.png',
  'static/img/printers/default.png',
];
for (const file of requiredFiles) {
  if (!fs.existsSync(file)) missing.push(`${file}: missing printer artwork asset`);
}
for (const [path, required] of Object.entries(checks)) {
  const source = fs.readFileSync(path, 'utf8');
  for (const needle of required) {
    if (needle.startsWith('!')) {
      const forbidden = needle.slice(1);
      if (source.includes(forbidden)) missing.push(`${path}: forbidden stale marker still present: ${forbidden}`);
    } else if (!source.includes(needle)) {
      missing.push(`${path}: ${needle}`);
    }
  }
}
if (missing.length) {
  throw new Error(`Downloaded Printbuddy source is missing required fixes: ${missing.join(', ')}`);
}
JS

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
ARG PRINTBUDDY_REF=f5113d875668175f05a1011c004a757fb92b971a

LABEL \
    io.hass.name="Printbuddy" \
    io.hass.description="Self-hosted 3D printer management for Bambu Lab, Klipper/Moonraker, and PrusaLink printers" \
    io.hass.type="addon" \
    io.hass.version="0.1.51" \
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
    PRINTBUDDY_REF=${PRINTBUDDY_REF} \
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

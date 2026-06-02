# Changelog

## 0.1.24

- Pinned the add-on build to Printbuddy commit `cdfeb482fd31529e3ba1a59ff7f8d7a777344c66`, which includes the updated PrusaLink manual controls.
- Added the Prusa-style control panel layout with printer coordinates, stepper controls, XY/Z movement, and extrude/retract step controls.
- Uses PrusaLink-native printhead and tool endpoints for jog, home, disable steppers, extrusion, and temperature commands.

## 0.1.17

- Fixed the add-on Docker build guard so the startup-fix marker is checked in `printer_manager.py` instead of the Moonraker provider file.
- Keeps the same Printbuddy source ref as 0.1.16; this release only fixes the add-on build failure during update.

## 0.1.16

- Pinned the add-on build to Printbuddy commit `c9348e724b528b98d610ab7ad859eb82bd0e8495`, which prevents one unreachable saved printer from aborting Home Assistant add-on startup.
- Startup now logs and skips unreachable saved printers so the web app can still open and the printer can be fixed from the UI.

## 0.1.15

- Pinned the Home Assistant add-on build to Printbuddy commit `bfb8c3d99215f925ea0a3bbaacd45e7b56aff9f9`, which includes Moonraker jog controls and nozzle/bed temperature controls.
- Bumped add-on metadata so Home Assistant Supervisor can detect the update instead of only seeing the upstream app repository change.

## 0.1.8

- Fixed Ingress redirects that escaped Home Assistant by rewriting setup/login redirects through the active `/api/hassio_ingress/<token>` base path.
- Added a React Router fallback to return stale or unknown Ingress routes to the dashboard instead of leaving the user on a 404.
- Disabled service-worker registration in the Home Assistant add-on build to avoid PWA root-scope/cached-route interference under Ingress.

## 0.1.7

- Fixed Home Assistant Ingress static asset loading when HA combines the Ingress token path with absolute asset URLs and forwards paths like `//assets/...`.
- Normalizes double-leading-slash request paths before FastAPI routing so `/assets`, `/sw-register.js`, manifest, icons, and other static files return their real MIME type instead of the SPA fallback HTML.

## 0.1.6

- Fixed React Router matching under Home Assistant Ingress by setting the router basename to the active `/api/hassio_ingress/<token>` prefix.
- Sets the add-on Ingress entry point explicitly to `/` so Home Assistant opens the SPA root instead of a stale internal route.

## 0.1.5

- Fixed blank Home Assistant Ingress screens by building the SPA with relative asset URLs.
- Rewrites frontend `/api`, `/img`, `/icons`, `/fonts`, manifest, service worker, and WebSocket URLs under the active `/api/hassio_ingress/<token>` prefix at runtime.

## 0.1.4

- Fixed Home Assistant Ingress/Web UI embedding by exporting `TRUSTED_FRAME_ORIGINS` by default, which makes Printbuddy drop `X-Frame-Options` and use CSP `frame-ancestors 'self' ...` instead.
- Added an add-on option to override trusted frame origins for custom Home Assistant URLs.

## 0.1.3

- Fixed add-on startup permissions for persistent `/data/printbuddy` and `/data/logs` paths before dropping privileges.
- Pre-creates Printbuddy runtime subdirectories such as `archive` and `plate_calibration` in the Home Assistant data volume.

## 0.1.2

- Pinned the add-on runtime stage to a Debian Python base instead of Home Assistant's injected Alpine base image.
- Switched the runtime to Python 3.12 and constrained `numpy<2` so older x86_64 CPUs without x86-64-v2 support can install/import NumPy successfully.
- Forced binary wheels for NumPy, fast-simplification, and OpenCV during dependency installation to avoid local source builds inside the Supervisor builder.

## 0.1.1

- Fixed Home Assistant add-on builds that use an Alpine-based `BUILD_FROM` image by supporting `apk` package installation.
- Kept Debian/Ubuntu `apt-get` support for direct Docker builds using the default Python slim base image.
- Installed Tailscale through the matching package manager for the selected base image.

## 0.1.0

- Initial Home Assistant add-on packaging for Printbuddy.
- Builds Printbuddy from `vmhomelab/Printbuddy` using the `dev` branch by default.
- Enables Home Assistant Ingress for the Printbuddy web UI.
- Stores persistent data in the add-on `/data` volume.
- Uses host networking to preserve LAN printer connectivity and compatibility ports.

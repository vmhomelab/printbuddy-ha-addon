# Changelog

## 0.1.39

- Pinned the add-on build to Printbuddy commit `bb4c4f4ccef5b261b63d662c6f3fc067a9d24d53`, which maps Elegoo `/model` file paths to Moonraker's `gcodes` root.
- Elegoo file operations now normalize `/model/...`, `/home/mks/gcode_files/...`, and `/home/mks/printer_data/gcodes/...` before list/upload/download/delete/start-print calls.
- Keeps the expanded Elegoo and Prusa model artwork mappings available in the Home Assistant add-on build.

## 0.1.38

- Pinned the add-on build to Printbuddy commit `368f6a5364d69de1069db6c5e4739759a19109ea`, which improves Elegoo/Fluidd Moonraker connection probing.
- If the default Moonraker `:7125` port is unreachable, Printbuddy now also tries the no-port Fluidd proxy URL before rejecting the printer.
- Added a build-time guard so stale add-on builds fail if the Elegoo/Fluidd fallback probe is missing.

## 0.1.37

- Pinned the add-on build to Printbuddy commit `b6ae02676c4b69ecbd8f0d5be56a88bdd3e9b8f2`, which fixes the setup window branding to use the correct Printbuddy app icon.
- Added a build-time guard so stale add-on builds fail if the setup page falls back to the old logo asset.

## 0.1.36

- Pinned the add-on build to Printbuddy commit `2001ada2188424acf4154dfc8f499ec72156c62d`, which keeps the non-Bambu artwork preview fix and applies final backend formatting required by CI.
- Keeps the Elegoo Neptune 4 Pro and Prusa MK4S artwork aliases/assets available through the Home Assistant add-on build.

## 0.1.35

- Pinned the add-on build to Printbuddy commit `12e0113043b6a19c95842ca85d321fd204cb3597`, which keeps the non-Bambu artwork preview fix and satisfies the remaining backend route import-order CI checks.
- Keeps the Elegoo Neptune 4 Pro and Prusa MK4S artwork aliases/assets available through the Home Assistant add-on build.

## 0.1.34

- Pinned the add-on build to Printbuddy commit `9c9ac9c4e02b922c9e711d7fa4564e47ce4ba598`, which keeps the non-Bambu printer artwork preview fix and satisfies backend import-order CI.
- Keeps the Elegoo Neptune 4 Pro and Prusa MK4S artwork aliases/assets available through the Home Assistant add-on build.

## 0.1.33

- Pinned the add-on build to Printbuddy commit `a363c9931949f5ead86cf31a42b8c07296e43aac`, which fixes non-Bambu printer artwork previews.
- Elegoo Neptune 4 Pro and Prusa MK4S now resolve to their bundled printer images in add/edit previews, printer cards, and the printer info modal instead of falling back to the default image.
- Added build-time guards so stale add-on builds fail if the non-Bambu artwork aliases or assets are missing.

## 0.1.32

- Pinned the add-on build to Printbuddy commit `752071b006fb469792abe45f17e7cb023bb6d148`, which adds model-specific printer artwork selection from `/static/img/printers`.
- Printer cards, the printer info modal, and add/edit printer dialogs now resolve the selected model to the matching artwork and fall back to `default.png` if an image is missing.
- Added Bambu model choices for A1 F and the O1 family so those new artwork files can be selected directly.

## 0.1.31

- Pinned the add-on build to Printbuddy commit `bb425cccdeb12f5cece72468c607e3921f0132a9`, which brings the printer-card fan/status refinements to Klipper/Moonraker printers as well.
- Moonraker fan badges now come from reported Klipper fan objects, including part cooling, auxiliary, chamber/exhaust, and hotend heatbreak fans where present.
- Missing Moonraker fans remain hidden while an existing fan at `0%` is still displayed, matching the Prusa/Bambu status strip behavior.

## 0.1.30

- Pinned the add-on build to Printbuddy commit `dc56f290993edb9705196a01b958c6ed87a3c9bb`, which refines the expanded printer card status/print-action strip.
- Renamed that strip from Controls/Steuerung to Status so it no longer duplicates the separate manual controls section below.
- Fan percentage badges now only appear for fan capabilities reported by the printer; unsupported fans such as a missing chamber fan stay hidden, while supported fans at `0%` still display.
- Removed the compact bed-jog button from the status strip; Stop and Pause/Resume remain there, with movement controls kept in the manual controls section.

## 0.1.29

- Pinned the add-on build to Printbuddy commit `f0f5fed73cc5a5c3f71d5eb6ee37a628c4f9a641`, which includes provider-specific print upload file handling and the latest PrusaLink manual-control layout.
- The printer card print/upload dialog now shows and accepts the file types required by the selected printer provider, for example Bambu `.3mf` / `.gcode.3mf`, Prusa `.bgcode` / G-code, and Klipper-style G-code files.
- PrusaLink manual controls now visually match the Klipper/Moonraker control layout while keeping PrusaLink-native backend commands.

## 0.1.28

- Pinned the add-on build to Printbuddy commit `c4b7ef72a35b7a582641d5f56912ed36ce4a3d64`, which removes the redundant PrusaLink manual-control title.
- The expanded PrusaLink manual control area now starts directly with coordinates, stepper, movement, and extrusion sections instead of showing `<printer name> printer control`.
- Keeps the latest PrusaLink controls, printer file upload, and queue-from-printer-file changes available through the Home Assistant add-on build.

## 0.1.27

- Pinned the add-on build to Printbuddy commit `8a5b10fa6d1181c70f2a871c7f9ebff8203ece28`, which themes the Klipper/Moonraker and PrusaLink manual control buttons.
- Replaced the hardcoded Klipper red jog buttons and Prusa orange accents with the active Printbuddy accent color.
- Updated movement, home, extrude/retract, temperature set, and step buttons so they follow the configured theme consistently.

## 0.1.26

- Pinned the add-on build to Printbuddy commit `29e99e38f9388e2090583f341bdbb8a3d4d537e8`, which collapses manual controls on printer cards by default.
- Keeps Klipper/Moonraker and PrusaLink printer cards uniform on the dashboard with a compact `Manual controls` disclosure row.
- The full movement, extrusion, and temperature controls are still available after expanding the row.

## 0.1.25

- Pinned the add-on build to Printbuddy commit `7f0eff91c46439a0eda64a215d907e1d3b5d74af`, which aligns the PrusaLink control card with the app's dark theme.
- Replaced the hard black Prusa control background and fixed grey controls with theme-aware background, border, button, and text colors.

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

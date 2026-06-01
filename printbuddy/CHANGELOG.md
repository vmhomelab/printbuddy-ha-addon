# Changelog

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

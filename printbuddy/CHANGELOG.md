# Changelog

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

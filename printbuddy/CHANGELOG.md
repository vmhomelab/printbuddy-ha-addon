# Changelog

## 0.1.0

- Initial Home Assistant add-on packaging for Printbuddy.
- Builds Printbuddy from `vmhomelab/Printbuddy` using the `dev` branch by default.
- Enables Home Assistant Ingress for the Printbuddy web UI.
- Stores persistent data in the add-on `/data` volume.
- Uses host networking to preserve LAN printer connectivity and compatibility ports.

# Printbuddy Home Assistant Add-on Repository

This repository packages [Printbuddy](https://github.com/vmhomelab/Printbuddy) as a Home Assistant add-on.

Printbuddy is a self-hosted 3D printer management app for Bambu Lab, Klipper and prusa printers. The add-on keeps the current Printbuddy feature set available inside Home Assistant, including the web UI, printer monitoring, archive/queue features, virtual-printer compatibility ports, and Moonraker support.

> [!WARNING]
> **This repository is still under active development**
>
> This project is not ready for public use yet. Features may be incomplete, unstable, or subject to breaking changes without notice.
>
> Please do not use this repository in production environments at this stage.

## Installation

1. In Home Assistant, open **Settings → Add-ons → Add-on Store**.
2. Open the **⋮** menu and choose **Repositories**.
3. Add this repository URL:

   ```text
   https://github.com/vmhomelab/printbuddy-ha-addon
   ```

4. Install **Printbuddy**.
5. Start the add-on.
6. Open the add-on through **Open Web UI** or the sidebar panel.

## Notes

- The UI is exposed through Home Assistant Ingress on port `8000`.
- The add-on uses host networking so LAN printer access and printer callback ports behave like the normal Docker deployment.
- Persistent data is stored under the add-on `/data` volume:
  - `/data/printbuddy` for Printbuddy data/database/archive
  - `/data/logs` for logs
- The Docker build currently tracks the Printbuddy `dev` branch through `printbuddy/build.yaml` so Marko can test the current feature set first. After approval, change `PRINTBUDDY_REF` to a release tag or `main`.

## Exposed compatibility ports

The add-on keeps the same relevant Printbuddy ports available:

- `8000/tcp`: Web UI/API, normally used by Ingress
- `322/tcp`: Virtual printer FTP/control compatibility
- `990/tcp`: FTPS compatibility
- `8883/tcp`: MQTT over TLS compatibility
- `3000/tcp`, `3002/tcp`: optional auxiliary Printbuddy feature ports

## Development workflow

Work lands on `dev` first. Marko tests from `dev`, then approved changes are merged to `main`.

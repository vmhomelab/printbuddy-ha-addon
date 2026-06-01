# Printbuddy add-on

Run Printbuddy inside Home Assistant.

## Features

- Home Assistant Ingress web UI
- Persistent Printbuddy data under the add-on `/data` volume
- Bambu Lab, Klipper, and Mainsail/Moonraker support from the current Printbuddy build
- Host networking for LAN printer access and printer callback ports
- Optional import of Home Assistant `/ssl/*.crt` certificates into the container trust store

## Configuration

```yaml
log_level: info
puid: 1000
pgid: 1000
use_system_trust_store: false
```

### Options

- `log_level`: Printbuddy backend log level.
- `puid` / `pgid`: UID/GID used by the Printbuddy process after startup ownership checks.
- `use_system_trust_store`: When enabled, `.crt` files from Home Assistant's `/ssl` mount are imported before Printbuddy starts.

## Data

Printbuddy stores persistent files here inside the add-on:

- `/data/printbuddy`
- `/data/logs`

Use Home Assistant backups to include the add-on data volume.

# MediaChips: Linux workaround

MediaChips 1.12.0 bundles Electron 42.9.0 and Sharp 0.35.3. On this desktop,
decoding an in-memory PNG crashes the Electron process with SIGSEGV. The same
Sharp library works with system Node.js 24.18.0. `UV_THREADPOOL_SIZE=1` did not help.

The menu entry now starts `mediachips-node.service` on demand and opens Chrome in
app mode with a separate browser profile. Closing the window leaves the backend
running; it stops with the graphical session. It is not enabled at boot.

## Installed files

- `~/.local/share/mediachips-node/app`: extracted MediaChips 1.12.0 application.
- `~/.local/share/mediachips-node/resources/models`: bundled model resources.
- `~/.local/share/mediachips-node/browser`: separate Chrome profile.
- `~/.config/MediaChips`: original, live database and generated images.
- `~/.local/state/mediachips-node/backups`: pre-installation recovery snapshots.

The production server uses the original library, not either temporary test copy.
The server listens on localhost only (`MEDIA_CHIPS_ALLOW_LAN=0`). Chrome mode does
not provide Electron-only shell features such as its auto-updater or native IPC.
Test those features separately if needed; playback and normal library editing
are handled by the web interface.

The application's `better-sqlite3` native addon was replaced **only in the extracted
copy**, using the official v12.11.1 build for Node ABI 137 (Linux x64):

https://github.com/WiseLibs/better-sqlite3/releases/download/v12.11.1/better-sqlite3-v12.11.1-node-v137-linux-x64.tar.gz

SHA-256: `99c43785639d5d3690c396ba245ee680ac8b469a46b19233a3546f0eb7f8e312`

The 1.2 GB application and private data are not stored in this repository.
Installing the service and launcher alone is insufficient on a new machine:
the application must first be extracted and its SQLite addon matched to Node.
Major Node.js upgrades may change the ABI; the service checks compatibility before
opening the database and logs a clear error instead of attempting an automatic repair.

## Diagnostics

```sh
systemctl --user status mediachips-node.service
journalctl --user -u mediachips-node.service -n 100
systemctl --user restart mediachips-node.service
```

## Rollback

First close the MediaChips Chrome window, then stop the backend:

```sh
systemctl --user stop mediachips-node.service
```

The original `/home/thyriaen/Data/Lusum/Application/mediaChips.AppImage` remains
unchanged. Do not run it alongside the Node backend against the same database.
It still has the known Sharp crash; preserving it is not a claim that it works.
The old desktop entry is saved in the timestamped pre-installation backup.

Each recovery snapshot contains a SQLite online backup (including committed WAL
transactions), config, generated `media` and `meta` files, and the old desktop entry.
It does not include the source videos. Restoring a snapshot loses changes made
after that snapshot: stop all MediaChips processes and preserve the current data
before any restore. Never overwrite a live SQLite database or leave stale WAL/SHM
files beside a restored database.

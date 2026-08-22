# Klipper for the FlashForge Creator 5 Pro

Fork of [klipper3d/klipper](https://github.com/Klipper3d/klipper) carrying the
host-side changes needed to run Klipper on the Creator 5 Pro (Ingenic X2000
MIPS host, closed prebuilt MCU firmware on the main/e/eheater/level boards).
Part of [Klipper4Creator5](https://github.com/Klipper4Creator5).

## Branches

| branch | what |
|---|---|
| `master` | untouched upstream mirror |
| `ff-stock` | upstream `6d70050` (v0.12.0-256, 2024-06-21, the commit FlashForge forked from) + FlashForge's changes as recovered from the `software-1.9.7` / `software-1.9.8` update packages, split into feature commits. Tags `ff-1.9.7`, `ff-1.9.8` (identical Klipper trees). |
| `creator5` | **the branch to run**: upstream `v0.13.0` + the FlashForge commits that are actually needed, cherry-picked from `ff-stock`. |

FlashForge publishes no history, so `ff-stock` is a reconstruction: one commit
per feature, authored "FlashForge (recovered)", with the printer's leftover
`*.bak` / `*.ok` files used as intermediate revisions where they existed.

## What is on `creator5` (and what is not)

Cherry-picked: lis2dw/LIS3DH back-port, platform glue (daemons, MIPS chelper,
log rotation), host side of the custom MCU protocol (`GET_MCU_VERSION`,
`RECOVER_ENDSTOPS`/`RECOVER_PROBE`, trsync timeout), heater changes
(2-extruder concurrent heating limit, faster settle, `error` status), eddy
Z-homing/probing robustness + JSON error codes, the new `extras/` modules
(`ff_eddy`, `e_stop`, `hd_home`, `tmc_home*`, `mclib`, `pa_adjust`,
`temp_ctrl`, `stepper_resonance_tester`, `lis3dh`), filament sensor status
keys + `RESET_FILAMENT_SENSOR`.

Deliberately left on `ff-stock` only: "mute mode" (M204 S65535 / fanM106
sentinels -> do it with macros), the `virtual_sdcard` tool-change handshake
with firmwareExe (replaced by `ff_toolchange.py` in
[creator5-toolchange](https://github.com/Monstrofil/creator5-toolchange)),
the shipped printer config (`ff-config/`).

`src/` is upstream: the MCUs run FlashForge's closed firmware and are not
reflashed. Between `6d70050` and `v0.13.0` upstream only added MCU commands for
sensors this printer does not have (ads1220, hx71x, icm20948, canbus stats),
so the old firmware should still satisfy a v0.13.0 host — untested on hardware
at the time of writing.

## Tracking FlashForge updates

```
git checkout ff-stock
./ff-import.sh /path/to/extracted/software-1.9.9   # overlays klippy/, extras/, kinematics/, ff-config/
git diff                                            # what FlashForge changed
git commit -a -m "ff: import software-1.9.9" && git tag ff-1.9.9
```
Then port whatever matters to `creator5` with `git cherry-pick`.

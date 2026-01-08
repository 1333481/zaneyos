# Pre-Merge Check — zos-next vs main (2026-01-08)

## Merge blockers

- `flake.nix` no longer passes `system` into `nixpkgs.lib.nixosSystem`; evaluation will fail. Add `system = "<arch>";`.
- `specialArgs` no longer includes `host`, but `modules/core/user.nix` still expects it. Re-add `host` to `specialArgs` (and pass to HM).
- `nixosConfigurations` keys changed from GPU-profile names to host names; scripts/docs (fr/fu, README examples) that call `.#amd`, `.#nvidia`, etc., will break unless updated.

## Design changes to verify

- New options schema (`modules/options.nix`); every host must set `zaneyos.gpuProfile` and `zaneyos.hostName`.
- Display manager selection via `zaneyos.displayManager`; both `ly` and `sddm` are imported and guarded by `mkIf`.
- Scanning moved to new `modules/core/scanners.nix`, gated by `zaneyos.scannerEnable` (default true) and adds `scanner` group.
- Boot logic now arch-aware: `systemd-boot` only on x86_64; `generic-extlinux-compatible` on aarch64; non-x86 uses generic kernel (not zen).
- `smartd` now follows `zaneyos.enableSmartD` (default true); set false for VMs to match old behavior.
- Host variables now live under `zaneyos = { … };` in each `hosts/<name>/variables.nix`.
- Home modules are always imported but gated (`tmuxEnable`, `weztermEnable`, `alacrittyEnable`, `ghosttyEnable`, `vscodeEnable`, `doomEmacsEnable`, etc.).
- `overlays.nix` adds `pkgs.unstable`; `packages.nix` includes an empty `unstablePkgs` list (currently unused).

## Recommended actions before merging

- Patch `flake.nix`: restore `system` and `host` in `specialArgs`, then run `nix flake check`.
- Update docs/aliases/scripts to the new host-based outputs or add compatibility wrappers for old profile targets.
- For VM hosts, set `zaneyos.enableSmartD = false`.
- Smoke-test on x86_64 and (if applicable) aarch64 to confirm bootloader/kernels.

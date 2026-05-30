#!/usr/bin/env bash

log() {
  local level="$1"
  local msg="$2"
  case "$level" in
    info)
      gum log -t rfc822 -l info "$msg"
      ;;
    warn)
      gum log -t rfc822 -l warn "$msg"
      ;;
    error)
      gum log -t rfc822 -l error "$msg"
      ;;
    *)
      gum log -t rfc822 -l debug "$msg"
      ;;
  esac
}

log_info() {
  local msg="$1"
  log info "$msg"
}

log_warn() {
  local msg="$1"
  log warn "$msg"
}

log_error() {
  local msg="$1"
  log error "$msg"
}

box_message() {
  local msg="$1"
  gum style --border "rounded" --padding "1" --foreground "yellow" "$msg"
}



if [ "$(id -u)" -ne 0 ]; then
  log_info "Re-executing as root via sudo..."
  exec sudo --preserve-env=PATH -H "$0" "$@"
fi

mkdir "/nixos-config"
tar -xf "/iso/nixos-config.tar" -C "/nixos-config"

FLAKE_DIR="/nixos-config"
if [ ! -d "$FLAKE_DIR" ]; then
  log_error "$FLAKE_DIR is missing."
  exit 1
fi

git_in_flake() {
  git -C "$FLAKE_DIR" "$@"
}

if [ ! -d "$FLAKE_DIR/.git" ]; then
  log_warn "$FLAKE_DIR is not a git working tree."
  gum confirm "git init ?" || { log_error "Not a git working tree."; exit 1; }
  git_in_flake init 1>/dev/null 
  git_in_flake add -A 1>/dev/null
  git_in_flake commit -m "Auto commit, install-host.sh" 1>/dev/null
fi
cd "$FLAKE_DIR"

# ---------------------------------------------------------------
# Step: choose target host
# ---------------------------------------------------------------
TARGET_HOST=$(nix eval --raw --impure --expr \
  'builtins.concatStringsSep "\n" (builtins.filter (n: n != "nixos-installer") (builtins.attrNames (builtins.getFlake "git+file:///nixos-config").nixosConfigurations))' \
  | gum choose --header="Select target host")

if [ -z "${TARGET_HOST:-}" ]; then
  log_error "No target host selected."
  exit 1
fi


# Read disk candidates from the chosen nixosConfiguration. Hosts can define
# any key(s) under disko.devices.disk; we auto-select when there is one,
# otherwise prompt for which disk definition to use.
#
# `nix eval` (new CLI) does not accept --argstr; use --apply to feed the
# selected host into the function expression.
DISK_CANDIDATES=$(nix eval --raw --impure \
  --option substituters "" \
  --expr 'targetHost:
    let
      flake = builtins.getFlake "git+file:///nixos-config";
      cfg = (builtins.getAttr targetHost flake.nixosConfigurations).config;
      disks = cfg.disko.devices.disk or {};
      names = builtins.attrNames disks;
    in
      builtins.concatStringsSep "\n" (map (n: "${n}\t${disks.${n}.device}") names)' \
  --apply "f: f \"$TARGET_HOST\"")

if [ -z "${DISK_CANDIDATES}" ]; then
  log_error "Host '$TARGET_HOST' has no entries in disko.devices.disk."
  log_error "Define at least one disk under disko.devices.disk.<name>.device and re-run."
  exit 1
fi

DISK_COUNT=$(printf '%s\n' "$DISK_CANDIDATES" | grep -c .)
if [ "$DISK_COUNT" -eq 1 ]; then
  IFS=$'\t' read -r DISK_NAME DISK <<<"$DISK_CANDIDATES"
else
  DISK_NAME=$(printf '%s\n' "$DISK_CANDIDATES" | cut -f1 \
    | gum choose --header="Select disko.devices.disk entry")
  DISK=$(printf '%s\n' "$DISK_CANDIDATES" \
    | awk -F'\t' -v n="$DISK_NAME" '$1 == n { print $2; exit }')
fi

if [ -z "${DISK:-}" ]; then
  log_error "Failed to resolve disk device for '$TARGET_HOST'."
  exit 1
fi

log_info "Target host: $TARGET_HOST"
log_info "Disk entry: $DISK_NAME"
log_info "Target disk: $DISK"
echo
log_info "Available disks on this machine:"
lsblk -dno NAME,SIZE,MODEL,TYPE | awk '$NF=="disk"'
echo


# ---------------------------------------------------------------
# Step: optional blkdiscard
# Useful when the disk has leftover signatures (e.g. an old LUKS
# header) that confuse blkid/mount even after disko reformats the
# partitions. Only meaningful for SSDs/NVMe that support discard.
# Default off because it is destructive and slow.
# ---------------------------------------------------------------
if gum confirm --default=false \
    "Fully wipe $DISK with blkdiscard before partitioning?"; then
  if [ ! -b "$DISK" ]; then
    log_error "$DISK is not a block device on this machine."
    exit 1
  fi
  log_info "Running blkdiscard -f $DISK"
  blkdiscard -f "$DISK"
fi


# ---------------------------------------------------------------
# Step: partition with disko
# ---------------------------------------------------------------
if gum confirm "Partition $DISK with disko (destroy,format,mount)?"; then
  if [ ! -b "$DISK" ]; then
    log_error "$DISK is not a block device on this machine."
    log_info "Edit disko.nix (or override disko.devices.disk.<name>.device in flake.nix) to point at the correct disk, and try again."
    exit 1
  fi
  if gum confirm "WARNING!!!! This will ERASE ALL DATA on $DISK. Are you sure?"; then
    log_info "Partitioning $DISK"
    @diskoBin@/bin/disko \
      --mode destroy,format,mount \
      --flake ".#$TARGET_HOST" \
      --yes-wipe-all-disks
  fi
fi


# ---------------------------------------------------------------
# Step: generate facter.json
# ---------------------------------------------------------------
log_info "Generate facter.json"
nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json


# ---------------------------------------------------------------
# Step: Git add commit
# ---------------------------------------------------------------
if ! git_in_flake diff --quiet; then
  log_info "Tracked files have uncommitted modifications:"
  git_in_flake status --short
  echo
  if gum confirm "Stage and commit these changes before installing?"; then
    git_in_flake add -u
    git_in_flake commit -m "install-host: auto-commit before installing $TARGET_HOST"
  else
    log_info "REMINDER: commit these changes after the install completes, so the copy persisted to /mnt/etc/nixos is a clean worktree."
  fi
fi


# ---------------------------------------------------------------
# Step: nixos-install
# ---------------------------------------------------------------
if gum confirm "Run nixos-install for host '$TARGET_HOST'?"; then
  nixos-install --flake ".#$TARGET_HOST"
else
  log_warn "REMINDER: run \`nixos-install --flake \"$FLAKE_DIR/.#$TARGET_HOST\"\`"
fi


# ---------------------------------------------------------------
# Step: persist the flake on the installed system so future
# `nixos-rebuild` invocations have a config to work with.
# ---------------------------------------------------------------
if gum confirm "Copy $FLAKE_DIR to /mnt/etc/nixos?"; then
  cp -r "$FLAKE_DIR" "/mnt/etc/nixos"
else
  log_warn "REMINDER: copy $FLAKE_DIR in /mnt"
fi

log_info "Done."

if gum confirm "REBOOT ?"; then
  reboot
fi

#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT="${PROJECT:-linuxvm-490110}"
INSTANCE="${INSTANCE:-server}"
ZONE="${ZONE:-us-central1-f}"
BUDGET_DIR="${BUDGET_DIR:-$HOME/Documents/code/budget}"

echo "Google Cloud post-install setup"
echo

if ! command -v gcloud >/dev/null 2>&1; then
	cat >&2 <<'EOF'
Missing gcloud.

Install google-cloud-cli using Google's official Fedora/RHEL DNF repo:

sudo tee /etc/yum.repos.d/google-cloud-sdk.repo > /dev/null <<'REPO'
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
REPO

sudo dnf -y install libxcrypt-compat google-cloud-cli

Then rerun:
  ./gcloud.sh

Source:
  https://docs.cloud.google.com/sdk/docs/install
EOF
	exit 1
fi

active_account="$(gcloud config get-value account 2>/dev/null || true)"
if [[ -z "$active_account" ]]; then
	echo "No active gcloud account. Starting browser login..."
	gcloud auth login
else
	echo "Active gcloud account: $active_account"
fi

echo "Set project: $PROJECT"
gcloud config set project "$PROJECT"

echo "Set default compute zone: $ZONE"
gcloud config set compute/zone "$ZONE"

echo
echo "Check budget sync files..."
missing=0
for file in Dockerfile.sync sync.js applySyncOnServer.sh config.json state.json private.key public.crt; do
	if [[ ! -f "$BUDGET_DIR/$file" ]]; then
		echo "Missing: $BUDGET_DIR/$file"
		missing=1
	fi
done

if (( missing )); then
	cat <<EOF

Restore the missing budget files before running updateActual.
The secret files must not be committed to the Config repo:
  $BUDGET_DIR/config.json
  $BUDGET_DIR/state.json
  $BUDGET_DIR/private.key
  $BUDGET_DIR/public.crt
EOF
fi

echo
echo "Test SSH to $INSTANCE..."
# shellcheck disable=SC2016
gcloud compute ssh "$INSTANCE" --zone="$ZONE" --command 'echo "connected: $(hostname)"'

echo
echo "Ready commands:"
echo "  updateActual"
echo "  connect"
echo "  ./applySyncOnServer.sh"

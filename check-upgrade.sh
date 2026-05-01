#!/usr/bin/env bash
# Checks whether all required COPR repos have builds ready for the target
# Fedora version. Run this before wiping and reinstalling.
#
# Usage: ./check-upgrade.sh [target-version]
#   e.g. ./check-upgrade.sh 44

CURRENT=$(rpm -E %fedora)
TARGET=${1:-$((CURRENT + 1))}
ARCH="x86_64"
ALL_OK=true

check_copr() {
    local owner="$1"
    local project="$2"
    local label="$3"
    local chroot="fedora-${TARGET}-${ARCH}"

    local response
    response=$(curl -sf \
        "https://copr.fedorainfracloud.org/api_3/project?ownername=${owner}&projectname=${project}" \
        2>/dev/null)

    if [ $? -ne 0 ]; then
        echo "  ERROR   $label ($owner/$project) -- could not reach COPR API"
        ALL_OK=false
        return
    fi

    if echo "$response" | grep -q "\"${chroot}\""; then
        echo "  OK      $label ($owner/$project)"
    else
        echo "  MISSING $label ($owner/$project) -- no F${TARGET} build yet"
        ALL_OK=false
    fi
}

echo ""
echo "Fedora ${CURRENT} -> ${TARGET} upgrade readiness check"
echo "======================================================="
echo ""
echo "COPRs:"
check_copr sdegler     hyprland        "Hyprland (latest)"
check_copr emixampp    synology-drive  "Synology Drive"

echo ""
if $ALL_OK; then
    echo "All checks passed -- safe to upgrade to F${TARGET}."
else
    echo "Not ready -- resolve the MISSING items before upgrading."
fi
echo ""

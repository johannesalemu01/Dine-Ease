#!/usr/bin/env bash
set -euo pipefail

# Simple helper to diagnose the Xcode destination/runtime issue and give instructions.
REQUESTED_IOS_VERSION="18.4"

echo "Checking installed iOS simulator runtimes..."
if xcrun --version >/dev/null 2>&1; then
  if xcrun simctl list runtimes | grep -i "iOS ${REQUESTED_IOS_VERSION}" >/dev/null 2>&1; then
    echo "iOS ${REQUESTED_IOS_VERSION} runtime is installed."
  else
    echo "iOS ${REQUESTED_IOS_VERSION} runtime is NOT installed."
    echo
    echo "Install options:"
    echo "  1) Open Xcode -> Settings -> Components -> download 'iOS ${REQUESTED_IOS_VERSION}' simulator runtime."
    echo "     (Open Xcode now: open -a Xcode)"
    echo "  2) Use an available simulator instead. Available runtimes:"
    xcrun simctl list runtimes
    echo
    echo "Available devices (booted or not):"
    xcrun simctl list devices
    echo
    echo "To run on an available simulator with flutter, pick a device id from the list above and run:"
    echo "  flutter run -d <device-id>"
    echo
    echo "To list Flutter-recognized devices:"
    echo "  flutter devices"
    exit 1
  fi
else
  echo "xcrun not found. Ensure Xcode command line tools are installed."
  echo "Run: xcode-select --install"
  exit 1
fi

echo
echo "If you still see the Xcode destination error after installing the runtime:"
echo "  • Quit Xcode & Simulator, run: flutter clean"
echo "  • Run: flutter pub get"
echo "  • Relaunch the desired simulator (open -a Simulator) and re-run: flutter run"
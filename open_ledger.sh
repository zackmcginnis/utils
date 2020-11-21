#!/bin/bash

set -eu

# Opens ledger live app image with necessary permissions. 
# Required for proper functionality of Ledger app
sudo ~/AppImages/ledger-live-desktop-2.15.0-linux-x86_64.AppImage --no-sandbox
#!/bin/bash
set -e

echo "Cleaning up unnecessary packages..."
sudo zypper clean
sudo zypper autoremove

echo "Cleanup completed."

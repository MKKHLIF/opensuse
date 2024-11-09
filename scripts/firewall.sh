#!/bin/bash
set -e

echo "Setting up the firewall..."
sudo firewallctl default-zone=public
sudo firewallctl add-service=ssh
sudo firewallctl add-service=http
sudo firewallctl add-service=https

echo "Firewall setup complete."

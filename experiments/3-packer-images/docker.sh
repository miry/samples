#!/usr/bin/env bash

set -euo pipefail

sudo yum install -y docker
sudo systemctl enable docker

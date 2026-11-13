#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

bundle exec ruby "$(bundle show rubocop)/exe/rubocop"
bundle exec rspec

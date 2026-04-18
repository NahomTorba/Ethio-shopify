#!/bin/bash
cd "$(dirname "$0")"
source .env
bundle exec puma -C config/puma.rb

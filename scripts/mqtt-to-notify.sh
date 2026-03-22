#!/usr/bin/env bash
set -euo pipefail

BROKER="${MQTT_HOST:-${1:-test.mosquitto.org}}"
TOPIC="${MQTT_TOPIC:-${2:-ci/#}}"

if ! command -v mosquitto_sub >/dev/null 2>&1; then
  echo "mosquitto_sub is required" >&2
  exit 1
fi

if ! command -v send-notify >/dev/null 2>&1; then
  echo "send-notify is required in PATH" >&2
  exit 1
fi

mosquitto_sub -h "$BROKER" -v -t "$TOPIC" | while IFS= read -r line; do
  topic="${line%% *}"
  payload="${line#* }"
  send-notify "$topic" "$payload"
done

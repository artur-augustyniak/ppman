#!/bin/bash

ACTION="$1"

IPTABLES_RULES=(
  "-i virbr0 -d 10.0.0.0/8 -j DROP"
  "-i virbr0 -d 172.16.0.0/12 -j DROP"
  "-i virbr0 -d 192.168.0.0/16 -j DROP"
)

IP6TABLES_RULES=(
  "-i virbr0 -d fe80::/10 -j DROP"
  "-i virbr0 -d fd00::/8 -j DROP"
)

wait_for_libvirt_rules() {
  echo "🕓 Waiting for LIBVIRT_FWO to appear in FORWARD chain..."
  for i in {1..20}; do
    if iptables -S FORWARD | grep -q 'LIBVIRT_FWO'; then
      echo "✅ libvirt FORWARD chains detected."
      return
    fi
    sleep 1
  done
  echo "⚠️ Timeout waiting for libvirt to configure iptables."
}

add_rules() {
  wait_for_libvirt_rules
  for rule in "${IPTABLES_RULES[@]}"; do
    iptables -C FORWARD $rule 2>/dev/null || iptables -I FORWARD $rule
  done
  for rule in "${IP6TABLES_RULES[@]}"; do
    ip6tables -C FORWARD $rule 2>/dev/null || ip6tables -I FORWARD $rule
  done
}

remove_rules() {
  for rule in "${IPTABLES_RULES[@]}"; do
    iptables -D FORWARD $rule 2>/dev/null
  done
  for rule in "${IP6TABLES_RULES[@]}"; do
    ip6tables -D FORWARD $rule 2>/dev/null
  done
}

case "$ACTION" in
  start)
    add_rules
    ;;
  stop)
    remove_rules
    ;;
  *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac

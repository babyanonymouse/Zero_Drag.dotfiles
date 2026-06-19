#!/bin/sh
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/lock-watchdog.lock"
flock -n 9 || exit 0

while true; do
    qs -c lock ipc show >/dev/null 2>&1 || qs -c lock -d 9>&- 2>/dev/null
    sleep 5
done

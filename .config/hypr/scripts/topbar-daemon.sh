#!/bin/sh
i=0
while [ "$i" -lt 10 ]; do
    pgrep -f "qs -c topbar" >/dev/null && exit 0
    qs -c topbar -d 2>/dev/null
    sleep 2
    i=$((i + 1))
done

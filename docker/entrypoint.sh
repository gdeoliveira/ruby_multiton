#!/bin/ash

# Add `dockerhost` host to `/etc/hosts` file if it isn't already present.
DOCKERHOST_ENTRY_REGEX="^\s*\d\+\.\d\+\.\d\+\.\d\+\s\+.*\bdockerhost\b"
if ! grep -q "$DOCKERHOST_ENTRY_REGEX" /etc/hosts
then
	DOCKERHOST_ENTRY="$(ip route|awk '/default/ { print $3 }')\tdockerhost"
	echo -e "$DOCKERHOST_ENTRY" >> /etc/hosts
fi

exec "$@"

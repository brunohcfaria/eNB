#!/usr/bin/env bash
set -Eeuo pipefail

if [ "$#" -eq 0 ]; then
	exec bash
else
# read the command line arguments and pass to the daemon
	exec python3 -u /usr/src/eNB/eNB_LOCAL.py "$@"

fi

exec "$@"
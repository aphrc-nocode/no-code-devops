#!/bin/bash
set -euo pipefail

APP_DIR=/usr/no-code-app
DB_FILE="$APP_DIR/users_db/users.sqlite"
TEMPLATE="$APP_DIR/users_db/users_template.sqlite"
ENV_FILE="$APP_DIR/.env"

# ------------------------------------------------------------------
# Runtime configuration check
#
# .env is no longer baked into the image. start.sh writes it into the
# nocode_userdata volume before the stack is deployed, and that volume is
# mounted at $APP_DIR, so the file is in place before this script runs.
#
# The app loads it itself with readRenviron(".env"). We only confirm it is
# there and readable, so a misconfigured deploy fails immediately with a
# clear message instead of starting an app with empty credentials.
#
# Do NOT source this file. It is Renviron format, not shell. Sourcing it
# would let anything inside it be evaluated by bash, and would break on
# values that are legal in Renviron but not in shell.
# ------------------------------------------------------------------
if [ ! -r "$ENV_FILE" ]; then
    echo "FATAL: $ENV_FILE is missing or unreadable." >&2
    echo "       Deploy with: ./start.sh --env-file /path/to/.env" >&2
    exit 1
fi

# Copy template only if DB doesn't exist
if [ ! -f "$DB_FILE" ]; then
    cp "$TEMPLATE" "$DB_FILE"
fi

# Start Shiny app
exec R -q -e "shiny::runApp('$APP_DIR', host='0.0.0.0', port=3838)"

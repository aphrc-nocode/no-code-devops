#!/bin/bash
DB_FILE=/usr/no-code-app/users_db/users.sqlite
TEMPLATE=/usr/no-code-app/users_db/users_template.sqlite

# Copy template only if DB doesn't exist
if [ ! -f "$DB_FILE" ]; then
    cp "$TEMPLATE" "$DB_FILE"
fi

# Start Shiny app
exec R -q -e "shiny::runApp('/usr/no-code-app', host='0.0.0.0', port=3838)"


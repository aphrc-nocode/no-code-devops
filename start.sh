#!/bin/bash

cd "$(dirname "$0")"

echo "Starting No-Code Platform..."
echo "This will build and start both containers:"
echo "  - Shiny app on http://localhost:3838"
echo "  - Python API on http://localhost:8000"
echo ""

docker compose -f docker-compose-full.yml up --build

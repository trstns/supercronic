#!/bin/sh
set -e

CRONTAB_FILE="/etc/crontabs/crontab"

# If CRON_SCHEDULE environment variable is set and no crontab file exists, create one
if [ -n "$CRON_SCHEDULE" ] && [ ! -f "$CRONTAB_FILE" ]; then
    echo "Creating crontab from CRON_SCHEDULE environment variable"
    echo "$CRON_SCHEDULE" > "$CRONTAB_FILE"
fi

# Check if crontab file exists
if [ ! -f "$CRONTAB_FILE" ]; then
    echo "ERROR: No crontab file found at $CRONTAB_FILE and CRON_SCHEDULE not set"
    echo ""
    echo "Please either:"
    echo "  1. Mount a crontab file to /etc/crontabs/crontab"
    echo "  2. Set the CRON_SCHEDULE environment variable"
    echo ""
    echo "Example with mounted file:"
    echo "  docker run -v /path/to/crontab:/etc/crontabs/crontab:ro yourusername/supercronic"
    echo ""
    echo "Example with environment variable:"
    echo "  docker run -e CRON_SCHEDULE='*/5 * * * * echo hello' yourusername/supercronic"
    exit 1
fi

# Run supercronic with the crontab
echo "Starting supercronic with crontab: $CRONTAB_FILE"
exec supercronic "$CRONTAB_FILE"

# Supercronic Docker Image

Cross-platform Docker image for [supercronic](https://github.com/aptible/supercronic) - a crontab-compatible job runner designed for containers.

## Supported Architectures

- `linux/amd64`
- `linux/arm64`
- `linux/arm/v7`
- `linux/386`

## Usage

### Option 1: Using CRON_SCHEDULE Environment Variable

```bash
docker run -e CRON_SCHEDULE='*/5 * * * * echo "Hello from supercronic"' trstns/supercronic
```

### Option 2: Mounting a Crontab File

Create a crontab file:

```bash
# my-crontab
*/5 * * * * echo "Hello from supercronic"
0 2 * * * /path/to/backup.sh
```

Run with mounted crontab:

```bash
docker run -v $(pwd)/my-crontab:/etc/crontabs/crontab:ro trstns/supercronic
```

## Docker Compose Example

```yaml
version: '3.8'

services:
  cron-job:
    image: trstns/supercronic:latest
    environment:
      - CRON_SCHEDULE=*/5 * * * * echo "Running every 5 minutes"
      - TZ=America/New_York
    restart: unless-stopped

  cron-with-file:
    image: trstns/supercronic:latest
    volumes:
      - ./crontab:/etc/crontabs/crontab:ro
      - ./scripts:/scripts:ro
    environment:
      - TZ=UTC
    restart: unless-stopped
```

## Crontab Format

Supercronic supports standard cron syntax plus second-resolution schedules:

```bash
# Standard cron (minute resolution)
*/5 * * * * /path/to/script.sh

# Second resolution (7 fields)
*/30 * * * * * * echo "Every 30 seconds"

# Named schedules
@hourly /path/to/hourly-task.sh
@daily /path/to/daily-task.sh
```

## Environment Variables

- `CRON_SCHEDULE` - Cron schedule string (used if no crontab file is mounted)
- `TZ` - Timezone (e.g., `America/New_York`, `Europe/London`)

## Automatic Updates

This image is automatically built daily via GitHub Actions. When a new version of supercronic is released, the workflow:

1. Detects the new version
2. Updates the Dockerfile
3. Builds multi-architecture images
4. Pushes to Docker Hub with version tag and `latest` tag

## Setup Instructions

1. Fork this repository
2. Add GitHub Secrets:
   - `DOCKER_USERNAME` - Your Docker Hub username
   - `DOCKER_PASSWORD` - Your Docker Hub access token
3. Update the image name in `.github/workflows/docker-build.yml` (replace `trstns/supercronic`)
4. The workflow will run automatically on schedule or manually via GitHub Actions

## Building Locally

```bash
# Build for current architecture
docker build -t supercronic .

# Build for all architectures
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7,linux/386 -t trstns/supercronic .
```

## License

This Docker image wraps [supercronic](https://github.com/aptible/supercronic), which is licensed under MIT.

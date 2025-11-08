# supercronic
Docker image for aptible/supercronic



docker run --rm --interactive --tty --env CRON='* * * * * echo "Running"' supercronic-test

$(curl -s "https://api.github.com/repos/aptible/supercronic/releases/latest" | jq -r '.assets | map(select(.name == "supercronic-linux-amd64")) | .[0].digest')



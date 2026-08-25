# Samples

`monitrc` in this directory is a minimal working config: it checks
https://www.google.com and notifies Slack on state changes.

## Run it

```sh
docker run -it \
  -p 2812:2812 \
  -v "$(pwd)/monitrc:/etc/monitrc" \
  -e "SLACK_URL=<SLACK_URL>" \
  -e "PUSH_OVER_TOKEN=<PUSH_OVER_TOKEN>" \
  -e "PUSH_OVER_USER=<PUSH_OVER_USER>" \
  ghcr.io/diogopms/monit-docker
```

## Debug mode

Add `-e "DEBUG=1"` to run Monit in verbose mode:

```sh
docker run -it \
  -p 2812:2812 \
  -v "$(pwd)/monitrc:/etc/monitrc" \
  -e "SLACK_URL=<SLACK_URL>" \
  -e "DEBUG=1" \
  ghcr.io/diogopms/monit-docker
```

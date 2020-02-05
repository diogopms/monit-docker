# Need help?

## Normal mode

```sh
docker run -it \
  -p 2812:2812 \
  -v $(pwd)/monitrc:/etc/monitrc \
  -e "SLACK_URL=<SLACK_URL>" \
  -e "PUSH_OVER_TOKEN=<PUSH_OVER_TOKEN>" \
  -e "PUSH_OVER_USER=<PUSH_OVER_USER>" \
  -e "DEBUG=1" \
  diogopms/monit-docker-kubernetes
```

## Debug

```sh
docker run -it \
  -p 2812:2812 \
  -v $(pwd)/monitrc:/etc/monitrc \
  -e "SLACK_URL=<SLACK_URL>" \
  -e "PUSH_OVER_TOKEN=<PUSH_OVER_TOKEN>" \
  -e "PUSH_OVER_USER=<PUSH_OVER_USER>" \
  -e "DEBUG=0" \
  diogopms/monit-docker-kubernetes
```

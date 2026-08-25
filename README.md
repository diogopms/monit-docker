# monit-docker

[![Release](https://github.com/diogopms/monit-docker/actions/workflows/release.yml/badge.svg)](https://github.com/diogopms/monit-docker/actions/workflows/release.yml)
[![CI](https://github.com/diogopms/monit-docker/actions/workflows/ci.yml/badge.svg)](https://github.com/diogopms/monit-docker/actions/workflows/ci.yml)
[![Latest release](https://img.shields.io/github/v/release/diogopms/monit-docker)](https://github.com/diogopms/monit-docker/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[Monit](https://mmonit.com/monit/) packaged as a small Alpine-based Docker image, with built-in [Slack](https://slack.com) and [Pushover](https://pushover.net) notification scripts.

Monit is a free open-source utility for managing and monitoring processes, programs, files, directories and filesystems on UNIX systems. It conducts automatic maintenance and repair and can execute meaningful causal actions in error situations.

## Image

```
ghcr.io/diogopms/monit-docker
```

| Tag | Meaning |
|---|---|
| `latest` | Latest release |
| `X` | Latest release in that major version |
| `X.Y` | Latest release in that minor version |
| `X.Y.Z` | Exact release |

Supported platforms: `linux/amd64`, `linux/arm64` (Raspberry Pi 3/4/5 with a 64-bit OS).

## Quick start

Write a `monitrc` (see [samples/](samples/) and the examples below), then:

```sh
docker run -d \
  -p 2812:2812 \
  -v "$(pwd)/monitrc:/etc/monitrc" \
  ghcr.io/diogopms/monit-docker
```

Or with Docker Compose ([docker-compose.yaml](docker-compose.yaml)):

```yaml
services:
  monit:
    image: ghcr.io/diogopms/monit-docker:latest
    container_name: monit
    environment:
      - TZ=Europe/Lisbon
    volumes:
      - ./monitrc:/etc/monitrc
    ports:
      - 2812:2812
    restart: unless-stopped
```

To use Monit's web interface, uncomment `set httpd port 2812` in your `monitrc` and open http://localhost:2812.

## Configuration

Mount your Monit control file at `/etc/monitrc`. The entrypoint copies it to a root-owned file with `0700` permissions before starting Monit (Monit refuses configs with looser permissions), so you don't need to fix permissions on the host.

### Environment variables

| Variable | Description |
|---|---|
| `SLACK_URL` | Slack incoming-webhook URL (required for `/bin/slack`) |
| `PUSH_OVER_TOKEN` | Pushover API token (required for `/bin/pushover`) |
| `PUSH_OVER_USER` | Pushover API user key (required for `/bin/pushover`) |
| `DEBUG` | Set to `1` to run Monit in verbose mode |

```sh
docker run -d \
  -p 2812:2812 \
  -v "$(pwd)/monitrc:/etc/monitrc" \
  -e "SLACK_URL=<SLACK_URL>" \
  -e "PUSH_OVER_TOKEN=<PUSH_OVER_TOKEN>" \
  -e "PUSH_OVER_USER=<PUSH_OVER_USER>" \
  ghcr.io/diogopms/monit-docker
```

## Notifications

The image ships two notification scripts you can call from `exec` actions in your `monitrc`:

- `/bin/slack` — posts the Monit event to a Slack incoming webhook (`SLACK_URL`)
- `/bin/pushover` — sends the Monit event via Pushover (`PUSH_OVER_TOKEN` + `PUSH_OVER_USER`)

### Example `monitrc` (Slack)

```
set daemon 20
set log syslog
# Web interface
# set httpd port 2812 and allow admin:monit

check host www.google.com with address www.google.com
  if failed
      port 443 protocol https
      request /
      status = 200
      for 2 cycles
  then exec "/bin/slack"
    else if succeeded then exec "/bin/slack"
```

### Example `monitrc` (Pushover)

```
set daemon 20
set log syslog
# Web interface
# set httpd port 2812 and allow admin:monit

check host www.google.com with address www.google.com
  if failed
      port 443 protocol https
      request /
      status = 200
      for 2 cycles
  then exec "/bin/pushover"
    else if succeeded then exec "/bin/pushover"
```

More examples in [samples/](samples/).

## Building locally

```sh
docker build -t monit .
docker run -d -p 2812:2812 -v "$(pwd)/monitrc:/etc/monitrc" monit
```

The build compiles Monit from source (checksum-verified) in a builder stage and ships only the compiled binary plus runtime dependencies.

## Releases & versioning

Versions follow [SemVer](https://semver.org/) driven by [Conventional Commits](https://www.conventionalcommits.org/):

- A scheduled workflow runs monthly; if any `feat`/`fix`/breaking commit landed since the last tag, it builds and pushes the multi-arch image to GHCR, then creates the git tag and GitHub Release.
- `fix:` → patch, `feat:` → minor, `feat!:`/`BREAKING CHANGE` → major. Anything else does not release.
- A release can be forced manually: Actions → Release → "Run workflow" → pick a bump level.

## Troubleshooting

- **`The control file '/etc/monitrc' permission 0755 is wrong, maximum 0700 allowed`** — the entrypoint normally handles this; if you run Monit against the mounted file directly, run `chmod 700 monitrc` on the host.
- **Verbose logging** — set `DEBUG=1` to start Monit with `-v`.

## License

[MIT](LICENSE)

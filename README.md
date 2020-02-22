# Monit - Docker/Kubernetes - UNIX Systems Management

Run Monit inside docker ( )

[![Monit](https://mmonit.com/monit/img/logo.png)](https://mmonit.com/monit/)

[Monit](https://mmonit.com/monit/) is a free open source utility for managing and monitoring, processes, programs, files, directories and filesystems on a UNIX system. Monit conducts automatic maintenance and repair and can execute meaningful causal actions in error situations.

## Supported architectures

- amd64
- arm32v6 (Raspberry Pi) [diogopms/monit-docker-kubernetes:arm32v6-latest](https://hub.docker.com/r/diogopms/monit-docker-kubernetes/tags?page=1&name=arm)

## Docker setup

Install docker: https://docs.docker.com/engine/installation/
Install docker compose: https://docs.docker.com/compose/install/
Docker documentation: https://docs.docker.com/

### Build-in docker image

- build docker image `docker build -t monit .`
- start monit: `docker run -ti -p 2812:2812 -v $(pwd)/monitrc:/etc/monitrc monit`

## ENV VARS

| ENVs            	| Description                                              	|
|-----------------	|----------------------------------------------------------	|
| SLACK_URL       	| Webhook url for slack notifications (required for slack) 	|
| PUSH_OVER_TOKEN 	| Push over api token (required for pushover)              	|
| PUSH_OVER_USER  	| Push over api user (requiredfor pushover)                	|
| DEBUG           	| If set with 1 it will put monit in verbose mode          	|

### Docker Hub image

- pull docker image from docker hub: `docker pull diogopms/monit-docker-kubernetes`
- start monit: `docker run -ti -p 2812:2812 -v $(pwd)/monitrc:/etc/monitrc diogopms/monit-docker-kubernetes`
- create a docker container:

```
#Normal mode (support slack and pushover)
docker run -it \
  -p 2812:2812 \
  -v $(pwd)/monitrc:/etc/monitrc \
  -e "SLACK_URL=<SLACK_URL>" \
  -e "PUSH_OVER_TOKEN=<PUSH_OVER_TOKEN>" \
  -e "PUSH_OVER_USER=<PUSH_OVER_USER>" \
  diogopms/monit-docker-kubernetes

#Debug mode
docker run -it \
  -p 2812:2812 \
  -v $(pwd)/monitrc:/etc/monitrc \
  -e "SLACK_URL=<SLACK_URL>" \
  -e "PUSH_OVER_TOKEN=<PUSH_OVER_TOKEN>" \
  -e "PUSH_OVER_USER=<PUSH_OVER_USER>" \
  -e "DEBUG=1" \
  diogopms/monit-docker-kubernetes
```

### Example monitrc (Slack)

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
EOF
```

### Example monitrc (Pushover)

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
EOF
```

### Supported notifications

- [Slack](https://www.slack.com)
- [Pushover](https://pushover.net)

### Kubernetes

### Troubleshooting

If when starting Monit returns the following message: `The control file '/etc/monitrc' permission 0755 is wrong, maximum 0700 allowed`, simply give the appropriate permissions to _monitrc_: `chmod 700 monitrc`.

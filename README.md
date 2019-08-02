# Monit - Docker/Kubernetes - UNIX Systems Management

Run Monit inside docker.

[![Monit](https://mmonit.com/monit/img/logo.png)](https://mmonit.com/monit/)

[Monit](https://mmonit.com/monit/) is a free open source utility for managing and monitoring, processes, programs, files, directories and filesystems on a UNIX system. Monit conducts automatic maintenance and repair and can execute meaningful causal actions in error situations.

## Docker setup

Install docker: https://docs.docker.com/engine/installation/
Install docker compose: https://docs.docker.com/compose/install/
Docker documentation: https://docs.docker.com/

### Build-in docker image

- build docker image `docker build -t monit .`
- start monit: `docker run -ti -p 2812:2812 -v $(pwd)/monitrc:/etc/monitrc monit`

### Docker Hub image

- pull docker image from docker hub: `docker pull diogopms/monit-docker-kubernetes`
- start monit: `docker run -ti -p 2812:2812 -v $(pwd)/monitrc:/etc/monitrc diogopms/monit-docker-kubernetes`
- create a docker container:

```
docker run -it \
  -p 2812:2812 \
  -v $(pwd)/monitrc:/etc/monitrc \
  -e "SLACK_URL=<SLACK_URL>" \
  diogopms/monit-docker-kubernetes
```

### Example monitrc

```
set daemon 20
set log syslog

check host <Monitor name> with address <URL>
  if failed
      port 443 protocol https
      request /route
      status = 400
      content = "XPTO"
      for 2 cycles
  then exec "/bin/slack"
    else if succeeded then exec "/bin/slack"
EOF
```

### Troubleshooting

If when starting Monit returns the following message: `The control file '/etc/monitrc' permission 0755 is wrong, maximum 0700 allowed`, simply give the appropriate permissions to _monitrc_: `chmod 700 monitrc`.

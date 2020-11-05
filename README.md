# Setup with Compose - not a swarm stack
Can't do this as a stack yet because you need a privileged container
```shell
docker-compose -f alternative-compose.yml up -d
```
Goto: Usage

# Setup with systemd
```shell
cp docker-event-listener.sh /usr/local/bin
chmod 0744 /usr/local/bin docker-event-listener.sh

cp docker-event-listener.service /etc/systemd/system/
chmod 744 /etc/systemd/system/docker-event-listener.service
systemctl daemon-reload
systemctl start docker-event-listener.service
systemctl enable docker-event-listener.service
```

# Usage
Add a label to the container, not the service, of volume.device=/dev/whatever
Also, volume mount the device

In your stack yaml
```yaml
services:
  zigbee:
    image: koenkk/zigbee2mqtt:latest
    volumes:
      - /dev/ttyUSB0:/dev/ttyUSB0
    deploy:
      placement:
        constraints:
          # Place it on the rpi
          - node.labels.rpi == true
    # needs to be a local docker non-swarm label
    labels:
      - "volume.device=/dev/ttyUSB0"
```

# How?
This will listen for container startup events that have the container label volume.device. It will then create the right permissions for the device object so that the container is allowed to rw the device as if you used --devices.

# Influences
[zigbee2mqtt](https://www.zigbee2mqtt.io/information/docker.html)


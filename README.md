# 12/2022 - I really wouldn't use this, it breaks and is rather messy

# Wtf?
Until we have capabilities or device support in swarm....

This will deploy a docker:dind container to your swarm that starts a docker container that watches for events and assigns permissions for devices mapped via volumes so you can use swarm to manage zwave2mqtt, zigbee2mqtt, maybe even GPU for Emby/Jellyfin/Plex


# Setup with Compose - not a swarm stack
Can't do this as a stack yet because you need a privileged container
```shell
docker stack deploy -c swarm.yml devices
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


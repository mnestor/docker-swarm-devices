#!/bin/bash

while read event; do
    DEVICE=`echo $event | cut -d"," -f1`
    CID=`echo $event | cut -d"," -f2`

    USBDEV=`readlink -f ${DEVICE}`
    read minor major < <(stat -c '%T %t' $USBDEV)
    if [[ -z $minor || -z $major ]]; then
        echo 'Device not found'
        continue
    fi
    dminor=$((0x${minor}))
    dmajor=$((0x${major}))
    echo "Setting permissions for ${CID} to device (${DEVICE})"
    echo "c $dmajor:$dminor rwm" > /sys/fs/cgroup/devices/docker/$CID/devices.allow
done < <(docker events  --filter 'label=volume.device' --filter 'event=start' --format '{{index .Actor.Attributes "volume.device"}},{{.Actor.ID}}')
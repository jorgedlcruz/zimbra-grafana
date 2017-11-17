#!/bin/bash
if [ -f /etc/redhat-release ]; then
  rpm -q --queryformat "%{version}" zimbra-core | awk -F. '{print $1"."$2"."$3 }' | awk -F_ '{print $1" "$2 }'
fi

if [ -f /etc/lsb-release ]; then
  dpkg -s zimbra-core | awk -F"[ ',]+" '/Version:/{print $2}' | awk -F. '{print $1"."$2"."$3" "$4}'
fi

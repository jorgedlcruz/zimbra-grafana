#!/bin/bash
dpkg -s zimbra-core | awk -F"[ ',]+" '/Version:/{print $2}' | awk -F. '{print $1"."$2"."$3" "$4}'
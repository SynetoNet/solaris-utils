#!/usr/bin/env bash

PKGSERVER_SERVICES=$(svcs -H pkg/server | grep -v disabled | awk '{print $3}')

for service in ${PKGSERVER_SERVICES}; do
	instance=$(echo $service | awk -F ':' '{print $3}')
	echo -n "Repository service instance '$instance' is on port "
	svccfg -s $instance listprop | grep port | awk '{print $3}'
done | sort -nk8

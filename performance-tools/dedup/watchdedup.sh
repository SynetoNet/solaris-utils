#!/usr/bin/env bash

dtrace -n 'ddt*:entry,zio_ddt*:entry /probefunc != "ddt_stat_add" && probefunc != "ddt_histogram_add" && probefunc != "ddt_prefetch"/ {@[stack(),probename,probefunc] = count(); trunc(@, 5); }'

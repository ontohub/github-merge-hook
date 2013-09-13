#!/bin/sh
[ -z "$KEY" ] && ssh "$@" || ssh -i "$KEY" "$@"

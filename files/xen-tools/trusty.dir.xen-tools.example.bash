#!/usr/bin/env bash

thisDir="$(cd "$(dirname "$0")" && pwd)"
thisBasename="$(basename "$0")"
thisBase="${thisBasename%.*}"
xtConfPath="$thisDir/$thisBase.conf"
echo "xtConfPath: $xtConfPath"
xen-create-image --config=$xtConfPath --hostname trustydomu

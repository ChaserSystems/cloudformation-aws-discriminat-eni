#!/bin/bash

set -e
set -u
set -o pipefail
# set -x

_tmpdir=$(mktemp --directory)
myjq='jq --exit-status'


## 3az new vpc
cp .components/1az_new-vpc.json 1az_new-vpc.json
##

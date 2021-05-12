#!/usr/bin/env bash

set -o errexit
set -o pipefail

for fn in $(ls | grep -v README | grep -v LICENSE | grep -v "$(basename $0)")
do
    ln -sfv $PWD/${fn} ~/.${fn}
done

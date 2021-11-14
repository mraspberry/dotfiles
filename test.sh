#!/usr/bin/env bash

set -o errexit
set -o pipefail

fail() {
    echo "$*" >&2
    exit 1
}

echo "Running install.sh"
./install.sh || fail "failed"
echo "done"

echo -e "Checking links ... \c"
for fn in .bashrc .vimrc .gitconfig
do
    test -L ${INSTALL_DIR}/${fn} || fail "${fn} not a link"
done

echo -e "Checking for asdf ... \c"
test -d ${INSTALL_DIR:=${HOME}}/.asdf || fail "failed. ASDF directory not present"
echo "done"

echo -e "Checking for rust ... \c"
test -d ${INSTALL_DIR}/.cargo || fail "failed. Cargo directory not present"
echo "done"

echo -e "Checking for nerdtree vim plugin ... \c"
test -d ${INSTALL_DIR}/.vim/pack/vendor/start/nerdtree || fail "failed. Nerdtree dir not present"
echo "done"

echo -e "Checking for commands installed by asdf ... \c"
COMMANDS=("python --version" "node --version" "go version" "yarn --version")
source ${INSTALL_DIR}/.asdf/asdf.sh
for cmd in "${COMMANDS[@]}"
do
    eval ${cmd} || "failed. ${cmd} failed"
done
echo "done"

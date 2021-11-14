#!/usr/bin/env bash

set -o errexit
set -o pipefail

mkdir -p "${INSTALL_DIR:=${HOME}}"
export RUSTUP_HOME="${INSTALL_DIR}"
export CARGO_HOME="${INSTALL_DIR}/.cargo"

FILES=(bashrc vimrc gitconfig)

for fn in "${FILES[@]}"
do
    ln -sfv "$PWD/${fn}" "${INSTALL_DIR}/.${fn}"
done

case $(uname) in
    Darwin)
        chsh -s /bin/bash
        echo "test -f ${INSTALL_DIR}/.bashrc && source ${INSTALL_DIR}/.bashrc" > ${INSTALL_DIR}/.profile
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install jq wget gnupg
        ;;
    *)
        ;;
esac

git clone https://github.com/asdf-vm/asdf.git ${INSTALL_DIR}/.asdf --branch v0.8.1
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup-init
chmod +x rustup-init && ./rustup-init -y

git clone https://github.com/preservim/nerdtree.git ${INSTALL_DIR}/.vim/pack/vendor/start/nerdtree
vim -u NONE -c "helptags ${INSTALL_DIR}/.vim/pack/vendor/start/nerdtree/doc" -c q
source ${INSTALL_DIR}/.asdf/asdf.sh
env
PLUGINS=("python" "nodejs" "golang" "yarn")
for plugin in "${PLUGINS[@]}"
do
    asdf plugin add "${plugin}"
    asdf install "${plugin}" latest
    asdf global "${plugin}" latest
done

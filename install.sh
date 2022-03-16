#!/usr/bin/env bash

set -o errexit
set -o pipefail

FILES=("bashrc" "vimrc" "gitconfig" "tmux.conf")
for fn in ${FILES[@]}
do
    ln -sfv $PWD/${fn} ~/.${fn}
done

case $(uname) in
    Darwin)
        chsh -s /bin/bash
        echo "test -f ~/.bashrc && source ~/.bashrc" > ~/.profile
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install jq wget gnupg
        ;;
    *)
        ;;
esac

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup-init
chmod +x rustup-init && ./rustup-init -y

git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q
source ~/.bashrc
env
PLUGINS=("python" "nodejs" "golang" "yarn")
for plugin in "${PLUGINS[@]}"
do
    asdf plugin add "${plugin}"
    asdf install "${plugin}" latest
    asdf global "${plugin}" latest
done

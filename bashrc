_f_set_aliases() {
    alias c=clear
    alias rld='source ~/.bashrc'
    alias vi=vim
    alias pipenv='python3 -mpipenv'
    alias pip='python3 -mpip'
    alias va='source .venv/bin/activate'
    alias assume="source /usr/local/bin/assume"

    if [[ "$(uname)" == "Darwin" ]]
    then
        alias ctags='/usr/local/bin/ctags'
    fi
}

_f_set_prompt() {
    local ec=$?
    local ESC="\[\e[38;5;"
    local DPURPLE="${ESC}99m\]"
    local WHITE="${ESC}15m\]"
    local RESET="\e[38;0m\]"
    local GREEN="${ESC}84m\]"
    local RED="${ESC}196m\]"

    if [[ $ec -gt 0 ]]
    then
        local ESTR="${RED}${ec}"
    else
        local ESTR="${GREEN}${ec}"
    fi

    local GBRANCH
    GBRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
    if [[ -n "${GBRANCH}" ]]
    then
        local GSTR=" ${WHITE}[${RED}git: ${GBRANCH}${WHITE}] "
    else
        local GSTR=" "
    fi

    local VENV_STR
    if [[ -n "${VIRTUAL_ENV}" ]]
    then
        local VENV="${WHITE}[${RED}venv:$(basename $(dirname $VIRTUAL_ENV))${WHITE}] "
    else
        local VENV=""
    fi
    export PS1="\n${WHITE}[${ESTR}${WHITE}]${GSTR}${VENV}[${DPURPLE}\u${WHITE}] [${GREEN}\h${WHITE}] [${DPURPLE}\d${WHITE}] [${DPURPLE}\t${WHITE}] [${GREEN}\w${WHITE}]\n${GREEN}$ "
}

_f_set_env() {
    export PROMPT_COMMAND=_f_set_prompt
    export HISTTIMEFORMAT="%m/%d/%y %T "
    export PATH=~/.asdf/installs/nodejs/lts/.npm/bin:~/.local/bin:$HOME/src/flutter/bin:~/.pulumi/bin:$PATH

    [[ -f ~/.asdf/asdf.sh ]] && source $HOME/.asdf/asdf.sh
    [[ -f $HOME/.asdf/completions/asdf.bash ]] && source $HOME/.asdf/completions/asdf.bash
    [[ -d ~/.cargo ]] && source ~/.cargo/env
    [[ -d /opt/homebrew ]] && export PATH=$PATH:/opt/homebrew/bin
    [[ -d /usr/local/bin ]] && export PATH=$PATH:/usr/local/bin
    umask 022
    [[ -f ~/.additional_envs ]] && source ~/.additional_envs
    if [[ "$(uname)" == "Darwin" ]]
    then
        export BASH_SILENCE_DEPRECATION_WARNING=1
    fi
    export PULUMI_CONFIG_PASSPHRASE=
    export PULUMI_PREFER_YARN=true
    export AWS_DEFAULT_REGION=us-east-1
    # for granted
    export FORCE_NO_ALIAS=true
}

_f_set_completer() {
    complete -C "$(which aws_completer)" aws
}

_f_define_functions() {
    function super-linter() {
        docker image ls | grep -q super-linter || docker pull github/super-linter:latest
        docker run -e RUN_LOCAL=true -v $(git rev-parse --show-toplevel):/tmp/lint github/super-linter
    }
    function cdg() {
        cd $(git rev-parse --show-toplevel 2>/dev/null)
    }
    function dockerpurge() {
        docker container prune -f
        docker image ls -q | xargs docker rmi -f
        docker builder prune -af
        docker system prune -f
    }
}


case "$-" in
    *i*)
        export CDPATH=".:~/projects:~"
        _f_set_env
        _f_set_aliases
        _f_set_completer
        _f_define_functions
        [[ $(uname -r) == *"microsoft"* ]] || ulimit -n 8192
        shopt -s cdspell
        shopt -s checkwinsize
        ;;
    *) 
        _f_set_env
        ;;
esac

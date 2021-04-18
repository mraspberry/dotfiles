_f_set_aliases() {
    alias c=clear
    alias rld='source ~/.bashrc'
    alias vi=vim
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

    export PS1="\n${WHITE}[${ESTR}${WHITE}] [${DPURPLE}\u${WHITE}] [${GREEN}\h${WHITE}] [${DPURPLE}\d${WHITE}] [${DPURPLE}\t${WHITE}] [${GREEN}\w${WHITE}]\n${GREEN}$ "
}

_f_setup_env() {
    export PROMPT_COMMAND=_f_set_prompt
    export HISTTIMEFORMAT="%m/%d/%y %T "
    export PATH=~/node_modules/.bin:~/.local/bin:$HOME/src/flutter/bin:$PATH
    [[ -f ~/.cargo/env ]] && source ~/.cargo/env
    [[ -f ~/.asdf/asdf.sh ]] && source $HOME/.asdf/asdf.sh
    [[ -f $HOME/.asdf/completions/asdf.bash ]] && source $HOME/.asdf/completions/asdf.bash
    umask 022
}

_f_set_completer() {
    complete -C "$HOME/.local/bin/aws_completer" aws
}

case "$-" in
    *i*)
        _f_setup_env
        _f_set_aliases
        _f_set_completer
        shopt -s cdspell
        shopt -s checkwinsize
        ;;
    *) 
        ;;
esac
source "$HOME/.cargo/env"

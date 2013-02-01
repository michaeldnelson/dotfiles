
################################################
#                                              #
#                 Includes                     #
#                                              #
################################################
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_exports ]; then
    . ~/.bash_exports
fi
################################################ 
#                                              #
#                Functions                     #
#                                              #
################################################

set_new_pwd() {
    local pwdmaxlen=25
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
}

# Defines the prompt to be used at the end of $PS1.
#  - Returns standard '$' prompt when not in a Git repository
#  - Displays current working branch when in a Git repository
#  - Uses color to indicate if the working directory is clean
set_ps1_prompt() {
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    GIT_PS1_SHOWUPSTREAM=true

    local git_ps1=$(__git_ps1)

    if [[ -n $git_ps1 ]]; 
    then
        if [[ $(git status 2>/dev/null) == *'working directory clean'* ]]
        then
            PS1_PROMPT="\[\033[0;37m\]${git_ps1} \[\033[0;32m\]±\[\033[0m\]"
        elif [ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]
        then
            PS1_PROMPT="\[\033[0;37m\]${git_ps1} \[\033[0;31m\]±\[\033[0m\]"
        else
            PS1_PROMPT="\[\033[0;37m\]${git_ps1} ±\[\033[0m\]"
        fi
    else
        PS1_PROMPT=" \[\033[0;37m\]\$\[\033[0m\]"
    fi  
}

# Sets a custom $PS1 shell prompt
bash_prompt() {
    local nocolor="\[\033[0m\]"
    local g="\[\033[0;32m\]" # green
    local y="\[\033[0;33m\]" # yellow
    local b="\[\033[0;34m\]" # blue

    set_new_pwd
    set_ps1_prompt

    PS1="${g}\u@\h${nocolor}:${b}${NEW_PWD}${PS1_PROMPT} "
}

PROMPT_COMMAND=bash_prompt
bash_prompt
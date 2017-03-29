export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7
export WORKON_HOME=$HOME/.virtualenvs
source /usr/bin/virtualenvwrapper.sh

GO_WORKDIR="$HOME/repos/nir0s/go"
mkdir -p $GO_WORKDIR
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$GO_WORKDIR
export PATH=$PATH:$GOPATH/bin

export PATH=$PATH:/opt/vault
alias setvault='export VAULT_ADDR="http://vault.gspaces.com:8200"'

#alias ll='ls -la'

# fasd is the best :) Should always be enabled. z rules the world.
eval "$(fasd --init auto)"

# grep for open ports...
alias ssg='ss -lnpt | grep'

# Disable options:
shopt -u mailwarn
unset MAILCHECK        # Don't want my shell to warn me of incoming mail.

alias mkdir='mkdir -p'
alias c='clear'
alias r='reset'
alias h='history'
alias j='jobs -l'
alias ..='cd ..'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'

# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -lv --group-directories-first"
alias l="ll"
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

# git shortcuts
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit -am '
alias gd='git diff'
alias gco='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias gp='git pull'
alias gl='git log --oneline -n 10'
alias gr='git rebase -i'
alias autorebase='git checkout master && git pull && git checkout - && git rebase master'
alias tf='terraform'

alias png='ping 8.8.8.8'
alias pngd='ping www.google.com'

alias open='google-chrome-beta'

# 99% of the time using this virtualenv anyway
VENV_ON_SHELL_LOGIN='strigo'
source ~/.virtualenvs/${VENV_ON_SHELL_LOGIN}/bin/activate

export GHOST_STASH_PATH="~/Dropbox/work/strigo/stash.json[main]"
export GHOST_PASSPHRASE=$(cat ~/Dropbox/work/strigo/x)

# Easy cloning of cloudify repos...
function ccr() {
	local repo=$1
	local org=${2:-cloudify-cosmo}

	echo "Cloning $2/$1 to ~/repos/cloudify/$1..."
	git clone git@github.com:${org}/${repo} ~/repos/cloudify/${repo}
}

function csr() {
	local repo=$1
	local org="strigoio"

	echo "Cloning $2/$1 to ~/repos/strigo/$1..."
	git clone git@bitbucket.org:${org}/${repo}.git ~/repos/strigo/${repo}
}

function setvenv() {
	local new_venv=$1

	rpx in-path "~/.bashrc" --replace "VENV_ON_SHELL_LOGIN='.*'" --replace-with "VENV_ON_SHELL_LOGIN='${new_venv}'"
}


# Disable options:
shopt -u mailwarn
unset MAILCHECK        # Don't want my shell to warn me of incoming mail.

GO_WORKDIR="$HOME/repos/nir0s/go"
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$GO_WORKDIR
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/opt/vault

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Whichever vault I'm going to use, it should already be set for me to use when I tunnel it in.
export VAULT_ADDR="http://localhost:8200"
export VAULT_TOKEN=""

export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=$HOME/.virtualenvs

function set_aliases() {
	shwain info "Setting up aliases..."

	shwain info "Declaring general alises..."
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

	# grep for open ports...
	alias ssg='ss -lnpt | grep'

	alias png='ping 8.8.8.8'
	alias pngd='ping www.google.com'


	shwain info "Declaring directory aliases..."
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

	shwain info "Declaring app specific aliases..."
	# git shortcuts
	alias gk='gitk --all&'
	alias gx='gitx --all'

	# Other apps
	alias tf='terraform'
	alias open='google-chrome-beta'
}

function set_strigo_env() {
	# 99% of the time using this virtualenv anyway
	VENV_ON_SHELL_LOGIN='strigo'

	shwain info "Activating virtualenv..."
	source ~/.virtualenvs/${VENV_ON_SHELL_LOGIN}/bin/activate
	shwain info "Activating bash-completion for strigo cli..."
	eval "$(_STRIGO_COMPLETE=source strigo)"
}


function set_env() {
	shwain info "Activating fzf..."
	[ -f ~/.fzf.bash ] && source ~/.fzf.bash

	shwain info "Activating thefuck..."
	eval $(thefuck --alias)

	# fasd is the best :) Should always be enabled. z rules the world.
	shwain info "Activating fasd..."
	eval "$(fasd --init auto)"

	shwain info "Activating virtualenvwrapper..."
	source /usr/bin/virtualenvwrapper.sh
}

# Copy remote file contents to clipboard
function clip() {
    local host_address="$1"
    local remote_file_path="$2"

    ssh "${host_address}" "cat ${remote_file_path}" | xclip -selection c
}

# Clone a repository
function clone() {
    local repo="$1"

    echo "Cloning $1 to ~/repos/$1..."
    git clone git@github.com:${repo}.git ~/repos/${repo}
}

function strgrep() {
    local grep_for="$1"

    grep -nr --color "${grep_for}" . | gawk -F: '{print "L"$2" "$1" ("$3")"}'
}

function _main() {
	type "shwain" 2>/dev/null || sudo curl -L https://github.com/nir0s/shwain/raw/master/shwain -o /usr/bin/shwain && sudo chmod +x /usr/bin/shwain

	shwain info "Initializing shell..."

	set_aliases
	set_env
	set_strigo_env
}


_main "$@"

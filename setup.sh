#!/usr/bin/env bash

######
# Create my working environment.
# This will install relevant packages, clone relevant repositories,
# setup a working Python env and.. more..
######

function title() {
    message=$1

    echo -e "\e[34m#################################################\e[0m"
    echo -e "\e[34m# $message\e[0m"
    echo -e "\e[34m#################################################\e[0m"
}

function log() {
    message=$1

    echo -e "\e[32m###### $message\e[0m"
}

function error_exit() {
    local message=$1

    echo "\e[91m$message"
    exit 1
}

function install_package() {
    local package_name="$1"

    log "Installing ${package_name}..."
    pacman -Q ${package_Name} &> /dev/null
    if [ $? -ne 0 ]; then
        yaourt -S --noconfirm $package_name || error_exit "Failed to install ${package_name}"
    fi
}

function install_wmail() {
    local download_path="$HOME/Downloads"

    log "Installing Wmail..."
    sudo mkdir -p /opt/wmail
    if [ ! -f "$download_path/wmail.tar.gz" ]; then
        log "Downloading Wmail..."
        curl -L https://github.com/Thomas101/wmail/releases/download/v1.3.7/WMail_1_3_7_prerelease_linux_x64.tar.gz -o "$download_path/wmail.tar.gz"
    fi
    if [ ! -d "/opt/wmail" ]; then
        log "Extracting Wmail..."
        sudo tar -xzvf "$download_path/wmail.tar.gz" -C "/opt/wmail" --strip 1
    fi
    if [ ! -f "/usr/bin/wmail" ]; then
        log "Linking /opt/wmail/WMail to /usr/bin/wmail..."
        sudo ln -sf "/opt/wmail/WMail" "/usr/bin/wmail"
    fi
}

function install_jq() {
    local jq="/usr/bin/jq"

    log "Installing jq..."
    if [ ! -f "$jq" ]; then
        log "Downloading jq..."
        sudo curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o $jq
    fi
    log "Setting jq execution permissions..."
    sudo chmod +x $jq
}

function install_vault() {
    curl https://releases.hashicorp.com/vault/0.6.1/vault_0.6.1_linux_amd64.zip
}

function install_consul() {
    curl https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip
}

function install_sublime() {
    install_package "sublime-text-dev"
    mkdir -p "$HOME/.config/sublime-text-3/Packages/User"
    mkdir -p "$HOME/.config/sublime-text-3/Installed Packages"
    cp -R "$SETUP_PATH/config/sublime-text-3/Package Control.sublime-package" "$HOME/.config/sublime-text-3/Installed Packages"
    cp -R "$SETUP_PATH/config/sublime-text-3/Package Control.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
    cp -R "$SETUP_PATH/config/sublime-text-3/Preferences.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
}

function activate_virtualenvwrapper() {
    export VIRTUALENVWRAPPER_VIRTUALENV="/usr/bin/virtualenv"
    export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python2.7"
    export WORKON_HOME="$HOME/.virtualenvs"
    source "/usr/bin/virtualenvwrapper.sh"
}

function install_packages() {
    title "Installing relevant packages..."
    mkdir -p $HOME/.config
    # yaourt
    install_package "vim"
    install_package "git"
    install_sublime
    install_package "fasd"
    install_package "virtualbox"
    install_package "lxc"
    install_package "vagrant"
    install_package "terminator"
    cp -R "$SETUP_PATH/config/terminator" "$HOME/.config/"
    install_package "google-chrome-beta"
    install_package "slack-desktop"
    install_package "dropbox"
    install_package "teamviewer"
    install_package "gnome-shell-extension-taskbar"

    # direct download
    install_wmail
    install_jq

    # install_package "ttf-roboto-mono"
    # install_consul
    # install_vault
}

function install_vagrant_plugin() {
    local plugin_name="$1"

    vagrant plugin list | grep ${plugin_name} &> /dev/null
    if [ $? -ne 0 ]; then
        log "Installing vagrant plugin ${plugin_name}..."
        vagrant plugin install $plugin_name || error_exit "Failed to install ${plugin_name}"
    fi
}

function install_vagrant_plugins() {
    install_vagrant_plugin vagrant-vbguest
    install_vagrant_plugin vagrant-share
    install_vagrant_plugin vagrant-lxc
}

function pip_install() {
    local package_name=$1

    log "Installing $package_name..."

    pip freeze | tr '[:upper:]' '[:lower:]' | grep ${package_name} &> /dev/null
    if [ $? -ne 0 ]; then
        sudo pip install $package_name || error_exit "Failed to install ${package_name}"
    fi
}

function prepare_python_env() {
    title "Setting up Python environment..."

    # Make idempotent
    if [ ! -f '/tmp/get-pip.py' ]; then
        log "Downloading get-pip.py..."
        curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
    fi
    log "Installing pip for python2 and python3..."

    path_to_executable=$(which pip3)
    if [ ! -x "$path_to_executable" ] ; then
       sudo python3 /tmp/get-pip.py
    fi
    path_to_executable=$(which pip2)
    if [ ! -x "$path_to_executable" ] ; then
       sudo python2 /tmp/get-pip.py
    fi
    log "Making pip2 the default..."
    sudo ln -sf /usr/bin/pip2 /usr/bin/pip

    pip_install "pip --upgrade"
    pip_install "virtualenv"
    pip_install "virtualenvwrapper"
    pip_install "wagon"
    pip_install "serv"
    pip_install "ipython"
    pip_install "distro"
    pip_install "ghost"
}

function clone_repo() {
    local path=$1
    local destination="$REPOS_HOME/${2:-path}"

    log "Cloning $path..."
    if [ ! -d "${destination}" ]; then
       git clone "git@github.com:${path}" ${destination}
    fi
}

function create_dev_env() {
    local tool=$1
    local repo_path="$REPOS_HOME/nir0s/${tool}"

    log "Creating development environment for $tool..."
    clone_repo "nir0s/${tool}"
    log "Creating virtualenv..."
    mkvirtualenv $tool
    log "Installing $tool..."
    $HOME/.virtualenvs/${tool}/bin/pip install -e $repo_path
}

function setup_private_dev_envs() {
    local personal_repos_path="$REPOS_HOME/nir0s"

    title "Creating development environments..."
    activate_virtualenvwrapper
    mkdir -p $personal_repos_path

    create_dev_env "distro"
    create_dev_env "ghost"
    create_dev_env "serv"
    create_dev_env "python-packer"
    create_dev_env "logrotated"
}

function setup_cloudify_dev_env() {
    title "Setting up Cloudify development environemnt..."
    local cloudify_repos_path="$REPOS_HOME/cloudify"

    mkdir -p $cloudify_repos_path
    activate_virtualenvwrapper
    mkvirtualenv clue
    workon clue
    pip install clue
    clue env create -d $REPOS_HOME/cloudify --clone-method ssh
    clue apply

    clone_repo "cloudify-cosmo/wagon" "cloudify/wagon"
    clone_repo "cloudify-cosmo/repex" "cloudify/repex"
    clone_repo "cloudify-cosmo/surch" "cloudify/surch"
    clone_repo "cloudify-cosmo/cloudhealth-client" "cloudify/cloudhealth-client"


}

function config_git() {
    title "Configuring git..."
    git config --global user.email "nir36g@gmail.com"
    git config --global user.name "Nir Cohen"
}

function deploy_dotfiles() {
    title "Deploying .files..."
    cp $SETUP_PATH/.bashrc $HOME/.bashrc
    cp $SETUP_PATH/.inputrc $HOME/.inputrc
}

function main() {
    title "Preparing $(hostname)..."
    install_packages
    install_vagrant_plugins
    clone_repo "nir0s/.files"
    prepare_python_env
    setup_private_dev_envs
    setup_cloudify_dev_env
    config_git
    deploy_dotfiles
}

SETUP_PATH='/tmp/.files-master'
REPOS_HOME="$HOME/repos"

main

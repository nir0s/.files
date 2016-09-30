#!/usr/bin/env bash

######
# Create working environment.
# This will install relevant packages, clone relevant repositories,
# setup a working Python env and.. more..
######

function log() {
    message=$1
    echo "************ $message"
}

function error_exit() {
    message=$1
    log $message
    exit 1
}

function install_package() {
    package_name="$1"
    log "Installing ${package_name}..."
    sudo yaourt -S --noconfirm $package_name || error_exit "Failed to install ${package_name}"
}

function install_wmail() {
    log "Installing Wmail..."
    curl -O https://github.com/Thomas101/wmail/releases/download/v1.3.7/WMail_1_3_7_prerelease_linux_x64.tar.gz
}

function install_jq() {
    log "Installing jq..."
    curl -O https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
}


function install_packages() {
    # yaourt
    install_package "git"
    install_package "sublime-text-dev"
    cp -R .files/config/sublime-text-3 ~/.config/
    install_package "fasd"
    install_package "virtualbox"
    install_package "virtualbox-host-modules-arch"
    install_package "lxc"
    install_package "vagrant"
    install_package "terminator"
    cp -R .files/config/terminator ~/.config/
    install_package "google-chrome-beta"
    install_package "slack-desktop"
    install_package "dropbox"
    install_package "teamviewer"

    # direct download
    install_wmail
    install_jq
}

function install_vagrant_plugins() {
    vagrant plugin install vagrant-vbguest vagrant-share vagrant-lxc
}

function prepare_python_env() {
    log "Setting up Python environment..."

    sudo pip install pip --upgrade
    sudo pip install virtualenv
    sudo pip install virtualenvwrapper
    sudo pip install wagon
    sudo pip install serv
    sudo pip install ipython
    sudo pip install distro
    sudo pip install ghost
}

function clone_personal_repos() {
    log "Cloning personal repositories..."
    personal_repos_path="~/repos/nir0s"

    mkdir -p $personal_repos_path
    pushd $personal_repos_path

    if [ ! -d "${personal_repos_path}/distro" ]; then
        git clone "git@github.com:nir0s/distro"
    fi
    if [ ! -d "${personal_repos_path}/ghost" ]; then
        git clone "git@github.com:nir0s/ghost"
    fi
    if [ ! -d "${personal_repos_path}/serv" ]; then
        git clone "git@github.com:nir0s/serv"
    fi
    if [ ! -d "${personal_repos_path}/python-packer" ]; then
        git clone "git@github.com:nir0s/python-packer"
    fi
    if [ ! -d "${personal_repos_path}/logrotated" ]; then
        git clone "git@github.com:nir0s/logrotated"
    fi
    if [ ! -d "${personal_repos_path}/roomservice" ]; then
        git clone "git@github.com:natict/roomservice"
    fi

    popd
}

function setup_cloudify_dev_env() {
    log "Setting up Cloudify development environemnt..."
    cloudify_repos_path="~/repos/cloudify"

    mkdir -p $cloudify_repos_path
    export VIRTUALENVWRAPPER_VIRTUALENV="/usr/bin/virtualenv"
    export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python2.7"
    export WORKON_HOME="$HOME/.virtualenvs"
    source "/usr/bin/virtualenvwrapper.sh"

    mkvirtualenv clue
    # workon clue
    # pip install clue
    # clue env create
}

function main() {
    install_packages
    install_vagrant_plugins
    prepare_python_env
    clone_personal_repos
    setup_cloudify_dev_env
    # cp .files/.bashrc ~/.bashrc
    # cp .files/.inputrc ~/.inputrc
}

main

# IntelliJ
# Vault
# Consul
# Setup sublime text
# https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
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

function install_package() {
    package_name="$1"
    log "Installing ${package_name}..."
    sudo yaourt -S --noconfirm $package_name
}

function install_packages() {
    install_package "sublime-text-dev"
    install_package "fasd"
    install_package "terminator"
    cp -R .files/config/terminator ~/.config/
    install_package "google-chrome-beta"
    install_package "slack-desktop"
    install_package "dropbox"
    install_package "teamviewer"
}

function prepare_python_env() {
    log "Setting up Python environment..."

    sudo pip install pip --upgrade
    sudo pip install virtualenv
    sudo pip install virtualenvwrapper
    sudo pip install wagon
    sudo pip install serv
    sudo pip install ipython
}

function clone_personal_repos() {
    log "Cloning personal repositories..."
    personal_repos_path="~/repos/nir0s"

    mkdir -p $personal_repos_path
    pushd $personal_repos_path

    git clone git@github.com:nir0s/distro
    git clone git@github.com:nir0s/serv
    git clone git@github.com:nir0s/python-packer
    git clone git@github.com:nir0s/logrotated
    git clone git@github.com:natict/roomservice

    popd
}

function setup_cloudify_dev_env() {
    log "Setting up Cloudify development environemnt..."
    cloudify_repos_path="~/repos/cloudify"

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
    prepare_python_env
    clone_personal_repos
    setup_cloudify_dev_env
    # cp .files/.bashrc ~/.bashrc
}

main

# IntelliJ
# Setup sublime text
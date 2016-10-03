#!/usr/bin/env bash

######
# Create working environment.
# This will install relevant packages, clone relevant repositories,
# setup a working Python env and.. more..
######

# echo -e "Default \e[32mGreen"
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
    message=$1

    echo "\e[91m$message"
    exit 1
}

function install_package() {
    package_name="$1"

    pacman -Q ${package_Name} &> /dev/null
    if [ $? -ne 0 ]; then
        log "Installing ${package_name}..."
        yaourt -S --noconfirm $package_name || error_exit "Failed to install ${package_name}"
    else
        log "!!! ${package_name} already installed."
    fi
}

function install_wmail() {
    log "Installing Wmail..."
    curl -L https://github.com/Thomas101/wmail/releases/download/v1.3.7/WMail_1_3_7_prerelease_linux_x64.tar.gz -o "$HOME/Downloads/wmail.tar.gz"
    sudo tar -xzvf "$HOME/Downloads/wmail.tar.gz" -C "/opt/wmail"
    sudo ln -sf "/opt/wmail/wmail" "/usr/bin/wmail"
}

function install_jq() {
    jq="/usr/bin/jq"

    log "Installing jq..."
    sudo curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o $jq
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
    cp -R "$HOME/.files-master/config/sublime-text-3/Package Control.sublime-package" "$HOME/.config/sublime-text-3/Installed Packages"
    cp -R "$HOME/.files-master/config/sublime-text-3/Package Control.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
    cp -R "$HOME/.files-master/config/sublime-text-3/Preferences.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
}

function install_packages() {
    title "Installing relevant packages..."
    mkdir -p $HOME/.config
    # yaourt
    install_package "vim"
    install_package "git"
    install_package "ttf-roboto-mono"
    install_sublime
    install_package "fasd"
    install_package "virtualbox"
    install_package "lxc"
    install_package "vagrant"
    install_package "terminator"
    cp -R "$HOME/.files-master/config/terminator" "$HOME/.config/"
    install_package "google-chrome-beta"
    install_package "slack-desktop"
    install_package "dropbox"
    install_package "teamviewer"
    install_package "gnome-shell-extension-taskbar"

    # direct download
    install_wmail
    install_jq
    # install_consul
    # install_vault
}

function install_vagrant_plugins() {
    vagrant plugin install vagrant-vbguest vagrant-share vagrant-lxc
}

function pip_install() {
    package=$1

    log "Installing $package..."
    sudo pip install $package
}

function prepare_python_env() {
    title "Setting up Python environment..."

    # Make idempotent
    if [ ! -f '/tmp/get-pip.py' ]; then
        log "Downloading get-pip.py..."
        curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
    fi
    log "Installing pip for python2 and python3..."
    sudo python3 /tmp/get-pip.py
    sudo python2 /tmp/get-pip.py
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
    path=$1
    destination="$HOME/repos/${2:-path}"

    log "Cloning $path..."
    if [ ! -d "${destination}" ]; then
       git clone "git@github.com:${path}" ${destination}
    else
        log "$path already exists. Assuming cloned."
    fi
}

function create_dev_env() {
    tool=$1
    repo_path="$HOME/repos/nir0s/${tool}"

    log "Creating development environment for $tool..."
    clone_repo "nir0s/${tool}"
    log "Creating virtualenv..."
    mkvirtualenv $tool
    log "Installing $tool..."
    $HOME/.virtualenvs/${tool}/bin/pip install -e $repo_path
}

function setup_private_dev_envs() {
    title "Creating development environments..."
    personal_repos_path="$HOME/repos/nir0s"

    activate_virtualenvwrapper
    mkdir -p $personal_repos_path

    create_dev_env "distro"
    create_dev_env "ghost"
    create_dev_env "serv"
    create_dev_env "python-packer"
    create_dev_env "logrotated"
}

function activate_virtualenvwrapper() {
    export VIRTUALENVWRAPPER_VIRTUALENV="/usr/bin/virtualenv"
    export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python2.7"
    export WORKON_HOME="$HOME/.virtualenvs"
    source "/usr/bin/virtualenvwrapper.sh"
}

function setup_cloudify_dev_env() {
    title "Setting up Cloudify development environemnt..."
    cloudify_repos_path="$HOME/repos/cloudify"

    mkdir -p $cloudify_repos_path
    activate_virtualenvwrapper
    mkvirtualenv clue
    workon clue
    pip install clue
    clue env create -d ~/repos/cloudify --clone-method ssh
    clue apply

    clone_repo "cloudify-cosmo/wagon" "cloudify/wagon"
    clone_repo "cloudify-cosmo/repex" "cloudify/repex"
    clone_repo "cloudify-cosmo/surch" "cloudify/surch"
    clone_repo "cloudify-cosmo/cloudhealth-client" "cloudify/cloudhealth-client"


}

function main() {
    title "Preparing $(hostname)..."
    # install_packages
    # install_vagrant_plugins
    # clone_repo "nir0s/.files"
    # prepare_python_env
    # setup_private_dev_envs
    setup_cloudify_dev_env
    cp $HOME/.files-master/.bashrc $HOME/.bashrc
    cp $HOME/.files-master/.inputrc $HOME/.inputrc
}

main

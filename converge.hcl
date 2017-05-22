package.apt "vim" {
  name  = "vim"
  state = "present"
  group = "apt"
}

package.apt "docker" {
  name  = "docker"
  state = "present"
  group = "apt"
}

package.apt "lxc" {
  name  = "lxc"
  state = "present"
  group = "apt"
}

package.apt "ubuntu-gnome-desktop" {
  name  = "ubuntu-gnome-desktop"
  state = "present"
  group = "apt"
}

package.apt "python-dev" {
  name  = "python-dev"
  state = "present"
  group = "apt"
}

package.apt "build-essential" {
  name  = "build-essential"
  state = "present"
  group = "apt"
}

package.apt "libssl-dev" {
  name  = "libssl-dev"
  state = "present"
  group = "apt"
}

package.apt "libffi-dev" {
  name  = "libffi-dev"
  state = "present"
  group = "apt"
}

package.apt "xclip" {
  name  = "xclip"
  state = "present"
  group = "apt"
}

package.apt "gcc" {
  name  = "gcc"
  state = "present"
  group = "apt"
}

package.apt "virtualbox" {
  name  = "virtualbox"
  state = "present"
  group = "apt"
}

package.apt "jq" {
  name  = "jq"
  state = "present"
  group = "apt"
}

package.apt "terminator" {
  name  = "terminator"
  state = "present"
  group = "apt"
}

package.apt "tree" {
  name  = "tree"
  state = "present"
  group = "apt"
}

file.fetch "sublime.installer.deb" {
  source      = "https://download.sublimetext.com/sublime-text_build-3126_amd64.deb"
  destination = "/tmp/sublime.deb"
}

task "dpkg.install.sublime" {
  check = "dpkg -s sublime-text >/dev/null 2>&1"
  apply = "dpkg -i {{lookup `file.fetch.sublime.installer.deb.destination`}}"
}

file.fetch "fasd.installer" {
  source      = "https://github.com/clvv/fasd/tarball/1.0.1"
  destination = "/tmp/fasd.tar.gz"
}

unarchive "fasd.tgz" {
  source      = "{{lookup `file.fetch.fasd.instasller.destination`}}"
  destination = "/tmp/fasd"
}

task "make.fasd" {
  check = "[ -f /usr/local/bin/fasd ]"
  apply = "make install"
  dir   = "{{lookup `unarchive.fasd.tgz.destination`}}/clvv-fasd-4822024"
}

file.fetch "dropbox.installer.deb" {
  source      = "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb"
  destination = "/tmp/dropbox.deb"
  # cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
}

task "dpkg.install.dropbox" {
  check = "dpkg -s dropbox >/dev/null 2>&1"
  apply = "dpkg -i {{lookup `file.fetch.dropbox.installer.deb.destination`}}"
}

file.fetch "slack.installer.deb" {
  source      = "https://downloads.slack-edge.com/linux_releases/slack-desktop-2.6.0-amd64.deb"
  destination = "/tmp/slack.deb"
}

task "dpkg.install.slack" {
  check = "dpkg -s slack-desktop >/dev/null 2>&1"
  apply = "dpkg -i {{lookup `file.fetch.slack.installer.deb.destination`}}"
}

# slack
# teamviewer
# dropbox
# fasd
# vagrant (+plugins)
# terminator (+config)
# sublime-text-3 (+config)
# docker
# lxc
# build-essential libssl-dev libffi-dev
# ubuntu-gnome-desktop
# python-dev
# gcc
# xclip
# virtualbox
# python36
# jq

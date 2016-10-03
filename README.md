# My Work Environment

This sets up my working environment ready with the required packages, dot files, python environment and more.

Before running `setup.sh`, copy the relevant ssh keys to `~/.ssh` as that's a prerequisite for cloning relevant github repos.

# Usage

```bash
cd /tmp && curl -OL https://github.com/nir0s/.files/archive/master.tar.gz && tar -xzvf /tmp/master.tar.gz && rm /tmp/master.tar.gz

cd /tmp/.files-master && ./setup.sh
```
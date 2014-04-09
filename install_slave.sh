#! /usr/bin/env bash

# Sets up a slave Jenkins server intended to run devstack-based Jenkins jobs

set -e

THIS_DIR=`pwd`

DATA_REPO_INFO_FILE=$THIS_DIR/.data_repo_info
DATA_PATH=$THIS_DIR/data
OSEXT_PATH=$THIS_DIR/os-ext-testing
OSEXT_REPO=https://github.com/jaypipes/os-ext-testing
CONFIG_MODULES=$THIS_DIR/config/modules
PUPPET_MODULE_PATH="--modulepath=$OSEXT_PATH/puppet/modules:$CONFIG_MODULES:/etc/puppet/modules"

sudo apt-get update
sudo apt-get install -y wget openssl ssl-cert ca-certificates

# Install Puppet and the OpenStack Infra Config source tree
sudo bash -xe install_puppet.sh
sudo bash install_modules.sh

# Pulling in variables from data repository
. $DATA_PATH/vars.sh

# Validate that the upstream gerrit user and key are present in the data
# repository
if [[ -z $UPSTREAM_GERRIT_USER ]]; then
    echo "Expected to find UPSTREAM_GERRIT_USER in $DATA_PATH/vars.sh. Please correct. Exiting."
    exit 1
else
    echo "Using upstream Gerrit user: $UPSTREAM_GERRIT_USER"
fi

if [[ ! -e "$DATA_PATH/$UPSTREAM_GERRIT_SSH_KEY_PATH" ]]; then
    echo "Expected to find $UPSTREAM_GERRIT_SSH_KEY_PATH in $DATA_PATH. Please correct. Exiting."
    exit 1
fi
export UPSTREAM_GERRIT_SSH_PRIVATE_KEY_CONTENTS=`cat "$DATA_PATH/$UPSTREAM_GERRIT_SSH_KEY_PATH"`

# Validate there is a Jenkins SSH key pair in the data repository
if [[ -z $JENKINS_SSH_KEY_PATH ]]; then
    echo "Expected to find JENKINS_SSH_KEY_PATH in $DATA_PATH/vars.sh. Please correct. Exiting."
    exit 1
elif [[ ! -e "$DATA_PATH/$JENKINS_SSH_KEY_PATH" ]]; then
    echo "Expected to find Jenkins SSH key pair at $DATA_PATH/$JENKINS_SSH_KEY_PATH, but wasn't found. Please correct. Exiting."
    exit 1
else
    echo "Using Jenkins SSH key path: $DATA_PATH/$JENKINS_SSH_KEY_PATH"
    JENKINS_SSH_PRIVATE_KEY_CONTENTS=`sudo cat $DATA_PATH/$JENKINS_SSH_KEY_PATH`
    JENKINS_SSH_PUBLIC_KEY_CONTENTS=`sudo cat $DATA_PATH/$JENKINS_SSH_KEY_PATH.pub`
fi

CLASS_ARGS="ssh_key => '$JENKINS_SSH_PUBLIC_KEY_CONTENTS', "
CLASS_ARGS="$CLASS_ARGS jenkins_url => '$JENKINS_URL', "

sudo puppet apply --verbose $PUPPET_MODULE_PATH -e "class {'os_ext_testing::devstack_slave': $CLASS_ARGS }"

if [[ ! -e /opt/git ]]; then
    sudo mkdir -p /opt/git
    sudo -i python /opt/nodepool-scripts/cache_git_repos.py
    sudo mkdir -p /opt/git/osrg
    sudo git clone https://github.com/osrg/ryu /opt/git/osrg/ryu
fi
if [[ ! -e /home/jenkins/cache ]]; then
    sudo -u jenkins -i /opt/nodepool-scripts/prepare_devstack.sh
fi

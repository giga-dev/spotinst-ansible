#!/bin/bash

function run_command_ec2_user {
    su ec2-user -c "$@"
}

function run_command_root {
    sudo su -c "$(declare -f $1) ; $1"
}

function install_java {
    function download {
        local url=$1
        local target=$2

        wget ${url} -P ${target}
    }
    local javaLocations=/opt/java
    local source=JAVA_URL_HERE
    local filename=$(basename ${source})
    local tmpFolder=$(mktemp -d)

    mkdir -p ${javaLocations}
    pushd ${tmpFolder}
    download ${source} ${tmpFolder}
    tar -zxvf ${filename}
    rm -rf ${filename}
    mv $(ls) current
    mv current ${javaLocations}/

    ls -1 ${javaLocations}
    popd

    rm -rf ${tmpFolder}
}

function setDefaultJava {
    echo "export JAVA_HOME=/opt/java/current" >> ~/.bashrc
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc
}

run_command_root install_java

setDefaultJava
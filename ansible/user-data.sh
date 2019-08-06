#!/bin/bash

function run_command_ec2_user {
    su ec2-user -c "$@"
}


function download {
    local url=$1
    local target=$2

    wget ${url} -P ${target}
}

function install_java {
    local javaLocations=/opt/java
    local source=$1
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

install_java JAVA_URL_HERE

export -f setDefaultJava
run_command_ec2_user setDefaultJava
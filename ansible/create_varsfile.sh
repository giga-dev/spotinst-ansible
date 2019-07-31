#!/bin/bash
DIRNAME=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`

varFileLocation="${DIRNAME}/group_vars/all"

function setup {
    local dirPath=$(dirname ${varFileLocation})
    if [[ ! -e "${dirPath}" ]]; then
        mkdir -p ${dirPath}
    fi

    if [[ -e "${varFileLocation}" ]]; then
        rm -rf ${varFileLocation}
    fi
}
function addVar {
    local var=$1
    local envVar=$2
    local envVal=${!envVar}

    echo "Adding ${var}=${envVal} using ${envVar} env var"
    if [[ -z "${envVal}" ]]; then
        echo "No value found for variable ${var} (${envVar} is not set). Exiting..."
        exit 1
    fi
    echo "${var}: ${envVal}" >> ${varFileLocation}
}


setup

addVar "key_name" "KEY_NAME"
addVar "aws_region" "AWS_REGION"
addVar "vpc_id" "VPC_ID"
addVar "security_group" "SECURITY_GROUP"
addVar "ami_id" "AMI_ID"
addVar "instance_type" "INSTANCE_TYPE"
addVar "availability_zone_region" "AVAILABILITY_ZONE_REGION"
addVar "availability_zone_subnet_id" "AVAILABILITY_ZONE_SUBNET_ID"

### Spotinst configuration

addVar "product_type" "PRODUCT_TYPE"
addVar "spotinst_group_name" "SPOTINST_GROUP_NAME"
addVar "spotinst_instances" "SPOTINST_INSTANCES"

addVar "hosts_file" "HOSTS_FILE"
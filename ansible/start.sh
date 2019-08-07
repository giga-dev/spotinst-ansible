#!/bin/bash

source env.sh

ansible-playbook -i hosts --private-key ${PEM_FILE_LOCATION} create_elastic_group.yml
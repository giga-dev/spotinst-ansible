#!/bin/bash

source env.sh

ansible-playbook -i hosts create_elastic_group.yml
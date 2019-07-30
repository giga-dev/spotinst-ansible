#!/bin/bash

source env.sh

ansible-playbook -i hosts delete_elastic_group.yml
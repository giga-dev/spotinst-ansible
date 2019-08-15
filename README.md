# Spotinst-Ansible


This project is used for starting Spot instances via Spotinst Ansible plugin.

It allows creating group_vars/all file from environment variables (`create_varsfile.sh` file)

It also allows installing a JRE/JDK on the started machines (via SSH)

If you would like to run this locally, copy ansible/env.sh.template to ansible/env.sh and edit the file. Note not to commit this file!

Scripts to be used:

- start.sh - Will create an elastic group in spotinst and create the required machines

- stop.sh - WIll delete the elastic group in spotinst and terminate the related machines







#!/bin/bash
sudo pip3.11 install ansible hvac &>>/opt/ansible.log

ansible-pull -i localhost, -U https://github.com/s-devops-i2/expense-ansible2.git get-secrets.yml -e env=${env} -e role_name=${component} -e vault_token=${vault_token} &>>/opt/ansible.log
ansible-pull -i localhost, -U https://github.com/s-devops-i2/expense-ansible2.git expense-play.yml -e env=${env} -e role_name=${component} -e @~/secrets.json &>>/opt/ansible.log

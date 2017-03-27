#!/bin/bash

#initialize vars
LOGFILE=/var/log/ansible_bootstrap.log
hostname=`hostname | cut -d. -f1`
DATE_FORMAT="+%b %d %T"
DT=`date "$DATE_FORMAT"`
user=`whoami`

### log
plog ()
{
echo -e "${DT} ${hostname} ${user} : $*" | tee -a $LOGFILE
}

## execute commands

execute_cmd ()
{
plog "$* "
eval "$*" >> $LOGFILE 2>&1
return_value="$?"
if [ $return_value -ne 0 ]; then
plog "ERROR: \"$*\" failed."
echo "Ups.. check $LOGFILE for more details"
exit 1
fi
}

#main lets go ..

##install epel-release
execute_cmd "yum install -y epel-release"

##update system
execute_cmd "yum update -y "

##create user
execute_cmd "useradd ansible"
execute_cmd "echo \"ansible\" | passwd ansible --stdin"

##add to sudoers

execute_cmd "echo  \"ansible ALL=(ALL) NOPASSWD: ALL \"  >> /etc/sudoers "

execute_cmd "yum -y install ansible "
execute_cmd "sed -i s/#inventory/inventory/g /etc/ansible/ansible.cfg"
execute_cmd "sed -i s/#sudo_user/sudo_user/g /etc/ansible/ansible.cfg"

#create ssh key pairs for ansible user

execute_cmd "su - ansible -c \" ssh-keygen -f /home/ansible/.ssh/id_rsa -t rsa -N ''\" "

execute_cmd "su - ansible -c \" cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \" "
execute_cmd "su - ansible -c \" ssh-keyscan localhost | grep ecdsa >> ~/.ssh/known_hosts\" "
execute_cmd "su - ansible -c \" chmod 600 ~/.ssh/authorized_keys \" "

execute_cmd "echo \"localhost\" >> /etc/ansible/hosts "

execute_cmd "su - ansible -c \" ansible localhost -m ping \" "


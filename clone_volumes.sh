#!/bin/bash 
#initialize vars
LOGFILE=/var/log/clone_volume.log
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

usage(){
	plog "Usage: $0 source_volume target_volume"
	exit 1
}
	
check_volume(){
	plog "checking volume $1"
	execute_cmd docker volume inspect $1
}

#fun part starts here 

! [[ $# == 2 ]]  && usage

check_volume $1
check_volume $2 

plog "Copying data from $1 to $2" 
execute_cmd docker --rm -it -v $1:/source -v $2:/target alpine sh -c "cd /source ; cp -av . /target"



#!/bin/bash
install_dir=$1
temp_dir=$2
script_path=$3

##install_dir=/home/steam/factorio
##temp_dir=/home/steam/temp
##script_path=/home/steam/factorio_script
######### DO NOT CHANGE ANYTHING BELOW THIS LINE  #########
versionfile=$install_dir"/version.txt"
ftemp=$temp_dir"/ftemp"
PID=`ps -ef | grep x64/factorio | grep -v grep | awk '{print $2}'`

## Check if directories and files exist, if not assume fresh/new install 
if [ ! -d $install_dir ] 
	then
		echo "install dir does not exist, creating."
		mkdir $install_dir
fi
if [ ! -d $temp_dir ]
	then
		echo "temp dir does not exist, creating."
		mkdir $temp_dir
fi
if [ ! -f $versionfile ]
	then
		echo "version file does not exist, creating."
		echo "0.0.0" > $versionfile
fi
## Set standard returnvalue
retvalue=11
## Get current factorio version
cur_ver=$(cat $versionfile)
## Get version from factorio webpage 
got_version=$(wget -qO - https://www.factorio.com/download-headless/stable | awk 'BEGIN { findstr="(headless)";}{if (match($0, findstr)) {theend=RSTART ; {if (match($0,"download page</a>.</p><p></p><h3>")) {thestart=RSTART; thestartl=RLENGTH; theversion=substr($0,thestart+thestartl, theend-thestart-thestartl-2)}; printf("%s", theversion);exit;}}}')
##slask=$(wget -qO - https://www.factorio.com/download-headless/stable)
##echo $slask
##echo $got_version

### Kill factorio process
function CloseFactorio 	{	
		## PID=`ps -ef | grep x64/factorio | grep -v grep | awk '{print $2}'`
		if [ -z $PID ] 
		then echo "No active process found" 
		else echo "Closing factorio with pid "$PID 
		fi	
		kill -15 $PID > /dev/null 2>&1
		retvalue=$?
		##echo "Killed process with returnvalue "$retvalue
		## 0=OK 2=No process started -1=ERROR
			}



if [ $cur_ver != $got_version ]
 then 
	echo "Getting update "$got_version". Updating from version "$cur_ver
	cd $temp_dir
	mkdir $ftemp
	cd $ftemp	
	wget -q https://www.factorio.com/get-download/$got_version/headless/linux64 -O factorio.tar.gz
	echo "Unpacking."
	tar -xzf factorio.tar.gz
	rm factorio.tar.gz
	echo "Shutting down factorio"
	CloseFactorio
	
		if [ $retvalue -gt -1 ]
		  then 
			cd factorio
			echo "Moving new files"
			cp -r * $install_dir
		  else
			echo "Unable to kill process, no files moved."
		fi
	echo "Cleaning up"
	cd $temp_dir
	rm -rf $ftemp
fi

if [ $retvalue = -1 ]
	then
		echo "Update Failed, please try again or do a manual update."
		exit -1
	else
	if [ $retvalue = 11 ] 
		then 
		echo "Nothing to update, putting cake back into the fridge .. :("
		if [ -z $PID ]; then exit 2; echo "exit 2"; fi
		if [ -n $PID ]; then exit 1; echo "exit 1"; fi
		else
		echo "Assuming update was a success, celebrating with cake and icecream *yaaay*"
		echo $got_version > $versionfile
		exit 0
	fi
fi


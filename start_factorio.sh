#!/bin/bash
install_dir="$1"
temp_dir="$2"
script_path="$3"
update=$4
branch="$5"
experimental=$6
factorio_version="$7"
switches="$*:9"
use_screen=$8
echo "Start parameters:" "$@"
echo "Switches: " $switches
if [ -z $install_dir ]; then echo "Install_dir not set. exiting"; exit -1;fi
if [ -z $temp_dir ]; then echo "temp_dir not set. exiting"; exit -1;fi
if [ -z $script_path ]; then echo "script_path not set. exiting"; exit -1;fi
if [ -z $branch ]; then branch="master";fi

save_dir=$1"/saves"
proc_path=$1"/bin/x64/factorio"
./factorio_updater.sh $1 $2 $3 $6
retvalue=$?
function StartFactorio {
    echo "Use screen = "$use_screen
    if [ $use_screen ] 
        then 
        echo "Using screen command when starting server"
        prefactorio="screen -mS factori_screen" 
        else 
        echo "NOT using screen command when starting server"
        prefactorio=""
    fi

    if [ factorio_version = "0.12.35" ]
    then
        savefile1=`ls -ltr $save_dir | grep _autosave | grep -v grep | awk '{print $9}'`
        savefile=`echo $savefile1 | awk '{print $1}'`
        echo "Starting Factorio with savegame "$savefile
         $prefactorio $proc_path --start-server $savefile
        else 
        echo "Starting Factorio"
        $prefactorio $proc_path --start-server $switches
    fi
}

if [ -z $update ]; then update=1; fi
if [ $update = 1 ]; then wget --no-cache --no-check-certificate -qO $script_path"/factorio.sh" "https://raw.githubusercontent.com/PhyRoPalt/factorio_updater/$branch/factorio.sh"; fi

if [ $retvalue = 0 ] 
then
echo "Update finished, starting factorio headless."
StartFactorio

else
    if [ $retvalue = -1 ] ; then echo "Updater/installation failed, not starting factorio. Manual update may be required."; fi
    if [ $retvalue = 1 ]; then echo "No update required, factorio is up and running."; fi
    if [ $retvalue = 2 ]; then echo "No update required, factorio is NOT up and running. Trying to start Factorio headless"; StartFactorio; fi
    #if [ $revalue = 3 ] then; echo "Updater/installation failed, not starting factorio. Manual update may be required." ;fi
    #if [ $revalue = 4 ] then; echo "Updater/installation failed, not starting factorio. Manual update may be required." ;fi
    #if [ $revalue = 5 ] then; echo "Updater/installation failed, not starting factorio. Manual update may be required." ;fi

fi

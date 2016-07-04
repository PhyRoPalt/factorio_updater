#!/bin/bash
install_dir=/home/steam/factorio
temp_dir=/home/steam/temp
script_path=/home/steam/factorio_updater
update=0
switches="--start-server -load-latest --rcon-port 27019 --rcon-password slask"
use_screen=false
# Use factorio stable or experimental ? (true=experimental false=stable)
experimental=true
## script branch "dev" or "master"
branch="dev"

## Please do not change anything below this line
versionfile=$script_path"/version.txt"
got_version=$(wget --no-cache --no-check-certificate -qO - "https://raw.githubusercontent.com/PhyRoPalt/factorio_updater/$branch/version.txt")
version=$(cat $versionfile)
if [ $branch = "dev" ]; then echo "Using Dev branch, will force update of script.";fi 
## https://docs.google.com/uc?authuser=0&id=0B0_cNnjnIOmoaVhsWkszM0t1QUk&export=download  start_factorio.sh Outdated
## https://docs.google.com/uc?authuser=0&id=0B0_cNnjnIOmod3ZIWWd2V2VmVEE&export=download  factorio_updater.sh Outdated
echo "Checking script-version online : "$got_version
if [ $version != $got_version ] || [ $branch = "dev" ]
        then 
        echo "Updating script.."
        update=1
        wget --no-cache --no-check-certificate -qO $script_path"/start_factorio.sh" "https://raw.githubusercontent.com/PhyRoPalt/factorio_updater/$branch/start_factorio.sh"
        wget --no-cache --no-check-certificate -qO $script_path"/factorio_updater.sh" "https://raw.githubusercontent.com/PhyRoPalt/factorio_updater/$branch/factorio_updater.sh"
        wget --no-cache --no-check-certificate -qO $script_path"/READ.me" "https://raw.githubusercontent.com/PhyRoPalt/factorio_updater/$branch/READ.me"
        wget --no-cache --no-check-certificate -qO $script_path"/changelog.txt" "https://raw.githubusercontent.com/PhyRoPalt/factorio_updater/$branch/changelog.txt"
        chmod +x *factorio*
        echo $got_version > $versionfile
fi
echo "Starting factorio updater"
./start_factorio.sh $install_dir $temp_dir $script_path $update $branch $experimental $got_version $use_screen $switches
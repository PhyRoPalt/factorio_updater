#!/bin/bash
install_dir=/home/steam/factorio
temp_dir=/home/steam/temp
script_path=/home/steam/factorio_updater
update=0
## Branch "dev" or "master"
branch="dev"
versionfile=$script_path"/version.txt"
got_version=$(wget --no-check-certificate -qO - "https://raw.githubusercontent.com/PhyRoPalt/factorio_updater/$branch/version.txt")
version=$(cat $versionfile)
## https://docs.google.com/uc?authuser=0&id=0B0_cNnjnIOmoaVhsWkszM0t1QUk&export=download  start_factorio.sh Outdated
## https://docs.google.com/uc?authuser=0&id=0B0_cNnjnIOmod3ZIWWd2V2VmVEE&export=download  factorio_updater.sh Outdated
echo "Checking script-version online : "$got_version
if [ $version != $got_version ] 
        then 
        echo "Updating script.."
        update=1
        wget --no-check-certificate -qO $script_path"/start_factorio.sh" "https://raw.githubusercontent.com/PhyRoPalt/factorio_updater/$branch/start_factorio.sh"
        wget --no-check-certificate -qO $script_path"/factorio_updater.sh" "https://raw.githubusercontent.com/PhyRoPalt/factorio_updater/$branch/factorio_updater.sh"
        wget --no-check-certificate -qO $script_path"/READ.me" "https://raw.githubusercontent.com/PhyRoPalt/factorio_updater/$branch/READ.me"
        wget --no-check-certificate -qO $script_path"/changelog.txt" "https://raw.githubusercontent.com/PhyRoPalt/factorio_updater/$branch/changelog.txt"
        chmod +x *factorio*
        echo $got_version > $versionfile
fi
echo "Starting factorio updater"
./start_factorio.sh $install_dir $temp_dir $script_path $update $branch
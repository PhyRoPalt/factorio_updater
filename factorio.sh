#!/bin/bash
install_dir=/home/steam/factorio
temp_dir=/home/steam/temp
script_path=/home/steam/factorio_updater

versionfile=$script_path"/version.txt"
got_version=$(wget --no-check-certificate -qO - "https://docs.google.com/uc?authuser=0&id=0B0_cNnjnIOmoa05ZRVlNamNiOG8&export=download")
version=$(cat $versionfile)
## https://docs.google.com/uc?authuser=0&id=0B0_cNnjnIOmoaVhsWkszM0t1QUk&export=download  start_factorio.sh
## https://docs.google.com/uc?authuser=0&id=0B0_cNnjnIOmod3ZIWWd2V2VmVEE&export=download  factorio_updater.sh
echo "Checking script-version online : "$got_version
if [ $version != $got_version ] 
        then 
        echo "Updating script.."
        wget --no-check-certificate -qO $script_path"/start_factorio.sh" "https://docs.google.com/uc?authuser=0&id=0B0_cNnjnIOmoaVhsWkszM0t1QUk&export=download"
        wget --no-check-certificate -qO $script_path"/factorio_updater.sh" "https://docs.google.com/uc?authuser=0&id=0B0_cNnjnIOmod3ZIWWd2V2VmVEE&export=download"
        echo $got_version > $versionfile
fi
echo "Starting factorio updater"
./start_factorio.sh $install_dir $temp_dir $script_path

#!/bin/bash
################################################################################
#
# Script:       initialize.sh
# Version:      1.00
# Last Updated: 17 April 2016
# Updated By:   D Sanders, University of Liverpool
# Student ID:   H00035340
#
################################################################################
#
# Updates
# -------
# Who        | When         | Why
# -----------|--------------|--------------------------------------------------
# D Sanders  | 17 April 16  | Finalized version for submission.
#
################################################################################
#
# Purpose: The script ensures that the simulation engine and all models (Docker
#          containers and images) are up to date. This is the first script that
#          should be run when preparing a simulation environment.
#
################################################################################
#
# Usage
# -----
# $simpath/run-docker.sh -c name -n Name [-d] [-q] [-r] [-q] \
#    [-p >1023] [-R >1023] [-s /absolute/path] [-n service-name] \
#    [-z servername] [-v version] [-h]
#
# Parameters
# ----------
# None. It uses the same check_params script to set variables but IGNORES them
# completely.
#
################################################################################
let stage_count=0
stage_path="v3_00"
current_directory=$(pwd)

source $simpath/includes/check_params.sh
source $simpath/includes/setup.sh
source $simpath/includes/set_version.sh

sim_heading="Downloading Docker Images"

pause "Pull down of latest Docker containers, "

set +e
#clear
start_message "${sim_heading} - git repo"

let stage_count=stage_count+1
pre_test $stage_count "Ensure studysim is up to date"
cd $simpath
git pull
cd $current_directory

echo
start_message "${sim_heading} - base"
let stage_count=stage_count+1
pre_test $stage_count "Base container"
docker pull $package"base" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

echo
start_message "${sim_heading} - Pull down v3_00 containers"
version="v3_00"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v3_00 bluetooth"
docker pull $package""$version"_bluetooth" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v3_00 location service"
docker pull $package""$version"_location_service" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v3_00 logger"
docker pull $package""$version"_logger" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v3_00 log viewer"
docker pull $package""$version"_log_viewer" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v3_00 monitor app"
docker pull $package""$version"_monitor_app" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v3_00 notification service"
docker pull $package""$version"_notification" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v3_00 phone"
docker pull $package""$version"_phone" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v3_00 phone screen"
docker pull $package""$version"_phone_screen" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

stop_message "${sim_heading} $version"

#
# v3_01
#
echo
start_message "${sim_heading} - Pull down v3_01 containers"
version="v3_01"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v3_01 bluetooth"
docker pull $package""$version"_bluetooth" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v3_01 Monitor App"
docker pull $package""$version"_monitor_app" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v3_01 Phone"
docker pull $package""$version"_phone" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

stop_message "${sim_heading} $version"

#
# v4_00
#
echo
start_message "${sim_heading} - Pull down v4_00 containers"
version="v4_00"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v4_00 Context"
docker pull $package""$version"_context" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v1_00 Door Bell"
docker pull $package"v1_00_door_bell" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v4_00 Monitor App"
docker pull $package""$version"_monitor_app" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v4_00 Notification Service"
docker pull $package""$version"_notification" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v4_00 Phone"
docker pull $package""$version"_phone" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

let stage_count=stage_count+1
pre_test $stage_count "Pull down v1_00 Presence"
docker pull $package"v1_00_presence" > /tmp/docker-download.log
cat /tmp/docker-download.log | grep "Error\|Status"

rm /tmp/docker-download.log

echo

stop_message "${sim_heading} $version"


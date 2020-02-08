#!/bin/sh

extra_args=""
if [ "$1" == "up" ]; then
    if [ -z "$2" ]; then
    	echo "\nEnvironment name is required, run with the arguments: '$1 <environment_name>' \n"
    	exit 1
	fi
	export ENVIRONMENT_NAME=$2
	extra_args="-d --force-recreate"
fi

if (docker-compose -f ci/concourse.yml $1 $extra_args); then
	if [ "$1" == "up" ]; then
		echo ""
		echo "----------------------------------------------------------------"
		echo "Concourse CI is running on http://localhost:8080 (admin / admin)"
		echo "----------------------------------------------------------------"
	fi
fi
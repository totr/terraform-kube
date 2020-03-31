#!/bin/sh

extra_args=""
if [ "$1" == "up" ]; then
    if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
		echo "\nThe following parameters are required: \n"
		echo "environment_git_repo_uri:   git repository containing terraform variables"
		echo "environment_group_name:     terraform environment group name"
		echo "environment_name:           terraform config file name\n"
		echo "Example: ./ci.sh up https://github.com/totr/terraform-kube-environments customer1 prod\n"
		exit 1
	fi
	export ENVIRONMENT_GIT_REPO_URI=$2
	export ENVIRONMENT_GROUP_NAME=$3
	export ENVIRONMENT_NAME=$4
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
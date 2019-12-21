#!/bin/sh

extra_args=""
if [ "$1" == "up" ]; then
	extra_args="-d --force-recreate"
fi

if (docker-compose -f concourse-ci.yml $1 $extra_args); then
	if [ "$1" == "up" ]; then
		echo ""
		echo "----------------------------------------------------------------"
		echo "Concourse CI is running on http://localhost:8080 (admin / admin)"
		echo "----------------------------------------------------------------"
	fi
fi
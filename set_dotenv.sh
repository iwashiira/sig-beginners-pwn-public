#!/bin/sh

if [ -e .env ]; then
		rm .env
fi

touch .env
echo "UID=$(id -u $USER)" >> .env
echo "GID=$(id -g $USER)" >> .env
echo "USERNAME=$USER" >> .env
echo "GROUPNAME=$USER" >> .env

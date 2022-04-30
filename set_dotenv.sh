#!/bin/sh

if [ -e .env ]; then
		rm .env
fi

touch .env
echo "UID=$(id -u $USER)" >> .env
echo "GID=1000" >> .env
echo "USERNAME=$USER" >> .env
echo "GROUPNAME=pwner" >> .env

#!/usr/bin/env sh

export VERSION=develop
docker-compose build --no-cache netbox
docker-compose up -d

#!/usr/bin/env bash
rm Gemfile.lock
touch Gemfile.lock
docker-compose pull
docker-compose build
docker-compose up

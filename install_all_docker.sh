#/bin/bash

docker-compose -f ./redis/docker-compose.yml up -d --build
docker-compose -f ./mongodb/docker-compose.yml up -d --build
docker-compose -f ./postgres/docker-compose.yml up -d --build
docker-compose -f ./evolution-api/docker-compose.yml up -d --build
docker-compose -f ./chatwoot/docker-compose.yml up -d --build
docker-compose -f ./chatwoot/docker-compose.yml run --rm rails bundle exec rails db:chatwoot_prepare
docker-compose -f ./typebot.io/docker-compose.yml up -d --build


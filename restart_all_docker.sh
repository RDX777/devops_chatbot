docker-compose -f ./redis/docker-compose.yml restart
docker-compose -f ./mongodb/docker-compose.yml restart
docker-compose -f ./postgres/docker-compose.yml restart
docker-compose -f ./evolution-api/docker-compose.yml restart
docker-compose -f ./chatwoot/docker-compose.yml restart
docker-compose -f ./typebot.io/docker-compose.yml restart
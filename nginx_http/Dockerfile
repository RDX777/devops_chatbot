FROM nginx:alpine

WORKDIR /etc/nginx/

ENV TZ=America/Sao_Paulo

RUN cat /etc/os-release
RUN apk update && apk upgrade
RUN apk add --no-cache bash nano

EXPOSE 80

# CMD ["nginx", "-g", "daemon on;"]
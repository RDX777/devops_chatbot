FROM nginx:alpine

WORKDIR /etc/nginx/

ENV TZ=America/Sao_Paulo

RUN cat /etc/os-release
RUN apk update && apk upgrade
RUN apk add --no-cache bash nano openssl
RUN mkdir -p /etc/nginx/ssl
RUN openssl genrsa -out "/etc/nginx/ssl/default.key" 2048
RUN openssl req -new -key "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.csr" -subj "/CN=MDG Intermediacoes/O=Cosmic Zapilus/C=BR"
RUN openssl x509 -req -days 365 -in "/etc/nginx/ssl/default.csr" -signkey "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.crt"

RUN chmod 644 /etc/nginx/ssl/default.key

EXPOSE 80
EXPOSE 443

# CMD ["nginx", "-g", "daemon on;"]
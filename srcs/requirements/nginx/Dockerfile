# penultimate stable version Debian
FROM debian:bullseye 

# update, upgrade and install nginx and openssl
RUN apt-get update && apt upgrade -y
RUN apt-get install -y nginx openssl

# copy config to the container
COPY ./configurations/nginx.conf /etc/nginx/nginx.conf

# create directory for wordpress and change owner to www-data
RUN mkdir -p /var/www/wordpress
RUN chown -R www-data:www-data /var/www/wordpress

# copy entrypoint.sh to the container, make it executable and run it every start
COPY ./configurations/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

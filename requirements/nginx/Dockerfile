FROM debian:bullseye

RUN apt-get update && apt upgrade
RUN apt-get install -y nginx

CMD ["ngix", "-g", "daemon off;"]
FROM debian:bullseye

RUN apt-get update && apt upgrade
RUN apt-get install -y ngix

CMD ["ngix", "-g", "daemon off;"]
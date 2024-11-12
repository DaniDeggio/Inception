FROM debian:lastest

RUN apt update && apt upgrade && apt install -y ngix

CMD ["ngix", "-g", "daemon off;"]
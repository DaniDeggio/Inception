# penultimate Debian stable version
FROM debian:bullseye

# update, upgrade and install mariadb
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y mariadb-server

# copy entrypoint.sh to the container, make it executable and run it every start
COPY ./configurations/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
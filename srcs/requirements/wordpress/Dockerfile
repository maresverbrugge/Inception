# Wordpress Dockerfile

# pull the base image
FROM debian:bullseye

# update and upgrade the system
RUN apt-get update && apt-get upgrade -y

# install the required packages
# curl for installing wp-cli from github
# php and php-fpm and php-mysql for CGI
# mariadb-client to make wordpress client of mariadb (server will be in mariadb container)
# netcat for ping mariadb
RUN apt-get install -y curl php php7.4-fpm php-mysql mariadb-client netcat

# copy the wordpress configuration script to the root directory in the container
COPY ./tools/wp_conf.sh /

# change the permission of the script to make it executable
RUN  chmod +x wp_conf.sh

# run wp_configuration script when the container starts
ENTRYPOINT ["./wp_conf.sh"]